use regex::Regex;

use grex::RegExpBuilder;

#[rustler::nif]
fn build_expression(
    query: String,
    digits: bool,
    spaces: bool,
    words: bool,
    repetitions: bool,
    ignore_case: bool,
    capture_groups: bool,
    verbose: bool,
    escape: bool
) -> String {
    let lines: Vec<&str> = query.lines().collect();

    let mut builder = RegExpBuilder::from(&lines);

    if digits { builder.with_conversion_of_digits(); }
    if spaces { builder.with_conversion_of_whitespace(); }
    if words { builder.with_conversion_of_words(); }
    if repetitions { builder.with_conversion_of_repetitions(); }
    if ignore_case { builder.with_case_insensitive_matching(); }
    if capture_groups { builder.with_capturing_groups(); }
    if verbose { builder.with_verbose_mode(); }
    if escape { builder.with_escaping_of_non_ascii_chars(false); }

    builder.build()
}

#[rustler::nif]
fn check(queries: Vec<String>, expression: &str) -> Vec<bool> {
    match Regex::new(expression) {
        Ok(re) => queries.into_iter().map(|query| { re.is_match(&query) }).collect(),
        Err(_) => queries.into_iter().map(|_| { false }).collect(),
    }
}

rustler::init!("Elixir.RegexHelper", [build_expression, check]);
