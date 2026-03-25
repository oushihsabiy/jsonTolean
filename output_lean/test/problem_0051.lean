/-
index: 51
source_idx: Exercise 2.24
source: bv_cvxbook_extra_exercises
题目类型: ["证明题"]
预估难度: []
problem:
Let \(g,h:\mathbf{R}^n \to \mathbf{R}\) be convex functions, bounded below, with \(\operatorname{dom} g=\operatorname{dom} h=\mathbf{R}^n\). Define \(f:\mathbf{R}^n \to \mathbf{R}\) by
\(f(x)=\inf \left\{ \theta g(y)+(1-\theta)h(z)\ \middle|\ x=\theta y+(1-\theta)z,\ \theta \in [0,1],\ y,z \in \mathbf{R}^n \right\}.\)
Equivalently, the infimum is over all \((\theta,y,z) \in [0,1]\times \mathbf{R}^n \times \mathbf{R}^n\) such that \(x=\theta y+(1-\theta)z\).

1. Prove that \(f\) is convex on \(\mathbf{R}^n\).

2. Express the epigraph
\(\operatorname{epi} f=\{(x,t)\in \mathbf{R}^n \times \mathbf{R}\mid f(x)\le t\}\)
in terms of
\(\operatorname{epi} g=\{(x,t)\in \mathbf{R}^n \times \mathbf{R}\mid g(x)\le t\},\qquad \operatorname{epi} h=\{(x,t)\in \mathbf{R}^n \times \mathbf{R}\mid h(x)\le t\}.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

variable {E : Type*} [AddCommGroup E] [Module ℝ E]

/-- The epigraph of a real-valued function. -/
def epigraph (u : E → ℝ) : Set (E × ℝ) :=
  {p | u p.1 ≤ p.2}

/-- The function defined in the problem: the infimum over all convex interpolations
between points for `g` and `h`. -/
def blendInf (g h : E → ℝ) (x : E) : ℝ :=
  sInf
    {r : ℝ |
      ∃ θ : ℝ, θ ∈ Icc (0 : ℝ) 1 ∧ ∃ y z : E,
        x = θ • y + (1 - θ) • z ∧
        r = θ * g y + (1 - θ) * h z}

theorem blendInf_convex
    (g h : E → ℝ)
    (hg : ConvexOn ℝ univ g)
    (hh : ConvexOn ℝ univ h)
    (g_bdd : BddBelow (range g))
    (h_bdd : BddBelow (range h)) :
    ConvexOn ℝ univ (blendInf g h) := by
  sorry

/-- The epigraph of `blendInf g h` is the convex hull of the union of the epigraphs
of `g` and `h`. -/
theorem epigraph_blendInf
    (g h : E → ℝ)
    (hg : ConvexOn ℝ univ g)
    (hh : ConvexOn ℝ univ h)
    (g_bdd : BddBelow (range g))
    (h_bdd : BddBelow (range h)) :
    epigraph (blendInf g h) = convexHull ℝ (epigraph g ∪ epigraph h) := by
  sorry
