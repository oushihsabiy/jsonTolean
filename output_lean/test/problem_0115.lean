/-
index: 115
source_idx: Exercise 3.21-(a)
source: bv_cvxbook_extra_exercises
题目类型: ["其他"]
预估难度: []
problem:
Let \(y \in \mathbf{R}\) and \(z = (z_1,\dots,z_n) \in \mathbf{R}^n\).

Rewrite each of the following geometric-mean constraints as equivalent second-order cone representable constraints.

1. For \(n=2\), give an equivalent second-order cone formulation in the variables \(y,z_1,z_2\) of
\(y \le (z_1 z_2)^{1/2}, \qquad y \ge 0, \qquad z_1 \ge 0, \qquad z_2 \ge 0.\)

2. Assume \(n = 2^k\) for some \(k \in \mathbf{N}\). Formulate as an equivalent system of second-order cone constraints the condition
\(y \le (z_1 z_2 \cdots z_n)^{1/n}, \qquad y \ge 0, \qquad z_i \ge 0 \quad \text{for } i=1,\dots,n.\)
Auxiliary variables may be introduced if needed.

3. Extend the construction in item 2 to arbitrary \(n \in \mathbf{N}\). Give an equivalent second-order cone representation of
\(y \le (z_1 z_2 \cdots z_n)^{1/n}, \qquad y \ge 0, \qquad z_i \ge 0 \quad \text{for } i=1,\dots,n.\)
Auxiliary variables may be introduced if needed, but the formulation must remain equivalent to the original constraint.
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set BigOperators

/-- A 3-variable rotated second-order cone constraint:
`u ≥ 0`, `v ≥ 0`, and `w^2 ≤ 2uv`. -/
def RSOC (u v w : ℝ) : Prop :=
  0 ≤ u ∧ 0 ≤ v ∧ w ^ 2 ≤ 2 * u * v

/-- The geometric-mean inequality for two variables, written as a rotated SOC constraint. -/
def GM2SOC (y z₁ z₂ : ℝ) : Prop :=
  0 ≤ y ∧ RSOC z₁ z₂ (Real.sqrt 2 * y)

/-- The product-form geometric mean inequality:
`y ≥ 0`, all `z i ≥ 0`, and `y^n ≤ ∏ z i`. -/
def GeomMeanConstraint (n : ℕ) (y : ℝ) (z : Fin n → ℝ) : Prop :=
  0 ≤ y ∧ (∀ i, 0 ≤ z i) ∧ y ^ n ≤ ∏ i, z i

/-- Left half of a vector of length `2^(k+1)`. -/
def leftVec {k : ℕ} (z : Fin (2 ^ (k + 1)) → ℝ) : Fin (2 ^ k) → ℝ :=
  fun i =>
    z ⟨i.1, by
      calc
        i.1 < 2 ^ k := i.isLt
        _ < 2 ^ k + 2 ^ k := Nat.lt_add_of_pos_right (by positivity)
        _ = 2 ^ (k + 1) := by
          simp [pow_succ, two_mul, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc]⟩

/-- Right half of a vector of length `2^(k+1)`. -/
def rightVec {k : ℕ} (z : Fin (2 ^ (k + 1)) → ℝ) : Fin (2 ^ k) → ℝ :=
  fun i =>
    z ⟨2 ^ k + i.1, by
      calc
        2 ^ k + i.1 < 2 ^ k + 2 ^ k := Nat.add_lt_add_left i.isLt _
        _ = 2 ^ (k + 1) := by
          simp [pow_succ, two_mul, Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc]⟩

/-- Recursive SOC representation for the geometric mean of `2^k` nonnegative variables. -/
def SocPowTwo : (k : ℕ) → ℝ → (Fin (2 ^ k) → ℝ) → Prop
  | 0, y, z =>
      0 ≤ y ∧ y ≤ z 0 ∧ 0 ≤ z 0
  | k + 1, y, z =>
      ∃ u v : ℝ,
        SocPowTwo k u (leftVec z) ∧
        SocPowTwo k v (rightVec z) ∧
        GM2SOC y u v

/-- Pad a vector `z : Fin n → ℝ` to length `m ≥ n` by filling the new coordinates with `y`. -/
def padWith {n m : ℕ} (_h : n ≤ m) (y : ℝ) (z : Fin n → ℝ) : Fin m → ℝ :=
  fun i =>
    if hi : i.1 < n then
      z ⟨i.1, hi⟩
    else
      y

/-- Item 1: the 2-variable geometric mean constraint is equivalent to a rotated SOC constraint. -/
theorem geomMean_two_equiv_soc (y z₁ z₂ : ℝ) :
    (y ≤ Real.sqrt (z₁ * z₂) ∧ 0 ≤ y ∧ 0 ≤ z₁ ∧ 0 ≤ z₂) ↔
      GM2SOC y z₁ z₂ := by
  sorry

/-- Item 2: when `n = 2^k`, the geometric mean constraint is equivalent to a recursive
system of rotated second-order cone constraints with auxiliary variables. -/
theorem geomMean_powTwo_equiv_soc (k : ℕ) (y : ℝ) (z : Fin (2 ^ k) → ℝ) :
    GeomMeanConstraint (2 ^ k) y z ↔ SocPowTwo k y z := by
  sorry

/-- Item 3: for arbitrary positive `n`, one may pad the variable list up to a power of two
with copies of `y`, obtaining an equivalent SOC representation. -/
theorem geomMean_arbitrary_equiv_soc
    (n : ℕ) (hn : 0 < n) (y : ℝ) (z : Fin n → ℝ) :
    ∃ k : ℕ, ∃ h : n ≤ 2 ^ k,
      GeomMeanConstraint n y z ↔
        SocPowTwo k y (padWith h y z) := by
  sorry
