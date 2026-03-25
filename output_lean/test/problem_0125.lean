/-
index: 125
source_idx: Exercise 3.28
source: bv_cvxbook_extra_exercises
题目类型: ["求值题"]
预估难度: []
problem:
Let \((X_1,X_2,X_3,X_4)\) be a random vector with values in \(\{0,1\}^4\). Consider all joint distributions of \((X_1,X_2,X_3,X_4)\) satisfying
\(\mathbf{P}(X_1=1)=0.9, \qquad \mathbf{P}(X_2=1)=0.9, \qquad \mathbf{P}(X_3=1)=0.1,\)
\(\mathbf{P}(X_1=1, X_4=0 \mid X_3=1)=0.7, \qquad \mathbf{P}(X_4=1 \mid X_2=1, X_3=0)=0.6.\)
Assume the conditional probabilities are well-defined, i.e.
\(\mathbf{P}(X_3=1)>0, \qquad \mathbf{P}(X_2=1, X_3=0)>0.\)
Determine the extremal values of the marginal probability \(\mathbf{P}(X_4=1)\) over all such joint distributions.

1. Formulate the optimization problem for
\(\min \mathbf{P}(X_4=1)\)
subject to the above probability constraints.

2. Formulate the optimization problem for
\(\max \mathbf{P}(X_4=1)\)
subject to the above probability constraints.

3. Compute the minimum and maximum possible values of \(\mathbf{P}(X_4=1)\).
proof:

direct_answer:

-/

import Mathlib

noncomputable section

open Set

abbrev Ω := Fin 4 → Bool

def eventProb (p : Ω → ℝ) (A : Set Ω) : ℝ :=
  ∑ ω : Ω, if ω ∈ A then p ω else 0

def IsJointDistribution (p : Ω → ℝ) : Prop :=
  (∀ ω : Ω, 0 ≤ p ω) ∧ (∑ ω : Ω, p ω = 1)

def X1_eq_1 : Set Ω := {ω | ω 0 = true}
def X2_eq_1 : Set Ω := {ω | ω 1 = true}
def X3_eq_1 : Set Ω := {ω | ω 2 = true}
def X3_eq_0 : Set Ω := {ω | ω 2 = false}
def X4_eq_1 : Set Ω := {ω | ω 3 = true}
def X4_eq_0 : Set Ω := {ω | ω 3 = false}

def feasible (p : Ω → ℝ) : Prop :=
  IsJointDistribution p ∧
  eventProb p X1_eq_1 = (9 : ℝ) / 10 ∧
  eventProb p X2_eq_1 = (9 : ℝ) / 10 ∧
  eventProb p X3_eq_1 = (1 : ℝ) / 10 ∧
  eventProb p {ω | ω 0 = true ∧ ω 3 = false ∧ ω 2 = true} =
    (7 : ℝ) / 10 * eventProb p X3_eq_1 ∧
  eventProb p {ω | ω 3 = true ∧ ω 1 = true ∧ ω 2 = false} =
    (6 : ℝ) / 10 * eventProb p {ω | ω 1 = true ∧ ω 2 = false} ∧
  0 < eventProb p X3_eq_1 ∧
  0 < eventProb p {ω | ω 1 = true ∧ ω 2 = false}

def objective (p : Ω → ℝ) : ℝ :=
  eventProb p X4_eq_1

def attainableObjectiveValues : Set ℝ :=
  {t : ℝ | ∃ p : Ω → ℝ, feasible p ∧ objective p = t}

def minValue : ℝ :=
  sInf attainableObjectiveValues

def maxValue : ℝ :=
  sSup attainableObjectiveValues

theorem min_problem_formulation :
    minValue = sInf {t : ℝ | ∃ p : Ω → ℝ, feasible p ∧ objective p = t} := by
  rfl

theorem max_problem_formulation :
    maxValue = sSup {t : ℝ | ∃ p : Ω → ℝ, feasible p ∧ objective p = t} := by
  rfl

theorem min_possible_value :
    minValue = (12 : ℝ) / 25 := by
  sorry

theorem max_possible_value :
    maxValue = (61 : ℝ) / 100 := by
  sorry

theorem extremal_values_of_P_X4_eq_1 :
    minValue = (12 : ℝ) / 25 ∧ maxValue = (61 : ℝ) / 100 := by
  constructor
  · exact min_possible_value
  · exact max_possible_value
