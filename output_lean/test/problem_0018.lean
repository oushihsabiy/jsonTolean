/-
index: 18
source_idx: Exercise 2.1
source: bv_cvxbook_extra_exercises
题目类型:
[
  "求值题"
]
预估难度:
[]
problem:
Let \(v_1,\ldots,v_k \in \mathbf{R}^n\) and define
\(P = \operatorname{conv}\{v_1,\ldots,v_k\}.\)
Let \(f : P \to \mathbf{R}\) be convex.

1. Prove that the maximum of \(f\) on \(P\) is attained at a vertex \(v_i\). Equivalently, show that
\(\sup_{x \in P} f(x) = \max_{1 \le i \le k} f(v_i).\)

2. Let \(C \subseteq \mathbf{R}^n\) be nonempty, closed, bounded, and convex, and let \(f : C \to \mathbf{R}\) be convex. Prove that the maximum of \(f\) on \(C\) is attained at an extreme point of \(C\), where \(x \in C\) is an extreme point if there do not exist distinct \(y,z \in C\) and \(\lambda \in (0,1)\) such that
\(x = \lambda y + (1-\lambda)z.\)

You may use Jensen's inequality: for any \(x_1,\ldots,x_m \in P\) (or \(C\)) and any \(\lambda_1,\ldots,\lambda_m \ge 0\) with \(\sum_{i=1}^m \lambda_i = 1\),
\(f\left(\sum_{i=1}^m \lambda_i x_i\right) \le \sum_{i=1}^m \lambda_i f(x_i).\)

Hint: argue by contradiction by assuming that a maximizer is not a vertex in part 1 or not an extreme point in part 2, and apply Jensen's inequality.
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

def IsExtremePoint {E : Type*} [AddCommGroup E] [Module ℝ E] (C : Set E) (x : E) : Prop :=
  x ∈ C ∧
    ∀ ⦃y z : E⦄ ⦃a : ℝ⦄,
      y ∈ C →
      z ∈ C →
      0 < a →
      a < 1 →
      x = a • y + (1 - a) • z →
      y = x ∧ z = x

theorem convex_max_on_convexHull_attained_at_vertex
    {n k : ℕ} [NeZero k]
    (v : Fin k → (Fin n → ℝ))
    {f : (Fin n → ℝ) → ℝ}
    (hf : ConvexOn ℝ (convexHull (Set.range v)) f) :
    ∃ i : Fin k, ∀ x ∈ convexHull (Set.range v), f x ≤ f (v i) := by
  sorry

theorem convex_sup_on_convexHull_eq_max_vertices
    {n k : ℕ} [NeZero k]
    (v : Fin k → (Fin n → ℝ))
    {f : (Fin n → ℝ) → ℝ}
    (hf : ConvexOn ℝ (convexHull (Set.range v)) f) :
    sSup (f '' convexHull (Set.range v)) =
      ((Finset.univ.image fun i : Fin k => f (v i)).max' (by
        simpa using (Finset.univ_nonempty : (Finset.univ : Finset (Fin k)).Nonempty))) := by
  sorry

theorem convex_max_on_closed_bounded_convex_attained_at_extreme_point
    {n : ℕ}
    {C : Set (Fin n → ℝ)}
    (hCne : C.Nonempty)
    (hCclosed : IsClosed C)
    (hCbounded : Bornology.IsBounded C)
    (hCconv : Convex ℝ C)
    {f : (Fin n → ℝ) → ℝ}
    (hf : ConvexOn ℝ C f) :
    ∃ x ∈ C, IsExtremePoint C x ∧ ∀ y ∈ C, f y ≤ f x := by
  sorry
