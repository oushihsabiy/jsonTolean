/-
index: 14
source_idx: Exercise 1.7-(a)
source: bv_cvxbook_extra_exercises
题目类型: [
  "其他"
]
预估难度: []
problem:
Let \(K = \{0\} \subseteq \mathbf{R}^2\), where \(0\) is the zero vector. The dual cone of \(K\) is defined by
\(K^* = \{ y \in \mathbf{R}^2 : y \cdot x \ge 0 \text{ for all } x \in K \}.\)
Determine \(K^*\) explicitly.
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

abbrev R2 := EuclideanSpace ℝ (Fin 2)

def dualCone (K : Set R2) : Set R2 :=
  {y | ∀ x ∈ K, 0 ≤ ⟪y, x⟫_ℝ}

theorem exercise_1_7_a :
    dualCone ({(0 : R2)} : Set R2) = Set.univ := by
  ext y
  constructor
  · intro hy
    trivial
  · intro hy
    intro x hx
    rw [Set.mem_singleton_iff] at hx
    subst hx
    simp
