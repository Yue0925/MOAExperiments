

using JuMP, CPLEX
include("../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA
# using .MultiObjectiveAlgorithms



profit = [77, 94, 71, 63, 96, 82, 85, 75, 72, 91, 99, 63, 84, 87, 79, 94, 90]
desire = [65, 90, 90, 77, 95, 84, 70, 94, 66, 92, 74, 97, 60, 60, 65, 97, 93]
weight = [80, 87, 68, 72, 66, 77, 99, 85, 70, 93, 98, 72, 100, 89, 67, 86, 91]
capacity = 900
N = length(profit)

model = Model()
@variable(model, x[1:N], Bin)
@constraint(model, sum(weight[i] * x[i] for i in 1:N) <= capacity)
@expression(model, profit_expr, sum(profit[i] * x[i] for i in 1:N))
@expression(model, desire_expr, sum(desire[i] * x[i] for i in 1:N))
@objective(model, Max, [profit_expr, desire_expr])
set_optimizer(model, () -> MOA.Optimizer(CPLEX.Optimizer))

set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())

set_attribute(model, MOA.LowerBoundsLimit(), 5)


# set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())

set_silent(model)
optimize!(model)
solution_summary(model)
