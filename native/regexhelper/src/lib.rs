#[rustler::nif]
fn reverse(s: String) -> String {
    s.chars().rev().collect()
}

rustler::init!("Elixir.RegexHelper", [reverse]);
