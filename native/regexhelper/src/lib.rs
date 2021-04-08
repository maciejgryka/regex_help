use grex::{Feature, RegExpBuilder};

#[rustler::nif]
fn build_expression(s: String, repetitions: bool) -> String {
    let lines: Vec<&str> = s.lines().collect();
    let mut regexp = RegExpBuilder::from(&lines);
    if repetitions {
        regexp.with_conversion_of(&[Feature::Repetition]);
    }
    regexp.build()
}

rustler::init!("Elixir.RegexHelper", [build_expression]);
