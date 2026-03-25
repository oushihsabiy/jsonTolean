/-
index: 194
source_idx: Exercise 4.30-(b)
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(A \in \mathbf{R}^{m \times n}\), \(c \in \mathbf{R}^n\), \(b \in \mathbf{R}^m\), and \(\mu > 0\). For \(i=1,\dots,m\), let \(a_i^T\) denote the \(i\)-th row of \(A\). Define the convex optimization problem
\[
\begin{aligned}
\min_{x \in \mathbf{R}^n} \quad & c^T x + \frac{1}{\mu} \sum_{i=1}^m \log\bigl(1 + e^{\mu(a_i^T x - b_i)}\bigr).
\end{aligned}
\]
Let \(q^\star\) be its optimal value.

Also consider the linear-program primal-dual pair
\[
\begin{aligned}
\min_{x \in \mathbf{R}^n} \quad & c^T x \\\\\\
\text{s.t.} \quad & Ax \le b,
\end{aligned}
\qquad
\begin{aligned}
\max_{z \in \mathbf{R}^m} \quad & -b^T z \\\\\\
\text{s.t.} \quad & A^T z + c = 0, \\\\\\
& z \ge 0.
\end{aligned}
\]
Let \(p^\star\) denote their common finite optimal value. Assume there exists a dual optimal solution \(z^\star \in \mathbf{R}^m\) such that
\(0 \le z_i^\star \le 1, \qquad i=1,\dots,m.\)

Show that
\(p^\star \le q^\star \le p^\star + \frac{m \log 2}{\mu}.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set BigOperators Matrix

namespace BVExtraExercises

variable {m n : ℕ}

/-- The smoothed objective
`cᵀx + (1/μ) ∑ᵢ log(1 + exp(μ((Ax)ᵢ - bᵢ)))`. -/
def softObjective
    (A : Matrix (Fin m) (Fin n) ℝ)
    (c : Fin n → ℝ)
    (b : Fin m → ℝ)
    (μ : ℝ)
    (x : Fin n → ℝ) : ℝ :=
  dotProduct c x +
    (1 / μ) * ∑ i : Fin m, Real.log (1 + Real.exp (μ * ((A.mulVec x) i - b i)))

/-- The primal LP objective `cᵀx`. -/
def primalObjective
    (c : Fin n → ℝ)
    (x : Fin n → ℝ) : ℝ :=
  dotProduct c x

/-- The dual LP objective `-bᵀz`. -/
def dualObjective
    (b : Fin m → ℝ)
    (z : Fin m → ℝ) : ℝ :=
  - dotProduct b z

/-- Primal feasibility: `Ax ≤ b` componentwise. -/
def primalFeasible
    (A : Matrix (Fin m) (Fin n) ℝ)
    (b : Fin m → ℝ)
    (x : Fin n → ℝ) : Prop :=
  ∀ i : Fin m, (A.mulVec x) i ≤ b i

/-- Dual feasibility: `Aᵀ z + c = 0` and `z ≥ 0` componentwise. -/
def dualFeasible
    (A : Matrix (Fin m) (Fin n) ℝ)
    (c : Fin n → ℝ)
    (z : Fin m → ℝ) : Prop :=
  (∀ j : Fin n, (A.transpose.mulVec z) j + c j = 0) ∧
  (∀ i : Fin m, 0 ≤ z i)

/-- The set of values attained by the smoothed problem. -/
def softValueSet
    (A : Matrix (Fin m) (Fin n) ℝ)
    (c : Fin n → ℝ)
    (b : Fin m → ℝ)
    (μ : ℝ) : Set ℝ :=
  {q | ∃ x : Fin n → ℝ, softObjective A c b μ x = q}

/-- The set of primal objective values attained by feasible points. -/
def primalValueSet
    (A : Matrix (Fin m) (Fin n) ℝ)
    (c : Fin n → ℝ)
    (b : Fin m → ℝ) : Set ℝ :=
  {p | ∃ x : Fin n → ℝ, primalFeasible A b x ∧ primalObjective c x = p}

/-- The set of dual objective values attained by feasible points. -/
def dualValueSet
    (A : Matrix (Fin m) (Fin n) ℝ)
    (c : Fin n → ℝ)
    (b : Fin m → ℝ) : Set ℝ :=
  {p | ∃ z : Fin m → ℝ, dualFeasible A c z ∧ dualObjective b z = p}

theorem softened_lp_value_bounds
    (A : Matrix (Fin m) (Fin n) ℝ)
    (c : Fin n → ℝ)
    (b : Fin m → ℝ)
    (μ pstar qstar : ℝ)
    (hμ : 0 < μ)
    (hq : IsLeast (softValueSet A c b μ) qstar)
    (hp_primal : IsLeast (primalValueSet A c b) pstar)
    (hp_dual : IsGreatest (dualValueSet A c b) pstar)
    (zstar : Fin m → ℝ)
    (hzstar_opt : dualFeasible A c zstar ∧ dualObjective b zstar = pstar)
    (hzstar_le_one : ∀ i : Fin m, zstar i ≤ 1) :
    pstar ≤ qstar ∧ qstar ≤ pstar + ((m : ℝ) * Real.log 2) / μ := by
  sorry

end BVExtraExercises
