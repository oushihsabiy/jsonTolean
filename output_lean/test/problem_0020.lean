/-
index: 20
source_idx: Exercise 2.3-(a)
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Consider
\[
f(x,t) = -\log\left(t^2 - x^T x\right),
\qquad
\operatorname{dom} f = \left\{(x,t) \in \mathbf{R}^n \times \mathbf{R} \mid t > \|x\|_2\right\}.
\]
Using the fact that the quadratic-over-linear function
\((u,t) \mapsto \frac{u^T u}{t}\)
is convex on
\(\left\{(u,t) \in \mathbf{R}^n \times \mathbf{R} \mid t > 0\right\},\)
explain why the function
\((u,t) \mapsto t - \frac{1}{t} u^T u\)
is concave on its natural domain
\(\left\{(u,t) \in \mathbf{R}^n \times \mathbf{R} \mid t > 0\right\}.\)
Relate this conclusion to the domain condition
\(t > \|x\|_2,\)
which implies
\(t > 0.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

section

variable {n : Type*} [Fintype n] [DecidableEq n]

def f (x : n → ℝ) (t : ℝ) : ℝ :=
  -Real.log (t ^ 2 - ‖x‖ ^ 2)

def quadOverLin (p : (n → ℝ) × ℝ) : ℝ :=
  ‖p.1‖ ^ 2 / p.2

def concaveCandidate (p : (n → ℝ) × ℝ) : ℝ :=
  p.2 - quadOverLin p

def naturalDomain : Set ((n → ℝ) × ℝ) :=
  { p | 0 < p.2 }

def fDomain : Set ((n → ℝ) × ℝ) :=
  { p | p.2 > ‖p.1‖ }

theorem concave_on_naturalDomain :
    ConcaveOn ℝ naturalDomain concaveCandidate := by
  sorry

theorem domain_condition_implies_pos {x : n → ℝ} {t : ℝ} (h : t > ‖x‖) : 0 < t := by
  have hx : 0 ≤ ‖x‖ := norm_nonneg x
  linarith

theorem domain_condition_implies_log_argument_pos {x : n → ℝ} {t : ℝ}
    (h : t > ‖x‖) : 0 < t ^ 2 - ‖x‖ ^ 2 := by
  have ht : 0 < t := domain_condition_implies_pos h
  nlinarith [sq_nonneg t, sq_nonneg ‖x‖]

theorem fDomain_subset_naturalDomain :
    fDomain ⊆ naturalDomain := by
  intro p hp
  exact domain_condition_implies_pos hp

end
