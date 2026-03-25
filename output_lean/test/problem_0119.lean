/-
index: 119
source_idx: Exercise 3.23
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(f : \mathbf{R}_{++}^n \to \mathbf{R}_{++}\) be a posynomial, i.e., there exist \(m \in \mathbf{N}\), coefficients \(c_k > 0\), and exponent vectors \(a_k = (a_{k1}, \ldots, a_{kn}) \in \mathbf{R}^n\) for \(k=1, \ldots, m\) such that
\(f(x) = \sum_{k=1}^m c_k x_1^{a_{k1}} \cdots x_n^{a_{kn}}, \qquad x = (x_1, \ldots, x_n) \in \mathbf{R}_{++}^n.\)
Given \(x, y \in \mathbf{R}_{++}^n\) and \(\theta \in [0,1]\), define \(z \in \mathbf{R}_{++}^n\) by
\(z_i = x_i^{\theta} y_i^{1-\theta}, \qquad i=1, \ldots, n.\)
Prove that
\(f(z) \le f(x)^{\theta} f(y)^{1-\theta}.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set
open scoped BigOperators

def monomialEval {n : ℕ} (c : ℝ) (a : Fin n → ℝ) (x : Fin n → ℝ) : ℝ :=
  c * ∏ i, Real.rpow (x i) (a i)

def posynomialEval {n m : ℕ} (c : Fin m → ℝ) (a : Fin m → Fin n → ℝ) (x : Fin n → ℝ) : ℝ :=
  ∑ k, monomialEval (c k) (a k) x

theorem posynomial_geometric_convexity
    {n m : ℕ}
    (c : Fin m → ℝ)
    (a : Fin m → Fin n → ℝ)
    (hc : ∀ k, 0 < c k)
    {x y : Fin n → ℝ}
    (hx : ∀ i, 0 < x i)
    (hy : ∀ i, 0 < y i)
    {θ : ℝ}
    (hθ0 : 0 ≤ θ)
    (hθ1 : θ ≤ 1) :
    let z : Fin n → ℝ := fun i => Real.rpow (x i) θ * Real.rpow (y i) (1 - θ)
    posynomialEval c a z
      ≤ Real.rpow (posynomialEval c a x) θ * Real.rpow (posynomialEval c a y) (1 - θ) := by
  sorry
