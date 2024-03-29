# install Elixir deps
FROM elixir:1.14.0 AS build_elixir
WORKDIR /app
ENV LANG=C.UTF-8 \
    LANGUAGE=C:en \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    MIX_ENV=prod \
    SECRET_KEY_BASE=nokey

# install Rust following https://github.com/rust-lang/docker-rust/blob/77e77508828ca2da1a9b7582d079b2d77f8b9a1a/1.52.1/buster/Dockerfile
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.63.0
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='fb3a7425e3f10d51f0480ac3cdb3e725977955b2ba21c9bdac35309563b115e8' ;; \
    armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='f263e170da938888601a8e0bc822f8b40664ab067b390cf6c4fdb1d7c2d844e7' ;; \
    arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='de1dddd8213644cba48803118c7c16387838b4d53b901059e01729387679dd2a' ;; \
    i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='66c03055119cecdfc20828c95429212ae5051372513f148342758bb5d0130997' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.24.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN mix local.rebar --force && \
    mix local.hex --if-missing --force
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get --only prod, deps.compile

# TODO: separate test and front-end

# test stage, only used with `--target test`
FROM build_elixir AS test
# install required node version
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -q && apt-get install -y nodejs

ENV MIX_ENV=test
# get all deps, not just production
RUN mix do deps.get, deps.compile
# install node packages
COPY assets assets
RUN npm --prefix ./assets install
COPY lib lib
COPY rel rel
COPY native native
COPY test test
COPY script script
COPY .formatter.exs .formatter.exs
COPY .credo.exs .credo.exs
RUN mix compile
RUN mix assets.deploy
CMD ./script/test

# make a release bundle
FROM build_elixir AS release
# RUN apt-get update -q && apt-get install -y npm
WORKDIR /app
ENV LANG=C.UTF-8 \
    LANGUAGE=C:en \
    LC_ALL=C.UTF-8 \
    MIX_ENV=prod \
    SECRET_KEY_BASE=nokey
COPY lib lib
COPY rel rel
COPY native native
RUN mix do compile, release

# prepare release docker image
FROM erlang:25.0-slim AS app
WORKDIR /app
ENV LANG=C.UTF-8 \
    LANGUAGE=C:en \
    LC_ALL=C.UTF-8 \
    MIX_ENV=prod \
    SECRET_KEY_BASE=nokey \
    PORT=4000 \
    USER=phoenix
RUN apt-get update -q && apt-get install -y libncurses5-dev libssl-dev
RUN groupadd -g 1000 "${USER}" && \
    useradd --shell /bin/sh --uid 1000 --gid "${USER}" --home-dir /home/"${USER}" --create-home "${USER}" && \
    chown "${USER}":"${USER}" /home/"${USER}"
COPY --from=release --chown=phoenix:phoenix /app/_build/prod/rel/regex_help ./
COPY --from=test --chown=phoenix:phoenix /app/priv ./priv
CMD ["bin/regex_help", "start"]
