/-
index: 7
source_idx: Exercise 1.5-(c)
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(C, D \subseteq \mathbf{R}^n\) be closed convex cones. For any cone \(K \subseteq \mathbf{R}^n\), define its dual cone by
\(K^* := \{ y \in \mathbf{R}^n \mid y^T x \ge 0 \text{ for all } x \in K \}.\)
Define also the Minkowski sum
\(C^* + D^* := \{ u+v \mid u \in C^*,\ v \in D^* \}.\)
Prove that
\((C \cap D)^* = C^* + D^*.\)
You may proceed as follows:

1. Show that
\((C \cap D)^* \subseteq C^* + D^* \iff C \cap D \supseteq (C^* + D^*)^*.\)

2. Using the fact that for every closed convex cone \(K \subseteq \mathbf{R}^n\),
\(K^{**} = K,\)\nshow that
\(C \cap D \supseteq (C^* + D^*)^*.\)

3. Deduce that
\((C \cap D)^* \subseteq C^* + D^*.\)
Then prove the reverse inclusion
\(C^* + D^* \subseteq (C \cap D)^*,\)
and conclude that
\((C \cap D)^* = C^* + D^*.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

abbrev E (n : ℕ) := EuclideanSpace ℝ (Fin n)

def IsCone {n : ℕ} (K : Set (E n)) : Prop :=
  ∀ ⦃x : E n⦄, x ∈ K → ∀ ⦃a : ℝ⦄, 0 ≤ a → a • x ∈ K

def dualCone {n : ℕ} (K : Set (E n)) : Set (E n) :=
  { y | ∀ x ∈ K, 0 ≤ inner y x }

postfix:max "ᵈ" => dualCone

namespace DualConeIntersection

variable {n : ℕ}
variable (C D K : Set (E n))

theorem dual_subset_sum_dual_iff
    (C D : Set (E n)) :
    (C ∩ D)ᵈ ⊆ Cᵈ + Dᵈ ↔ (Cᵈ + Dᵈ)ᵈ ⊆ C ∩ D := by
  sorry

theorem bidual_eq_self_of_closed_convex_cone
    {K : Set (E n)}
    (hK_closed : IsClosed K)
    (hK_convex : Convex ℝ K)
    (hK_cone : IsCone K) :
    (Kᵈ)ᵈ = K := by
  sorry

theorem dual_sum_dual_dual_subset_inter
    {C D : Set (E n)}
    (hC_closed : IsClosed C)
    (hC_convex : Convex ℝ C)
    (hC_cone : IsCone C)
    (hD_closed : IsClosed D)
    (hD_convex : Convex ℝ D)
    (hD_cone : IsCone D) :
    (Cᵈ + Dᵈ)ᵈ ⊆ C ∩ D := by
  sorry

theorem dual_inter_subset_sum_dual
    {C D : Set (E n)}
    (hC_closed : IsClosed C)
    (hC_convex : Convex ℝ C)
    (hC_cone : IsCone C)
    (hD_closed : IsClosed D)
    (hD_convex : Convex ℝ D)
    (hD_cone : IsCone D) :
    (C ∩ D)ᵈ ⊆ Cᵈ + Dᵈ := by
  sorry

theorem sum_dual_subset_dual_inter
    {C D : Set (E n)} :
    Cᵈ + Dᵈ ⊆ (C ∩ D)ᵈ := by
  intro y hy
  rcases hy with ⟨u, hu, v, hv, rfl⟩
  intro x hx
  rcases hx with ⟨hxC, hxD⟩
  have hu' : 0 ≤ inner u x := hu x hxC
  have hv' : 0 ≤ inner v x := hv x hxD
  simpa [inner_add_left] using add_nonneg hu' hv'

theorem dual_inter_eq_sum_dual
    {C D : Set (E n)}
    (hC_closed : IsClosed C)
    (hC_convex : Convex ℝ C)
    (hC_cone : IsCone C)
    (hD_closed : IsClosed D)
    (hD_convex : Convex ℝ D)
    (hD_cone : IsCone D) :
    (C ∩ D)ᵈ = Cᵈ + Dᵈ := by
  apply le_antisymm
  · exact dual_inter_subset_sum_dual hC_closed hC_convex hC_cone hD_closed hD_convex hD_cone
  · exact sum_dual_subset_dual_inter

end DualConeIntersection
