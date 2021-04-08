use grex::{Feature, RegExpBuilder};

#[rustler::nif]
fn build_expression(
    s: String,
    digits: bool,
    spaces: bool,
    words: bool,
    repetitions: bool,
    ignore_case: bool,
    capture_groups: bool,
) -> String {
    let lines: Vec<&str> = s.lines().collect();

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
    regexp.build()
}

rustler::init!("Elixir.RegexHelper", [build_expression]);
