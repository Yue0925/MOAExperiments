using JuMP, CPLEX, Gurobi, LinearAlgebra
include("../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA



function solve_kQKP(fname ; algo_bb =false, algo_eps=false, heur=false )
    include(fname)
    # println("Q1 is PSD ? ", minimum(eigvals(Q1))>=0.0 ) 
    # println("Q2 is PSD ? ", minimum(eigvals(Q2))>=0.0 ) 

    model = Model()
    set_silent(model)

    @variable(model, x[1:n], Bin)

    @objective(model, Max, [x'*Q1*x, x'*Q2*x])

    @constraint(model, x'*w ≤ W)
    @constraint(model, sum(x) == k)


    set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))

    if algo_bb
        set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())
        set_attribute(model, MOA.LowerBoundsLimit(), 5)
        set_attribute(model, MOA.ConvexQCR(), true)
        set_attribute(model, MOA.Heuristic(), heur)

    elseif algo_eps
        set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
        set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)
    else
        @error("unknown algo parameter " )
        return []
    end


    optimize!(model)
    solution_summary(model)
    println("total time ", solve_time(model) )
    
    nb_sol = result_count(model) ; sols = []
    println(nb_sol, " non dominated sols ")
    for i in 1:nb_sol
        @assert is_solved_and_feasible(model; result = i)
        println(objective_value(model; result = i) )
        push!(sols, objective_value(model; result = i))
        println("sol: ", value.(x ; result = i))
    end



    if algo_bb
        println("total nodes: ",  node_count(model) )

        println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )
        
        println("heuristic time ", get_attribute(model, MOA.HeuristicTime()) )
    end

    return sols
end


fname = "./instances/QKP_20_100_100"




bb_sols = solve_kQKP(fname, algo_bb = true, heur=true  )
# bb_heur_sols = solve_kQKP(fname, algo_bb = true, heur=true  )

epsilon_sols = solve_kQKP(fname, algo_eps = true  )

# y_l = epsilon_sols[1]
# λ = [0.4, 0.6]

# for y in epsilon_sols 
#     println("y = $y , ", y'*λ, " is extreme point ? ", y'*λ>= y_l'*λ) 
# end


for sol in epsilon_sols
    if !(sol in bb_sols)
        println("error MOBB")
    end

    # if !(sol in bb_heur_sols)
    #     println("error MOBB heuristic")
    # end
    
end



# compare to MOBB
# for i in nb_sol
#     if sol_epsilon[i] != objective_value(model; result = i) 
#         @error("different solutions with epsilon constant")
#     end
# end

# # epsilon
# # 17 non dominated sols 
# total time 72.01793694496155
# 17 non dominated sols 
# [257.0, 33.0] ok
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]
# [223.0, 38.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]
# [202.0, 53.0]
# sol: [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
# [199.0, 91.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0]
# [193.0, 108.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0]
# [188.0, 120.0] ok 
# sol: [0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]
# [180.0, 125.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
# [175.0, 126.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]
# [169.0, 136.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0]
# [168.0, 143.0] ok
# sol: [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]
# [164.0, 192.0]
# sol: [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
# [162.0, 197.0]
# sol: [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]
# [134.0, 208.0]
# sol: [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
# [127.0, 211.0]
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]
# [110.0, 228.0]
# sol: [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]
# [97.0, 231.0]
# sol: [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0]
# [90.0, 284.0] ok
# sol: [0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]
 
