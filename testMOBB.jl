

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
@constraint(model, sum(weight[i] * x[i] for i in 1:N) <= capacity/2 )
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

# get_attribute(model, MOA.PrunedNodeCount())

# nb_sol = result_count(model)
# for i in 1:nb_sol
#     @assert is_solved_and_feasible(model; result = i)
#     println(objective_value(model; result = i) )
# end

# # objective_value(model)

# # epsilon N
# sol_epsilon = [
# [506.0, 503.0],
# [503.0, 505.0],
# [502.0, 506.0],
# [498.0, 510.0],
# [497.0, 534.0],
# [493.0, 537.0],
# [478.0, 538.0],
# [471.0, 539.0],
# [469.0, 540.0],
# [462.0, 550.0]
# ]

# for i in nb_sol
#     if sol_epsilon[i] != objective_value(model; result = i) 
#         @error("different solutions with epsilon constant")
#     end
# end
