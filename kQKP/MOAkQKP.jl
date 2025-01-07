using JuMP, CPLEX, Gurobi, LinearAlgebra
include("../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA

fname = "./instances/QKP_10_100_50"

include(fname)
println("Q1 is PSD ? ", minimum(eigvals(Q1))>=0.0 ) 
println("Q2 is PSD ? ", minimum(eigvals(Q2))>=0.0 ) 


model = Model()
# set_silent(model)

@variable(model, x[1:n], Bin)

@objective(model, Max, [x'*Q1*x, x'*Q2*x])

@constraint(model, x'*w ≤ W)
@constraint(model, sum(x) == k)


set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))


set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())
set_attribute(model, MOA.LowerBoundsLimit(), 5)


# set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
# set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)


optimize!(model)
solution_summary(model)


nb_sol = result_count(model)
for i in 1:nb_sol
    @assert is_solved_and_feasible(model; result = i)
    println(objective_value(model; result = i) )
end


# # epsilon N
# sol_epsilon = [
    # [227.0, 20.0]
    # [184.0, 112.0]
    # [139.0, 163.0]
    # [126.0, 197.0]
    # [87.0, 243.0]
    # [55.0, 254.0]
    # [40.0, 287.0]
    # [37.0, 296.0]
    # [0.0, 300.0]
# ]

# [226.99999992253268, 20.00000007147644]
# [226.99999611194795, 20.00000368750588]
# [226.9999925316811, 20.000005864169978]
# [226.99999036169856, 20.000008896829794]
# [226.9999752168231, 20.000021504346623]
# [226.99993934912678, 20.000055750309215]
# [183.99999710158556, 111.999999729653]
# [139.0, 163.0]
# [126.0, 172.0]
# [125.99999998949774, 196.99999963214847]
# [86.99999999531846, 242.99999998933254]
# [55.0, 254.0]
# [39.99999929870562, 286.99999807036795]
# [36.999999792326285, 295.99999928276026]
# [4.662841980288453e-8, 299.99999989852256]
# total nodes: 161
# pruned nodes: 68




# [148.99999998220613, 51.00000000968117]
# [73.00000001817422, 153.99997389123476]
# [73.00000000574757, 153.99999998172487]
# [59.99999995045937, 190.99999987353675]
# total nodes: 23
# pruned nodes: 9



# compare to MOBB
# for i in nb_sol
#     if sol_epsilon[i] != objective_value(model; result = i) 
#         @error("different solutions with epsilon constant")
#     end
# end


println("total nodes: ",  node_count(model) )

println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )
