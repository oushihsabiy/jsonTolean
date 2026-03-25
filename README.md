# jsonTolean_informal

Converts mathematical exercise JSON files directly into Lean 4 proof files, **without** the intermediate `concise_to_lean` restructuring step.

This project is based on `jsonTolean-main` but removes the Definition/Hypothesis/Goal rewriting stage. The LLM receives the raw (informal) problem text and formalizes it into Lean directly.

## Pipeline

```
JSON input → Preprocess → jsonTolean → Lean 4 files
```

1. **Preprocess**: Copies `problem_finally` → `problem`; drops extra fields.
2. **jsonTolean**: Sends each exercise to the LLM with the informal prompt; generates individual `.lean` files.

## Layout

- `main.py`: pipeline runner
- `src/helpers.py`: shared utilities (config loading, JSON I/O, exercise detection, streaming)
- `src/jsonTolean.py`: JSON → Lean conversion
- `src/prompt/json_to_lean.md`: prompt for informal-to-Lean generation
- `settings.json`: root settings
- `config.json`: API credentials (ignored by Git)
- `config.example.json`: template for API credentials

## Configuration

Create a local `config.json` from `config.example.json` and fill in:

- `api_key`
- `base_url`
- `model`

Runner settings live in the root `settings.json`.

## Usage

Place JSON files in the `input_json/` directory, then run:

```bash
# Process all JSON files in input_json/
python main.py --mode book

# Process a single file
python main.py --input input_json/test.json

# Overwrite existing outputs
python main.py --overwrite
```

Outputs:
- `work/` — intermediate preprocessed JSON
- `output_lean/<stem>/` — individual Lean 4 files

## Differences from jsonTolean-main

| Feature | jsonTolean-main | jsonTolean_informal |
|---------|----------------|---------------------|
| concise_to_lean step | Yes (restructures problem into Definition/Hypothesis/Goal) | **No** (skipped entirely) |
| Problem format sent to LLM | Structured | Raw/informal |
| `--skip-concise` flag | Available | Not needed (always skipped) |
| `src/stdjson/concise_to_lean.py` | Present | **Removed** |
| `src/prompt/concise_to_lean.md` | Present | **Removed** |

## License

Released under the Apache 2.0 license. See LICENSE for details.
