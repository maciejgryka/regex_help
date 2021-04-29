FROM ubuntu:20.04 AS build


RUN apt-get update -q && apt-get install -yq curl locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV HOME=/root

RUN apt-get update -q && apt-get install -yq build-essential git unzip autoconf libncurses5-dev libssl-dev python

WORKDIR /app

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
ENV PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
RUN echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc

COPY .tool-versions ./
# install asdf plugins listed in .tool-versions
RUN cat .tool-versions | awk '{print $1}' | xargs -n 1 asdf plugin add
RUN asdf install

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs ./
COPY mix.lock ./
COPY config ./config

RUN mix do deps.get --only prod, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# If using TailwindCSS, there is a special "purge" step and that requires the
# code to see what is being used. So pull the project source in here.
COPY . .
RUN npm run --prefix ./assets deploy
RUN mix do compile, phx.digest, release

# prepare release docker image
FROM ubuntu:20.04 AS app
RUN apt-get update -q && apt-get install -y libncurses5-dev libssl-dev locales

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /app
USER nobody
COPY --from=build --chown=nobody:nogroup /app/_build/prod/rel/regex_help ./

ADD entrypoint.sh ./
ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["bin/regex_help", "start"]