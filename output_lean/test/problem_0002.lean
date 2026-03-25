/-
index: 2
source_idx: Exercise 1.2
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(C \subseteq \mathbf{R}^n\). For \(\lambda \ge 0\), define
\(\lambda C := \{\lambda x : x \in C\},\)
and for \(A,B \subseteq \mathbf{R}^n\), define
\(A + B := \{a+b : a \in A,\ b \in B\}.\)
Prove that the following are equivalent:
1. \(C\) is convex.
2. For all scalars \(\alpha,\beta \ge 0\),
\((\alpha+\beta)C = \alpha C + \beta C.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

variable {E : Type*} [AddCommGroup E] [Module ℝ E]

/-- A set is convex iff scaling by nonnegative scalars distributes over Minkowski addition
in the form `(α + β) • C = α • C + β • C` for all `α, β ≥ 0`. -/
theorem convex_iff_add_smul_eq (C : Set E) :
    Convex ℝ C ↔ ∀ ⦃α β : ℝ⦄, 0 ≤ α → 0 ≤ β → (α + β) • C = α • C + β • C := by
  sorry
