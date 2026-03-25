/-
index: 104
source_idx: Exercise 3.14
source: bv_cvxbook_extra_exercises
题目类型: [
  "证明题"
]
预估难度: []
problem:
Let \(S^n\) be the space of real symmetric \(n \times n\) matrices, \(S_+^n\) the cone of positive semidefinite matrices, and \(S_{++}^n\) the cone of positive definite matrices. For \(A,B \in S_{++}^n\), define
\(G(A,B)=A^{1/2}\left(A^{-1/2}BA^{-1/2}\right)^{1/2}A^{1/2}.\)
Consider the semidefinite program
\[
\begin{aligned}
\text{maximize} \quad & \operatorname{tr} X \\
\text{subject to} \quad & \begin{bmatrix} A & X \\ X & B \end{bmatrix} \succeq 0,
\end{aligned}
\]
with variable \(X \in S^n\), where \(A,B \in S_{++}^n\) are fixed.

1. Prove that \(X=G(A,B)\) is an optimal solution of the above semidefinite program.

2. Using item 1, prove that the map
\((A,B) \mapsto \operatorname{tr} G(A,B)\)
is concave on \(S_{++}^n \times S_{++}^n\). Explicitly, show that for all \(A_1,A_2,B_1,B_2 \in S_{++}^n\) and all \(\theta \in [0,1]\),
\[
\operatorname{tr} G\bigl(\theta A_1 + (1-\theta)A_2,\ \theta B_1 + (1-\theta)B_2\bigr)
\ge
\theta \, \operatorname{tr} G(A_1,B_1) + (1-\theta) \, \operatorname{tr} G(A_2,B_2).
\]

You may use the fact that if \(U,V \in S_+^n\) and \(U \preceq V\), then
\(U^{1/2} \preceq V^{1/2}.\)
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set Matrix

abbrev Mat (n : ℕ) := Matrix (Fin n) (Fin n) ℝ

axiom PSD {n : ℕ} : Mat n → Prop
axiom PD {n : ℕ} : Mat n → Prop

axiom msqrt {n : ℕ} : Mat n → Mat n

def G {n : ℕ} (A B : Mat n) : Mat n :=
  msqrt A ⬝ msqrt ((msqrt A)⁻¹ ⬝ B ⬝ (msqrt A)⁻¹) ⬝ msqrt A

def blockMat {n : ℕ} (A X B : Mat n) :
    Matrix (Sum (Fin n) (Fin n)) (Sum (Fin n) (Fin n)) ℝ :=
  Matrix.fromBlocks A X X B

def Feasible {n : ℕ} (A B X : Mat n) : Prop :=
  X.IsSymm ∧ PSD (blockMat A X B)

def IsOptimalSolution {n : ℕ} (A B X : Mat n) : Prop :=
  Feasible A B X ∧ ∀ Y : Mat n, Feasible A B Y → Matrix.trace Y ≤ Matrix.trace X

def trG {n : ℕ} (A B : Mat n) : ℝ :=
  Matrix.trace (G A B)

theorem G_optimal_solution {n : ℕ} {A B : Mat n}
    (hA : PD A) (hB : PD B) :
    IsOptimalSolution A B (G A B) := by
  sorry

theorem trG_concave {n : ℕ}
    {A₁ A₂ B₁ B₂ : Mat n}
    (hA₁ : PD A₁) (hA₂ : PD A₂) (hB₁ : PD B₁) (hB₂ : PD B₂)
    {θ : ℝ} (hθ₀ : 0 ≤ θ) (hθ₁ : θ ≤ 1) :
    trG (θ • A₁ + (1 - θ) • A₂) (θ • B₁ + (1 - θ) • B₂) ≥
      θ * trG A₁ B₁ + (1 - θ) * trG A₂ B₂ := by
  sorry
