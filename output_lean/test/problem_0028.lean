/-
index: 28
source_idx: Exercise 2.7
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(f : \mathbf{R}^m \to \mathbf{R}\) be convex. Let \(A \in \mathbf{R}^{m \times n}\), \(b \in \mathbf{R}^m\), \(c \in \mathbf{R}^n\), and \(d \in \mathbf{R}\). Define \(g : \mathbf{R}^n \to \mathbf{R}\) on
\(\operatorname{dom} g = \{x \in \mathbf{R}^n \mid c^T x + d > 0\}\)\nby
\(g(x) = (c^T x + d)\, f\!\left(\frac{Ax+b}{c^T x + d}\right), \qquad x \in \operatorname{dom} g.\)
Prove that \(g\) is convex on \(\operatorname{dom} g\); equivalently, show that for all \(x,y \in \operatorname{dom} g\) and all \(\theta \in [0,1]\),
\(g(\theta x + (1-\theta)y) \le \theta g(x) + (1-\theta) g(y).\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

abbrev RVec (n : ℕ) := Fin n → ℝ

def perspectiveDom {n : ℕ} (c : RVec n) (d : ℝ) : Set (RVec n) :=
  {x | Matrix.dotProduct c x + d > 0}

def perspectiveFun {m n : ℕ} (f : RVec m → ℝ)
    (A : Matrix (Fin m) (Fin n) ℝ) (b : RVec m) (c : RVec n) (d : ℝ) :
    RVec n → ℝ :=
  fun x =>
    let s : ℝ := Matrix.dotProduct c x + d
    s * f ((1 / s) • (A.mulVec x + b))

theorem perspective_convex_on {m n : ℕ}
    (f : RVec m → ℝ)
    (A : Matrix (Fin m) (Fin n) ℝ) (b : RVec m) (c : RVec n) (d : ℝ)
    (hf : ConvexOn ℝ univ f) :
    ConvexOn ℝ (perspectiveDom c d) (perspectiveFun f A b c d) := by
  sorry

theorem perspective_convex_ineq {m n : ℕ}
    (f : RVec m → ℝ)
    (A : Matrix (Fin m) (Fin n) ℝ) (b : RVec m) (c : RVec n) (d : ℝ)
    (hf : ConvexOn ℝ univ f)
    {x y : RVec n}
    (hx : x ∈ perspectiveDom c d)
    (hy : y ∈ perspectiveDom c d)
    {θ : ℝ} (hθ : θ ∈ Set.Icc (0 : ℝ) 1) :
    perspectiveFun f A b c d (θ • x + (1 - θ) • y) ≤
      θ * perspectiveFun f A b c d x + (1 - θ) * perspectiveFun f A b c d y := by
  sorry
