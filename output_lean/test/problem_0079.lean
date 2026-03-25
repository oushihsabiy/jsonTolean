/-
index: 79
source_idx: Exercise 3.3-(e)
source: bv_cvxbook_extra_exercises
题目类型: ["其他"]
预估难度: []
problem:
Let \(x,y,z \in \mathbf{R}\) be scalar decision variables. Consider the constraint set
\(xy \ge 1, \qquad x \ge 0, \qquad y \ge 0.\)
A CVX model is intended to include this set, but the constraint \(xy \ge 1\) is rejected by the CVX disciplined convex programming (DCP) rules.

Rewrite the exercise as follows:

1. Explain briefly why the constraint set
\(xy \ge 1, \qquad x \ge 0, \qquad y \ge 0\)	is not valid under the CVX DCP rules, even though its feasible set is convex.

2. Give a reformulation that is equivalent to the same constraint set and is valid in CVX. The reformulation may use linear equalities or inequalities, CVX-recognized convex or concave functions, additional variables, or linear matrix inequalities. If equivalence is not immediate, justify briefly that the reformulated constraints define exactly the same feasible set.

3. Formulate a small CVX optimization problem in the scalar variables \(x\), \(y\), and \(z\) that includes the valid reformulated constraints from item 2, and solve it in CVX to verify that CVX accepts the model without a rule-set error. The objective and remaining constraints may be arbitrary; the problem is only required to test syntactic and DCP compliance.
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set
open Matrix

/-- The original feasible set from the problem statement. -/
def OriginalConstraint (x y : ℝ) : Prop :=
  1 ≤ x * y ∧ 0 ≤ x ∧ 0 ≤ y

/-- A `2 × 2` symmetric matrix used for an LMI reformulation. -/
def lmiMatrix (x y : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![x, 1
   ;1, y]

/-- The LMI reformulation: the matrix `[[x,1],[1,y]]` is positive semidefinite. -/
def LMIConstraint (x y : ℝ) : Prop :=
  Matrix.PosSemidef (lmiMatrix x y)

/--
Item 2 of the exercise, formalized as an equivalence:
for real scalars, the constraints `xy ≥ 1`, `x ≥ 0`, `y ≥ 0`
are equivalent to the positive semidefinite LMI
`[[x,1],[1,y]] ⪰ 0`.
-/
theorem originalConstraint_iff_LMI (x y : ℝ) :
    OriginalConstraint x y ↔ LMIConstraint x y := by
  sorry

/-- A small test optimization model: minimize `z` subject to the valid reformulated constraint
and the linear equality `z = x + y`. -/
def TestProblemFeasible (x y z : ℝ) : Prop :=
  LMIConstraint x y ∧ z = x + y

/-- The point `(x,y,z) = (1,1,2)` is feasible for the test problem. -/
theorem testProblem_feasible_point :
    TestProblemFeasible 1 1 2 := by
  sorry

/--
A natural mathematical certificate for the test problem:
every feasible point satisfies `z ≥ 2`.
Hence minimizing `z` over the test problem has optimal value `2`,
attained at `(1,1,2)`.
-/
theorem testProblem_lower_bound {x y z : ℝ} (h : TestProblemFeasible x y z) :
    2 ≤ z := by
  sorry

/-- The canonical optimizer for the test problem. -/
theorem testProblem_optimal_point :
    TestProblemFeasible 1 1 2 ∧
      (∀ x y z, TestProblemFeasible x y z → 2 ≤ z) := by
  constructor
  · exact testProblem_feasible_point
  · intro x y z hz
    exact testProblem_lower_bound hz
