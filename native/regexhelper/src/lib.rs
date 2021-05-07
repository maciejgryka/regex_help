use regex::Regex;

use grex::{Feature, RegExpBuilder};

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
) -> String {
    let lines: Vec<&str> = query.lines().collect();

    let mut regexp = RegExpBuilder::from(&lines);
    let mut features: Vec<Feature> = Vec::new();
    if digits {
        features.push(Feature::Digit);
    }
    if spaces {
        features.push(Feature::Space);
    }
    if words {
        features.push(Feature::Word);
    }
    if repetitions {
        features.push(Feature::Repetition);
    }
    if ignore_case {
        features.push(Feature::CaseInsensitivity);
    }
    if capture_groups {
        features.push(Feature::CapturingGroup)
    }
    if features.len() > 0 {
        regexp.with_conversion_of(&features);
    }

    match verbose {
        true => regexp.with_verbose_mode().build(),
        false => regexp.build()
    }
}

#[rustler::nif]
fn check(queries: Vec<String>, expression: &str) -> Vec<bool> {
    match Regex::new(expression) {
        Ok(re) => queries.into_iter().map(|query| { re.is_match(&query) }).collect(),
        Err(_) => queries.into_iter().map(|_| { false }).collect(),
    }
}

rustler::init!("Elixir.RegexHelper", [build_expression, check]);
