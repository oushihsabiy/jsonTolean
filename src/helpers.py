#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Shared helpers for jsonTolean_informal.

Contains configuration loading, JSON I/O, exercise detection, and LLM
streaming utilities. These were originally part of concise_to_lean.py in
jsonTolean-main; they are extracted here because the informal pipeline
skips the concise_to_lean step.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional


DEFAULT_MAX_TOKENS = 4096
DEFAULT_TIMEOUT_SECONDS = 180.0
CHAT_FORCE_STREAM: Optional[bool] = None


# ---------------------------------------------------------------------------
# Config helpers
# ---------------------------------------------------------------------------

def find_config_json() -> Path:
    cwd_path = Path.cwd() / "config.json"
    if cwd_path.exists():
        return cwd_path.resolve()

    here = Path(__file__).resolve().parent
    for parent in [here] + list(here.parents):
        candidate = parent / "config.json"
        if candidate.exists():
            return candidate.resolve()

    raise FileNotFoundError(
        "config.json not found (checked CWD and script parents).")


def load_config() -> Dict[str, Any]:
    config_path = find_config_json()
    data = json.loads(config_path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError(f"{config_path} must contain a JSON object.")
    return data


def require_str(config: Dict[str, Any], key: str) -> str:
    value = config.get(key)
    if not isinstance(value, str) or not value.strip():
        raise KeyError(
            f"Missing/invalid '{key}' in config.json (must be non-empty string)")
    return value.strip()


# ---------------------------------------------------------------------------
# Exercise detection & iteration
# ---------------------------------------------------------------------------

def is_exercise_object(node: Any) -> bool:
    if not isinstance(node, dict):
        return False
    if "problem" not in node:
        return False
    marker_keys = {"proof", "direct_answer",
                   "source_idx", "source", "题目类型", "预估难度"}
    return any(key in node for key in marker_keys)


def iter_exercise_objects(node: Any) -> Iterable[Dict[str, Any]]:
    if is_exercise_object(node):
        yield node
        return

    if isinstance(node, list):
        for item in node:
            yield from iter_exercise_objects(item)
        return

    if isinstance(node, dict):
        for item in node.values():
            yield from iter_exercise_objects(item)


# ---------------------------------------------------------------------------
# JSON I/O
# ---------------------------------------------------------------------------

def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(data, ensure_ascii=False, indent=2)
    path.write_text(text + "\n", encoding="utf-8")


# ---------------------------------------------------------------------------
# LLM chat helpers (stream-aware)
# ---------------------------------------------------------------------------

def _is_stream_required_error(err: Exception) -> bool:
    return "stream must be set to true" in str(err or "").lower()


def _collect_stream_text(stream_obj: Any) -> str:
    parts: List[str] = []
    try:
        for chunk in stream_obj:
            choices = getattr(chunk, "choices", None) or []
            if not choices:
                continue
            delta = getattr(choices[0], "delta", None)
            if delta is None:
                continue
            content = getattr(delta, "content", None)
            if isinstance(content, str):
                parts.append(content)
            elif isinstance(content, list):
                for item in content:
                    if isinstance(item, dict):
                        text = item.get("text") or item.get("content") or ""
                    else:
                        text = getattr(item, "text", "") or getattr(
                            item, "content", "") or ""
                    if isinstance(text, str) and text:
                        parts.append(text)
    finally:
        close_fn = getattr(stream_obj, "close", None)
        if callable(close_fn):
            try:
                close_fn()
            except Exception:
                pass
    return "".join(parts)
