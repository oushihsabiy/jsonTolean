/-
index: 168
source_idx: Exercise 4.18-(c)
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Consider the convex optimization problem
\[
\begin{aligned}
\text{minimize}\quad & f_0(x) \\
\text{subject to}\quad & f_i(x) \le 0, \quad i=1,\ldots,m,
\end{aligned}
\tag{16}
\]
with dual problem
\[
\begin{aligned}
\text{maximize}\quad & g(\lambda) \\
\text{subject to}\quad & \lambda \succeq 0.
\end{aligned}
\tag{17}
\]
Assume that Slater's condition holds, so strong duality holds and the dual optimum is attained, and assume for simplicity that the dual optimal solution is unique, denoted by \(\lambda^\star\).

For a fixed \(t>0\), consider the unconstrained problem
\[
\text{minimize} \quad f_0(x) + t \max_{i=1,\ldots,m} f_i(x)^+,
\tag{18}
\]
where \(f_i(x)^+ = \max\{f_i(x),0\}\).

Using the result in part (b), prove that if \(t > \mathbf{1}^T \lambda^\star\), then any minimizer of \((18)\) is also an optimal solution of \((16)\).
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set
open scoped BigOperators

section PenaltyMethod

variable {α ι : Type*} [Fintype ι] [Nonempty ι]

/-- Feasibility for the constrained problem `(16)`. -/
def Feasible (f : ι → α → ℝ) (x : α) : Prop :=
  ∀ i, f i x ≤ 0

/-- The maximum positive constraint violation
`max_i (f_i(x))^+ = max_i max(f_i(x), 0)`. -/
def maxViolation (f : ι → α → ℝ) (x : α) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty (fun i => max (f i x) 0)

/-- The penalized unconstrained objective in `(18)`. -/
def penalizedObj (f₀ : α → ℝ) (f : ι → α → ℝ) (t : ℝ) (x : α) : ℝ :=
  f₀ x + t * maxViolation f x

/-- A point is an optimal solution of the original constrained problem `(16)`. -/
def IsPrimalOptimal (f₀ : α → ℝ) (f : ι → α → ℝ) (x : α) : Prop :=
  Feasible f x ∧ ∀ y, Feasible f y → f₀ x ≤ f₀ y

/-- A point is a global minimizer of the penalized problem `(18)`. -/
def IsPenalizedMinimizer (f₀ : α → ℝ) (f : ι → α → ℝ) (t : ℝ) (x : α) : Prop :=
  ∀ y, penalizedObj f₀ f t x ≤ penalizedObj f₀ f t y

/--
Formalization of Exercise 4.18-(c):

Assume:
- `x⋆` is an optimal solution of the original problem `(16)`,
- `λ⋆` is the unique dual optimal point,
- part (b) has already established that whenever `t > ∑ i, λ⋆ i`,
  every minimizer of the penalized problem is feasible.

Then any minimizer of the penalized problem `(18)` is also optimal for `(16)`.
-/
theorem penalized_minimizer_is_primal_optimal
    (f₀ : α → ℝ) (f : ι → α → ℝ)
    (λ⋆ : ι → ℝ) (t : ℝ)
    (x x⋆ : α)
    (hx⋆_opt : IsPrimalOptimal f₀ f x⋆)
    (ht : t > ∑ i, λ⋆ i)
    (hpartb :
      t > ∑ i, λ⋆ i →
        ∀ z, IsPenalizedMinimizer f₀ f t z → Feasible f z)
    (hx_min : IsPenalizedMinimizer f₀ f t x) :
    IsPrimalOptimal f₀ f x := by
  sorry

end PenaltyMethod
