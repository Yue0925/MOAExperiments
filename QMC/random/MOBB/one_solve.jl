using JuMP, CPLEX, Gurobi, LinearAlgebra
include("../../../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA




# todo :
function one_solve(N, Q1, Q2, Q3, fout; log=true, heur=false, preproc=-1, tight_root=0
    )

    model = Model()
    set_silent(model)

    @variable(model, x[1:N], Bin)

    @objective(model, Max, [sum( Q1[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N) , 
                            sum( Q2[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N) ,
                            sum( Q3[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N) 
                            ]
    )

    set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))

    set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())
    set_attribute(model, MOA.LowerBoundsLimit(), 4) # todo 
    set_attribute(model, MOA.ConvexQCR(), true)
    set_attribute(model, MOA.Heuristic(), heur)
    set_attribute(model, MOA.Preproc(), preproc)
    set_attribute(model, MOA.TightRoot(), tight_root)
    set_attribute(model, MOA.TraverseOrder(), Symbol("dfs"))

    log ? println(fout, "heur = ", heur) : nothing
    log ? println(fout, "LBS_limit = ", 3) : nothing
    log ? println(fout, "preproc = ", preproc) : nothing
    log ? println(fout, "tight_root = ", tight_root) : nothing


    set_time_limit_sec(model, 1800.0)

    optimize!(model)
    # solution_summary(model)
    println("total time ", solve_time(model) )
    log ? println(fout, "total_time = ", round(solve_time(model), digits = 2)) : nothing
    
    nb_sol = result_count(model) ; sols = []
    println(nb_sol, " non dominated sols ")
    log ? println(fout, "NDP = ", result_count(model)) : nothing

    for i in 1:nb_sol
        # @assert is_solved_and_feasible(model; result = i)
        println(objective_value(model; result = i) )
        push!(sols, objective_value(model; result = i))
        println("sol: ", value.(x ; result = i))
    end


    println("total nodes: ",  node_count(model) )

    println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )
    println("pruned dominance nodes: ", get_attribute(model, MOA.PrunedDominanceNodeCount()) )

    println("heuristic time ", get_attribute(model, MOA.HeuristicTime()) )

    log ? println(fout, "total_nodes = ", node_count(model)) : nothing
    log ? println(fout, "pruned_nodes = ", get_attribute(model, MOA.PrunedNodeCount())) : nothing
    log ? println(fout, "pruned_dominance_nodes = ", get_attribute(model, MOA.PrunedDominanceNodeCount())) : nothing

    log ? println(fout, "heur_time = ", round(get_attribute(model, MOA.HeuristicTime()) , digits = 2)) : nothing

    log ? println(fout, "Y_N = ", sols) : nothing

    return sols
end

function one_solve(N, Q1, Q2, fout; log=true, heur=false, preproc=-1, tight_root=0
    )

    model = Model()
    set_silent(model)

    @variable(model, x[1:N], Bin)

    @objective(model, Max, [sum( Q1[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N) , 
                            sum( Q2[i,j] * (x[i]*(1-x[j]) + x[j]*(1-x[i]) ) for i in 1:N for j in 1:N)
                            ]
    )

    set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))

    set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())
    set_attribute(model, MOA.LowerBoundsLimit(), 3)  
    set_attribute(model, MOA.ConvexQCR(), true)
    set_attribute(model, MOA.Heuristic(), heur)
    set_attribute(model, MOA.Preproc(), preproc)
    set_attribute(model, MOA.TightRoot(), tight_root)
    set_attribute(model, MOA.TraverseOrder(), Symbol("dfs"))

    log ? println(fout, "heur = ", heur) : nothing
    log ? println(fout, "LBS_limit = ", 3) : nothing
    log ? println(fout, "preproc = ", preproc) : nothing
    log ? println(fout, "tight_root = ", tight_root) : nothing


    set_time_limit_sec(model, 1800.0)

    optimize!(model)
    # solution_summary(model)
    println("total time ", solve_time(model) )
    log ? println(fout, "total_time = ", round(solve_time(model), digits = 2)) : nothing
    
    nb_sol = result_count(model) ; sols = []
    println(nb_sol, " non dominated sols ")
    log ? println(fout, "NDP = ", result_count(model)) : nothing

    for i in 1:nb_sol
        # @assert is_solved_and_feasible(model; result = i)
        println(objective_value(model; result = i) )
        push!(sols, objective_value(model; result = i))
        println("sol: ", value.(x ; result = i))
    end


    println("total nodes: ",  node_count(model) )

    println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )
    println("pruned dominance nodes: ", get_attribute(model, MOA.PrunedDominanceNodeCount()) )

    println("heuristic time ", get_attribute(model, MOA.HeuristicTime()) )

    log ? println(fout, "total_nodes = ", node_count(model)) : nothing
    log ? println(fout, "pruned_nodes = ", get_attribute(model, MOA.PrunedNodeCount())) : nothing
    log ? println(fout, "pruned_dominance_nodes = ", get_attribute(model, MOA.PrunedDominanceNodeCount())) : nothing

    log ? println(fout, "heur_time = ", round(get_attribute(model, MOA.HeuristicTime()) , digits = 2)) : nothing

    log ? println(fout, "Y_N = ", sols) : nothing

    return sols
