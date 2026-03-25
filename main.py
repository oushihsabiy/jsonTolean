#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""jsonTolean_informal pipeline entry point.

Usage:
    python main.py --mode book --input input_json/test.json

Pipeline (simplified — no concise_to_lean step):
    1. Preprocess: problem_finally → problem; drop extra fields
    2. jsonTolean: convert each exercise into an individual Lean 4 file
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional

from openai import OpenAI

# Make src/ importable
_ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(_ROOT / "src"))

from helpers import (  # noqa: E402
    DEFAULT_MAX_TOKENS,
    DEFAULT_TIMEOUT_SECONDS,
    iter_exercise_objects,
    load_config,
    read_json,
    require_str,
    write_json,
)
from jsonTolean import (  # noqa: E402
    convert_json_to_lean,
    load_lean_prompt,
)


# ---------------------------------------------------------------------------
# Settings
# ---------------------------------------------------------------------------

def load_settings(path: Optional[Path] = None) -> Dict[str, Any]:
    if path is None:
        path = _ROOT / "settings.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("settings.json must contain a JSON object.")
    return data


# ---------------------------------------------------------------------------
# Step 0 — Preprocess
# ---------------------------------------------------------------------------

FIELDS_TO_DROP = ["problem_with_context", "problem_standardized_math", "problem_finally"]


def preprocess(data: Any) -> Any:
    """For every exercise object in data:
    1. Copy problem_finally → problem  (if problem_finally exists)
    2. Delete problem_with_context, problem_standardized_math, problem_finally
    """
    exercises = list(iter_exercise_objects(data))
    for ex in exercises:
        # Overwrite problem with problem_finally when available
        pf = ex.get("problem_finally")
        if isinstance(pf, str) and pf.strip():
            ex["problem"] = pf

        # Remove extra fields
        for key in FIELDS_TO_DROP:
            ex.pop(key, None)

    return data


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "jsonTolean_informal pipeline — preprocess → Lean 4 files.\n"
            "Skips the concise_to_lean restructuring step.\n"
            "With no arguments, processes all JSON files in RAWJSON_SRC_DIR (default: input_json/)."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--mode", default="book", choices=["book"],
        help="Pipeline mode (default: book).",
    )
    parser.add_argument(
        "--input", default=None, dest="input_json",
        help="Path to a single input JSON file. Omit to process all files in RAWJSON_SRC_DIR.",
    )
    parser.add_argument(
        "--output-dir", default=None, dest="output_dir",
        help="Directory for Lean output files (default: output_lean/<stem>/).",
    )
    parser.add_argument(
        "--overwrite", action="store_true",
        help="Overwrite existing outputs.",
    )
    parser.add_argument(
        "--settings", default=None,
        help="Path to settings.json (default: settings.json in project root).",
    )
    return parser.parse_args()


def process_file(
    input_path: Path,
    *,
    work_dir: Path,
    lean_out_dir: Optional[Path],
    client: OpenAI,
    model: str,
    overwrite: bool,
    lean_prompt: str,
) -> int:
    """Run the 2-step pipeline for a single JSON file.
    Returns the number of Lean files written."""
    out_dir = lean_out_dir if lean_out_dir else _ROOT / "output_lean" / input_path.stem

    # ── Step 0: Load & preprocess ──────────────────────────────────────────
    print(f"[step 0] loading & preprocessing {input_path.name}", file=sys.stderr)
    data = read_json(input_path)
    data = preprocess(data)

    preprocessed_path = work_dir / f"{input_path.stem}_preprocessed.json"
    write_json(preprocessed_path, data)
    print(f"  → preprocessed JSON saved to {preprocessed_path}", file=sys.stderr)

    # ── Step 1: jsonTolean (directly, no concise_to_lean) ──────────────────
    print(f"[step 1] jsonTolean: generating Lean 4 files → {out_dir}", file=sys.stderr)
    written = convert_json_to_lean(
        preprocessed_path,
        out_dir,
        client=client,
        model=model,
        base_prompt=lean_prompt,
        max_tokens=8192,
        max_attempts=5,
        overwrite=overwrite,
    )

    print(f"{'='*60}", file=sys.stderr)
    print(f"DONE [{input_path.name}] — {len(written)} Lean file(s) in {out_dir}", file=sys.stderr)
    return len(written)


def main() -> None:
    args = parse_args()
    settings_path = Path(args.settings).resolve() if args.settings else None
    settings = load_settings(settings_path)
    config = load_config()

    work_dir = _ROOT / settings.get("WORK_DIR", "work")
    work_dir.mkdir(parents=True, exist_ok=True)

    max_tokens = int(settings.get("OCR_MAX_TOKENS") or DEFAULT_MAX_TOKENS)
    overwrite = args.overwrite or bool(settings.get("OVERWRITE_JSON", False))

    # Build OpenAI client (once, shared across all files)
    api_key = require_str(config, "api_key")
    base_url = require_str(config, "base_url")
    model = require_str(config, "model")
    client = OpenAI(api_key=api_key, base_url=base_url, timeout=DEFAULT_TIMEOUT_SECONDS)
    lean_prompt = load_lean_prompt()

    # Resolve input file list
    if args.input_json:
        # Single file specified explicitly
        input_files = [Path(args.input_json).expanduser().resolve()]
        missing = [f for f in input_files if not f.exists()]
        if missing:
            print(f"[error] input file not found: {missing[0]}", file=sys.stderr)
            sys.exit(1)
    else:
        # Batch mode: scan RAWJSON_SRC_DIR for all *.json files
        raw_src = _ROOT / settings.get("RAWJSON_SRC_DIR", "input_json")
        if not raw_src.exists():
            print(f"[error] RAWJSON_SRC_DIR not found: {raw_src}", file=sys.stderr)
            print("  Place JSON files there or use --input <file>.", file=sys.stderr)
            sys.exit(1)
        input_files = sorted(raw_src.glob("*.json"))
        if not input_files:
            print(f"[error] no JSON files found in {raw_src}", file=sys.stderr)
            sys.exit(1)
        print(f"[batch] found {len(input_files)} JSON file(s) in {raw_src}", file=sys.stderr)

    # Determine lean output dir (only relevant when processing a single file with --output-dir)
    lean_out_dir: Optional[Path] = Path(args.output_dir).expanduser().resolve() if args.output_dir else None

    total_written = 0
    for i, input_path in enumerate(input_files, start=1):
        if len(input_files) > 1:
            print(f"\n{'#'*60}", file=sys.stderr)
            print(f"# File {i}/{len(input_files)}: {input_path.name}", file=sys.stderr)
            print(f"{'#'*60}", file=sys.stderr)
        n = process_file(
            input_path,
            work_dir=work_dir,
            lean_out_dir=lean_out_dir,
            client=client,
            model=model,
            overwrite=overwrite,
            lean_prompt=lean_prompt,
        )
        total_written += n

    print(f"\n{'='*60}", file=sys.stderr)
    print(f"ALL DONE — {total_written} Lean file(s) total from {len(input_files)} file(s).", file=sys.stderr)


if __name__ == "__main__":
    main()
