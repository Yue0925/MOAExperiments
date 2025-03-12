using JuMP, CPLEX, Gurobi, LinearAlgebra
include("../../../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA






function one_solve(N, Q1, Q2, fout; log=true)

    model = Model()
    # set_silent(model)

    @variable(model, x[1:N], Bin)

    @objective(model, Max, [sum( Q1[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N) , 
                            sum( Q2[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N) 
                            ]
    )

    set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))


    set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
    set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)

    set_time_limit_sec(model, 1800.0)


    optimize!(model)
    # solution_summary(model)
    println("total time ", solve_time(model) )
    log ? println(fout, "total_time = ", round(solve_time(model), digits = 2)) : nothing
    
    nb_sol = result_count(model) ; sols = []
    println(nb_sol, " non dominated sols ")
    log ? println(fout, "NDP = ", result_count(model)) : nothing

    for i in 1:nb_sol
        @assert is_solved_and_feasible(model; result = i)
        println(objective_value(model; result = i) )
        push!(sols, objective_value(model; result = i))
        println("sol: ", value.(x ; result = i))
    end


    log ? println(fout, "Y_N = ", sols) : nothing

    return sols
end



function warmup(Q1, Q2, n)
    println("warming up with instance size of 10 ... ")
    fout = open("warmup.log", "w")

    one_solve(n, Q1, Q2, fout)
    close(fout)

end


function run(fname)
    println("reading  ", fname)
    folder = "../res/"
    if !isdir(folder)
        mkdir(folder)
    end
    folder = "../res/epsilon/"
    if !isdir(folder)
        mkdir(folder)
    end


    include("../instances/" * split(fname, "/")[end])

    fout = open(folder * split(fname, "/")[end] , "w")
    one_solve(n, Q1, Q2, fout)
    close(fout)

end



n = 10

Q1 = [0 21 21 12 48 13 12 18 48 7; 0 0 34 42 46 33 32 29 30 45; 0 0 0 45 12 12 25 31 5 35; 0 0 0 0 28 29 33 47 32 15; 0 0 0 0 0 22 36 9 8 9; 0 0 0 0 0 0 37 37 40 42; 0 0 0 0 0 0 0 21 40 48; 0 0 0 0 0 0 0 0 29 6; 0 0 0 0 0 0 0 0 0 35; 0 0 0 0 0 0 0 0 0 0]

Q2 = [0.0 41.0 47.0 39.0 0.0 39.0 36.0 42.0 0.0 48.0; 0.0 0.0 14.0 3.0 0.0 4.0 10.0 13.0 14.0 2.0; 0.0 0.0 0.0 1.0 47.0 48.0 16.0 8.0 48.0 3.0; 0.0 0.0 0.0 0.0 8.0 1.0 5.0 1.0 16.0 45.0; 0.0 0.0 0.0 0.0 0.0 26.0 1.0 44.0 44.0 43.0; 0.0 0.0 0.0 0.0 0.0 0.0 4.0 1.0 2.0 5.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 47.0 3.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 44.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 11.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]


warmup(Q1, Q2, n)





folder = "../instances/"
for file in readdir(folder)
    println("\n\nsolving ", folder * file, "    with epsilon method")
    run(folder * file)
end




