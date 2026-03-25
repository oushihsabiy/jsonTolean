/-
index: 13
source_idx: Exercise 1.6-(e)
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(C \subseteq \mathbf{R}^n\) be closed and convex, with \(0 \in C\). Define the polar set
\(C^{\circ} = \{ y \in \mathbf{R}^n \mid y^T x \le 1 \text{ for all } x \in C \}.\)
Show that the bipolar of \(C\) equals \(C\), i.e.,
\((C^{\circ})^{\circ} = C.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set
open scoped RealInnerProductSpace

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The polar of a set `C ⊆ ℝ^n`, defined using the standard inner product. -/
def polar (C : Set (EuclideanSpace ℝ ι)) : Set (EuclideanSpace ℝ ι) :=
  { y | ∀ x ∈ C, ⟪y, x⟫_ℝ ≤ (1 : ℝ) }

theorem mem_polar_iff {C : Set (EuclideanSpace ℝ ι)} {y : EuclideanSpace ℝ ι} :
    y ∈ polar C ↔ ∀ x ∈ C, ⟪y, x⟫_ℝ ≤ (1 : ℝ) :=
  Iff.rfl

/-- Bipolar theorem for a closed convex set containing the origin in `ℝ^n`. -/
theorem polar_polar_eq_self_of_isClosed_convex_zero_mem
    (C : Set (EuclideanSpace ℝ ι))
    (h_closed : IsClosed C)
    (h_convex : Convex ℝ C)
    (h0 : (0 : EuclideanSpace ℝ ι) ∈ C) :
    polar (polar C) = C := by
  sorry
