
# Bi-objective linear assignment problem
using JuMP, CPLEX
include("../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA
# using .MultiObjectiveAlgorithms


# C1 = [5 1 4 7; 6 2 2 6; 2 8 4 4; 3 5 7 1] .* 1.3
# C2 = [3 6 4 2; 1 3 8 3; 5 2 2 3; 4 2 3 5] .* 1.3
# n = size(C2, 1)

# model = Model()
# set_silent(model)
# @variable(model, x[1:n, 1:n], Bin)
# @objective(model, Min, [sum(C1 .* x), sum(C2 .* x)])
# @constraint(model, [i = 1:n], sum(x[i, :]) == 1)
# @constraint(model, [j = 1:n], sum(x[:, j]) == 1)
# set_optimizer(model, () -> MOA.Optimizer(CPLEX.Optimizer))
# set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
# # set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)
# optimize!(model)
# solution_summary(model)



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
set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
set_silent(model)
optimize!(model)
solution_summary(model)
