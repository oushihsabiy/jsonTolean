/-
index: 69
source_idx: Exercise 2.30
source: bv_cvxbook_extra_exercises
题目类型: [
  "证明题"
]
预估难度: []
problem:
Let \(f,g : \mathbf{R}^n \to \mathbf{R}\) be defined by
\(f(x)=\|x\|_1=\sum_{i=1}^n |x_i|, \qquad g(x)=\frac{1}{2}\|x\|_2^2=\frac{1}{2}\sum_{i=1}^n x_i^2.\)
For each \(x \in \mathbf{R}^n\), define the infimal convolution
\[
(f \square g)(x)=\inf_{y \in \mathbf{R}^n} \left( f(y)+g(x-y) \right)
=\inf_{y \in \mathbf{R}^n} \left( \|y\|_1+\frac{1}{2}\|x-y\|_2^2 \right).
\]
Define
\(h(x):=(f \square g)(x).\)
Prove the following:

1. The function \(h\) is separable across coordinates, i.e.
\(h(x)=\sum_{i=1}^n \phi(x_i)\)
for some scalar function \(\phi : \mathbf{R} \to \mathbf{R}\).

2. The scalar function \(\phi\) is given by
\[
\phi(u)=\begin{cases}
\dfrac{u^2}{2}, & |u| \le 1,\\
|u|-\dfrac{1}{2}, & |u|>1.
\end{cases}
\]

3. Conclude that the infimal convolution of \(\|\cdot\|_1\) and \(\frac{1}{2}\|\cdot\|_2^2\) is the Huber penalty.
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

namespace InfConvolutionHuber

variable {n : ℕ}

/-- The `ℓ₁` norm on `ℝ^n`, modeled as `Fin n → ℝ`. -/
def f (x : Fin n → ℝ) : ℝ :=
  ∑ i, |x i|

/-- The quadratic function `(1/2) * ‖x‖₂² = (1/2) * ∑ x_i²` on `ℝ^n`. -/
def g (x : Fin n → ℝ) : ℝ :=
  (1 / 2 : ℝ) * ∑ i, (x i)^2

/-- Infimal convolution of two functions `ℝ^n → ℝ`, expressed using `sInf`. -/
def infConvolution (f g : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) : ℝ :=
  sInf (Set.range (fun y : Fin n → ℝ => f y + g (x - y)))

/-- The function `h = f □ g`. -/
def h (x : Fin n → ℝ) : ℝ :=
  infConvolution f g x

/-- The scalar Huber penalty corresponding to the infimal convolution of `|·|` and
`(1/2)(·)^2`. -/
def phi (u : ℝ) : ℝ :=
  if |u| ≤ 1 then u^2 / 2 else |u| - 1 / 2

/-- The coordinatewise Huber penalty on `ℝ^n`. -/
def huberPenalty (x : Fin n → ℝ) : ℝ :=
  ∑ i, phi (x i)

theorem phi_of_abs_le_one {u : ℝ} (hu : |u| ≤ 1) :
    phi u = u^2 / 2 := by
  simp [phi, hu]

theorem phi_of_one_lt_abs {u : ℝ} (hu : 1 < |u|) :
    phi u = |u| - 1 / 2 := by
  have hnu : ¬ |u| ≤ 1 := not_le.mpr hu
  simp [phi, hnu]

/-- Part 1 and Part 2 together: the infimal convolution is separable across coordinates,
with scalar component `phi`. -/
theorem h_eq_sum_phi (x : Fin n → ℝ) :
    h x = ∑ i, phi (x i) := by
  sorry

/-- Existence of a scalar function giving the separable representation. -/
theorem h_separable :
    ∃ ψ : ℝ → ℝ, ∀ x : Fin n → ℝ, h x = ∑ i, ψ (x i) := by
  refine ⟨phi, ?_⟩
  intro x
  exact h_eq_sum_phi x

/-- Part 3: the infimal convolution is exactly the Huber penalty. -/
theorem h_is_huber_penalty :
    h = huberPenalty := by
  funext x
  exact h_eq_sum_phi x

end InfConvolutionHuber