end



function warmup(Q1, Q2, n)
    println("warming up with instance size of 10 ... ")

    fout = open("warmup.log", "w")
    one_solve(n, Q1, Q2, fout,  heur=true, preproc=2 , tight_root=1)
    close(fout)
    println("end of warming up ...\n\n")
end


function run(fname, method)
    println("hello ", fname)
    folder = "../res/"
    if !isdir(folder)
        mkdir(folder)
    end

    if method == "bb_preproc1"
        folder = "../res/bb_preproc1/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=false, preproc=1)
        close(fout)

    end

    if method == "bb_preproc0"
        folder = "../res/bb_preproc0/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])
        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=false, preproc=0)
        close(fout)
    end


    if method == "bb_heur_preproc1"
        folder = "../res/bb_heur_preproc1/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=true, preproc=1)
        close(fout)
    end

    if method == "bb_preproc2"
        folder = "../res/bb_preproc2/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=false, preproc=2)
        close(fout)

    end

    if method == "bb_heur_preproc2"
        folder = "../res/bb_heur_preproc2/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=true, preproc=2)
        close(fout)
    end

    if method == "bb_preproc1_tightroot1"
        folder = "../res/bb_preproc1_tightroot1/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=false, preproc=1, tight_root=1)
        close(fout)

    end


    if method == "bb_preproc2_tightroot1"
        folder = "../res/bb_preproc2_tightroot1/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../instances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, fout, heur=false, preproc=2, tight_root=1)
        close(fout)
    end



end




function runTO(fname, method)
    println("hello ", fname)
    folder = "../TOres/"
    if !isdir(folder)
        mkdir(folder)
    end

    if method == "bb_preproc1"
        folder = "../TOres/bb_preproc1/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../TOinstances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, Q3, fout, heur=false, preproc=1)
        close(fout)

    end

    if method == "bb_preproc0"
        folder = "../TOres/bb_preproc0/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../TOinstances/" * split(fname, "/")[end])
        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, Q3, fout, heur=false, preproc=0)
        close(fout)
    end


    if method == "bb_heur_preproc1"
        folder = "../TOres/bb_heur_preproc1/"
        if !isdir(folder)
            mkdir(folder)
        end

        include("../TOinstances/" * split(fname, "/")[end])

        logname  = folder * split(fname, "/")[end]
        if isfile(logname) return end 
        fout = open(logname, "w")

        one_solve(n, Q1, Q2, Q3, fout, heur=true, preproc=1)
        close(fout)
    end


end



n = 10

Q1 = [0 21 21 12 48 13 12 18 48 7; 0 0 34 42 46 33 32 29 30 45; 0 0 0 45 12 12 25 31 5 35; 0 0 0 0 28 29 33 47 32 15; 0 0 0 0 0 22 36 9 8 9; 0 0 0 0 0 0 37 37 40 42; 0 0 0 0 0 0 0 21 40 48; 0 0 0 0 0 0 0 0 29 6; 0 0 0 0 0 0 0 0 0 35; 0 0 0 0 0 0 0 0 0 0]

Q2 = [0.0 41.0 47.0 39.0 0.0 39.0 36.0 42.0 0.0 48.0; 0.0 0.0 14.0 3.0 0.0 4.0 10.0 13.0 14.0 2.0; 0.0 0.0 0.0 1.0 47.0 48.0 16.0 8.0 48.0 3.0; 0.0 0.0 0.0 0.0 8.0 1.0 5.0 1.0 16.0 45.0; 0.0 0.0 0.0 0.0 0.0 26.0 1.0 44.0 44.0 43.0; 0.0 0.0 0.0 0.0 0.0 0.0 4.0 1.0 2.0 5.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 47.0 3.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 44.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 11.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]

warmup(Q1, Q2, n)


# Q1 = [0 27 28 49 24 23 15 20 10 33; 0 0 50 15 36 46 42 14 27 44; 0 0 0 31 12 24 27 8 21 49; 0 0 0 0 5 41 19 18 28 30; 0 0 0 0 0 14 11 40 36 18; 0 0 0 0 0 0 31 48 9 25; 0 0 0 0 0 0 0 10 13 49; 0 0 0 0 0 0 0 0 49 6; 0 0 0 0 0 0 0 0 0 40; 0 0 0 0 0 0 0 0 0 0]
# Q2 = [0.0 17.0 2.0 0.0 29.0 32.0 48.0 44.0 48.0 2.0; 0.0 0.0 0.0 43.0 10.0 2.0 7.0 37.0 14.0 0.0; 0.0 0.0 0.0 5.0 38.0 31.0 20.0 45.0 39.0 1.0; 0.0 0.0 0.0 0.0 47.0 9.0 35.0 47.0 5.0 6.0; 0.0 0.0 0.0 0.0 0.0 36.0 47.0 6.0 13.0 39.0; 0.0 0.0 0.0 0.0 0.0 0.0 4.0 1.0 50.0 19.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 40.0 44.0 1.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 45.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 2.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]

# warmup(Q1, Q2, n)




# run(ARGS[1], ARGS[2])


runTO(ARGS[1], ARGS[2])



