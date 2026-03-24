#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""jsonTolean pipeline entry point.

Usage:
    python main.py --mode book --input input_json/test.json

Pipeline:
    1. Preprocess: problem_finally → problem; drop extra fields
    2. concise_to_lean: rewrite problem into Definition/Hypothesis/Goal format
    3. jsonTolean: convert each exercise into an individual Lean 4 file
"""

from __future__ import annotations

import argparse
import json
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from openai import OpenAI

# Make src/ importable
_ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(_ROOT / "src"))

from stdjson.concise_to_lean import (  # noqa: E402
    DEFAULT_MAX_TOKENS,
    DEFAULT_TIMEOUT_SECONDS,
    iter_exercise_objects,
    lean_rewrite_problem,
    load_config,
    load_prompt,
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
# Step 1 — concise_to_lean: rewrite problem field
# ---------------------------------------------------------------------------

def run_concise_to_lean(
    data: Any,
    *,
    client: OpenAI,
    model: str,
    base_prompt: str,
    max_tokens: int,
    max_attempts: int,
    think_workers: int,
) -> Any:
    """Rewrite every exercise's problem field into structured format."""
    exercises = list(iter_exercise_objects(data))
    if not exercises:
        print("[warn] no exercise objects found; skipping concise_to_lean.", file=sys.stderr)
        return data

    total = len(exercises)
    failed: List[str] = []

    def _rewrite(idx_ex: Tuple[int, Dict[str, Any]]) -> None:
        idx, exercise = idx_ex
        label = exercise.get("source_idx") or exercise.get("index") or str(idx)
        print(f"  [{idx}/{total}] concise_to_lean: '{label}'", file=sys.stderr)
        try:
            new_problem = lean_rewrite_problem(
                client,
                model=model,
                base_prompt=base_prompt,
                exercise=exercise,
                max_tokens=max_tokens,
                max_attempts=max_attempts,
            )
            exercise["problem"] = new_problem
        except Exception as err:
            failed.append(str(label))
            print(f"  [warn] concise_to_lean failed for '{label}': {err}", file=sys.stderr)

    items = list(enumerate(exercises, start=1))
    if think_workers <= 1:
        for item in items:
            _rewrite(item)
    else:
        with ThreadPoolExecutor(max_workers=think_workers) as pool:
            futures = {pool.submit(_rewrite, item): item for item in items}
            for f in as_completed(futures):
                try:
                    f.result()
                except Exception as err:
                    print(f"  [error] {err}", file=sys.stderr)

    print(f"[concise_to_lean] {total - len(failed)}/{total} succeeded.", file=sys.stderr)
    if failed:
        print(f"  [warn] kept original problem: {', '.join(failed)}", file=sys.stderr)

    return data


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="jsonTolean pipeline — preprocess → concise_to_lean → Lean 4 files.",
    )
    parser.add_argument(
        "--mode", required=True, choices=["book"],
        help="Pipeline mode (currently only 'book').",
    )
    parser.add_argument(
        "--input", required=True, dest="input_json",
        help="Path to the input JSON file.",
    )
    parser.add_argument(
        "--output-dir", default=None, dest="output_dir",
        help="Directory for Lean output files (default: output_lean/<stem>/).",
    )
    parser.add_argument(
        "--skip-concise", action="store_true",
        help="Skip concise_to_lean step (input already in structured format).",
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


def main() -> None:
    args = parse_args()
    settings_path = Path(args.settings).resolve() if args.settings else None
    settings = load_settings(settings_path)
    config = load_config()

    input_path = Path(args.input_json).expanduser().resolve()
    if not input_path.exists():
        print(f"[error] input file not found: {input_path}", file=sys.stderr)
        sys.exit(1)

    # Determine output directories
    work_dir = _ROOT / settings.get("WORK_DIR", "work")
    work_dir.mkdir(parents=True, exist_ok=True)

    if args.output_dir:
        lean_out_dir = Path(args.output_dir).expanduser().resolve()
    else:
        lean_out_dir = _ROOT / "output_lean" / input_path.stem

    think_workers = max(1, int(settings.get("THINK_WORKERS", 4)))
    max_tokens = int(settings.get("OCR_MAX_TOKENS") or DEFAULT_MAX_TOKENS)
    overwrite = args.overwrite or bool(settings.get("OVERWRITE_JSON", False))

    # Build OpenAI client
    api_key = require_str(config, "api_key")
    base_url = require_str(config, "base_url")
    model = require_str(config, "model")
    client = OpenAI(api_key=api_key, base_url=base_url, timeout=DEFAULT_TIMEOUT_SECONDS)

    # ── Step 0: Load & preprocess ──────────────────────────────────────────
    print(f"[step 0] loading & preprocessing {input_path.name}", file=sys.stderr)
    data = read_json(input_path)
    data = preprocess(data)

    # Save preprocessed JSON for traceability
    preprocessed_path = work_dir / f"{input_path.stem}_preprocessed.json"
    write_json(preprocessed_path, data)
    print(f"  → preprocessed JSON saved to {preprocessed_path}", file=sys.stderr)

    # ── Step 1: concise_to_lean ────────────────────────────────────────────
    if args.skip_concise:
        print("[step 1] skipped (--skip-concise).", file=sys.stderr)
    else:
        print(f"[step 1] concise_to_lean: rewriting problem fields", file=sys.stderr)
        concise_prompt = load_prompt(None)
        data = run_concise_to_lean(
            data,
            client=client,
            model=model,
            base_prompt=concise_prompt,
            max_tokens=max_tokens,
            max_attempts=8,
            think_workers=think_workers,
        )

    # Save post-concise JSON
    concise_path = work_dir / f"{input_path.stem}_concise.json"
    write_json(concise_path, data)
    print(f"  → concise JSON saved to {concise_path}", file=sys.stderr)

    # ── Step 2: jsonTolean ─────────────────────────────────────────────────
    print(f"[step 2] jsonTolean: generating Lean 4 files → {lean_out_dir}", file=sys.stderr)
    lean_prompt = load_lean_prompt()
    written = convert_json_to_lean(
        concise_path,
        lean_out_dir,
        client=client,
        model=model,
        base_prompt=lean_prompt,
        max_tokens=8192,
        max_attempts=5,
        overwrite=overwrite,
    )

    print(f"\n{'='*60}", file=sys.stderr)
    print(f"ALL DONE — {len(written)} Lean file(s) in {lean_out_dir}", file=sys.stderr)


if __name__ == "__main__":
    main()
