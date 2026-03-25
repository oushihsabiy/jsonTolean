/-
index: 10
source_idx: Exercise 1.6-(b)
source: bv_cvxbook_extra_exercises
题目类型: ["求值题"]
预估难度: []
problem:
Let \(C \subseteq \mathbf{R}^n\) be a cone, i.e., \(t x \in C\) for every \(x \in C\) and every \(t \ge 0\). The polar of a set \(C \subseteq \mathbf{R}^n\) is defined by
\(C^{\circ} = \{\, y \in \mathbf{R}^n \mid y^T x \le 1 \text{ for all } x \in C \,\}.\)
Determine \(C^{\circ}\) explicitly under the assumption that \(C\) is a cone.
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

open scoped RealInnerProductSpace

namespace ConvexExtraExercises

abbrev Vec (n : ℕ) := EuclideanSpace ℝ (Fin n)

def IsCone {n : ℕ} (C : Set (Vec n)) : Prop :=
  ∀ ⦃x : Vec n⦄, x ∈ C → ∀ ⦃t : ℝ⦄, 0 ≤ t → t • x ∈ C

def polar {n : ℕ} (C : Set (Vec n)) : Set (Vec n) :=
  { y | ∀ x ∈ C, ⟪y, x⟫_ℝ ≤ (1 : ℝ) }

theorem polar_eq_nonpos_dual_of_cone {n : ℕ} {C : Set (Vec n)} (hC : IsCone C) :
    polar C = { y | ∀ x ∈ C, ⟪y, x⟫_ℝ ≤ (0 : ℝ) } := by
  sorry

theorem mem_polar_iff_of_cone {n : ℕ} {C : Set (Vec n)} (hC : IsCone C) (y : Vec n) :
    y ∈ polar C ↔ ∀ x ∈ C, ⟪y, x⟫_ℝ ≤ (0 : ℝ) := by
  rw [polar_eq_nonpos_dual_of_cone hC]

end ConvexExtraExercises
