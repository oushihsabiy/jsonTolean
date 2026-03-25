You are given a single JSON object representing a math problem. The problem field contains the original natural-language statement and has NOT been restructured into Definition/Hypothesis/Goal format. Your task is to convert it directly into a complete Lean 4 file.

Requirements:

1. Generate one independent Lean file for this JSON object.
2. Preserve all original metadata as a Lean block comment at the top of the file, including:
   - index
   - source_idx
   - source
   - 题目类型
   - 预估难度
   - problem
   - proof
   - direct_answer
3. Read the `problem` field carefully. It may contain informal mathematical language, LaTeX notation, and natural-language descriptions. You must:
   - Identify the mathematical definitions, hypotheses, and goals yourself.
   - Translate them into strict Lean-style formalization.
4. Use Lean 4 + Mathlib style.
5. The main goal is to formalize the statement, not necessarily to prove it.
6. If a full proof is difficult or impossible, provide an accurate theorem statement and use `by sorry`.
7. Do not invent an answer unless the problem already clearly specifies one.
8. Do not output JSON.
9. Do not output explanations or analysis.
10. Only output the Lean file content.

Formalization guidelines:

- Identify definitions, assumptions, and goals from the informal problem text.
- Convert definitions (e.g. "let ...", "define ...", "where ... is ...") into Lean declarations such as `variable`, `def`, etc.
- Convert hypotheses and assumptions (e.g. "assume ...", "given that ...", "if ...") into assumptions or named variables.
- Convert the goal (e.g. "show ...", "prove ...", "determine ...") into a theorem statement.
- Use standard Mathlib objects and notation whenever possible.
- Avoid pseudocode; produce proper Lean syntax.
- If exact formalization is hard, use the minimal reasonable abstraction while preserving the mathematical meaning.
- LaTeX notation in the problem field (e.g. `\mathbf{R}^n`, `\|x\|_2`, `\operatorname{conv}`) should be interpreted and mapped to the corresponding Mathlib types and operations.

The Lean file should follow this structure:

```lean
/-
index: ...
source_idx: ...
source: ...
题目类型: ...
预估难度: ...
problem:
...
proof:
...
direct_answer:
...
-/

import Mathlib

noncomputable section

open Set

-- Lean formalization here
```

Important:

* Keep the metadata in comments.
* The Lean body must be as strict and valid as possible.
* It is acceptable to use `sorry`, but not acceptable to replace the formalization with informal text.

Now convert the following JSON object into a Lean file. Output ONLY the Lean file content, nothing else.
