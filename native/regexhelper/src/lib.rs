use grex::RegExpBuilder;

#[rustler::nif]
fn shuffle(s: String) -> String {
    let lines: Vec<&str> = s.lines().collect();
    RegExpBuilder::from(&lines).build()
}

rustler::init!("Elixir.RegexHelper", [shuffle]);
