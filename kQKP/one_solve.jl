using JuMP, CPLEX, Gurobi, LinearAlgebra
include("../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA



function one_solve(fname, fout; log=true, algo_bb =false, algo_eps=false, 
                                heur=false, preproc=0, tight_root=0
        )
    include(fname)

    model = Model()
    set_silent(model)

    @variable(model, x[1:n], Bin)

    @objective(model, Max, [x'*Q1*x, x'*Q2*x])

    @constraint(model, x'*w ≤ W)
    @constraint(model, sum(x) == k)

    set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))

    if algo_bb
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

    elseif algo_eps
        set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
        set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)

    else
        @error("unknown algo parameter " )
        return []
    end

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


    if algo_bb
        println("total nodes: ",  node_count(model) )

        println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )
        println("pruned dominance nodes: ", get_attribute(model, MOA.PrunedDominanceNodeCount()) )
        println("heuristic time ", get_attribute(model, MOA.HeuristicTime()) )

        log ? println(fout, "total_nodes = ", node_count(model)) : nothing
        log ? println(fout, "pruned_nodes = ", get_attribute(model, MOA.PrunedNodeCount())) : nothing
        log ? println(fout, "pruned_dominance_nodes = ", get_attribute(model, MOA.PrunedDominanceNodeCount())) : nothing
        log ? println(fout, "heur_time = ", round(get_attribute(model, MOA.HeuristicTime()) , digits = 2)) : nothing
    end

    log ? println(fout, "Y_N = ", sols) : nothing

    return sols
end



function warm_up()
    one_solve("./warmup/QKP_5_100_75", nothing, log = false, algo_eps=true )

    one_solve("./warmup/QKP_5_100_75", nothing, log = false, algo_bb = true, heur=true, preproc=1 )
end



function run(fname, method)
    inst = split(fname, "/")[end]
    n = parse(Int64, split(inst, "_")[2])


    
    folder = "./res"
    if !isdir(folder)
        mkdir(folder)
    end

    folder = "./res/Gurobi"
    if !isdir(folder)
        mkdir(folder)
    end

    if method == "epsilon"
        folder = "./res/Gurobi/epsilon"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 
        fout = open(logname, "w")
        one_solve(fname, fout, algo_eps=true)
        close(fout)

    end

    if method == "bb"
        folder = "./res/Gurobi/bb"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 
        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=false)
        close(fout)
    end

    if method == "bb_heur"
        folder = "./res/Gurobi/bb_heur"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=true)
        close(fout)
    end

    if method == "bb_heur_preproc1"
        folder = "./res/Gurobi/bb_heur_preproc1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=true, preproc=1)
        close(fout)
    end

    if method == "bb_preproc1"
        folder = "./res/Gurobi/bb_preproc1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=false, preproc=1)
        close(fout)
    end

    if method == "bb_heur_preproc2"
        folder = "./res/Gurobi/bb_heur_preproc2"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=true, preproc=2)
        close(fout)
    end

    if method == "bb_preproc2"
        folder = "./res/Gurobi/bb_preproc2"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=false, preproc=2)
        close(fout)
    end


    if method == "bb_preproc1_tightroot1"
        folder = "./res/Gurobi/bb_preproc1_tightroot1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=false, preproc=1, tight_root=1)
        close(fout)
    end

    if method == "bb_preproc2_tightroot1"
        folder = "./res/Gurobi/bb_preproc2_tightroot1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=false, preproc=2, tight_root=1)
        close(fout)
    end
end




function one_solveTO(fname, fout; log=true, algo_bb =false, algo_eps=false, 
    heur=false, preproc=0, tight_root=0
)
    include(fname)

    model = Model()
    set_silent(model)

    @variable(model, x[1:n], Bin)

    @objective(model, Max, [x'*Q1*x, x'*Q2*x, x'*Q3*x])

    @constraint(model, x'*w ≤ W)
    @constraint(model, sum(x) == k)

    set_optimizer(model, () -> MOA.Optimizer(Gurobi.Optimizer))

    if algo_bb
        set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())
        set_attribute(model, MOA.LowerBoundsLimit(), 4)
        set_attribute(model, MOA.ConvexQCR(), true)
        set_attribute(model, MOA.Heuristic(), heur)
        set_attribute(model, MOA.Preproc(), preproc)
        set_attribute(model, MOA.TightRoot(), tight_root)
        set_attribute(model, MOA.TraverseOrder(), Symbol("dfs"))

        log ? println(fout, "heur = ", heur) : nothing
        log ? println(fout, "LBS_limit = ", 4) : nothing
        log ? println(fout, "preproc = ", preproc) : nothing
        log ? println(fout, "tight_root = ", tight_root) : nothing

    elseif algo_eps
        set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
        set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)

    else
        @error("unknown algo parameter " )
        return []
    end

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


    if algo_bb
        println("total nodes: ",  node_count(model) )

        println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )

        println("pruned dominance nodes: ", get_attribute(model, MOA.PrunedDominanceNodeCount()) )

        println("heuristic time ", get_attribute(model, MOA.HeuristicTime()) )

        log ? println(fout, "total_nodes = ", node_count(model)) : nothing
        log ? println(fout, "pruned_nodes = ", get_attribute(model, MOA.PrunedNodeCount())) : nothing
        log ? println(fout, "pruned_dominance_nodes = ", get_attribute(model, MOA.PrunedDominanceNodeCount())) : nothing
        log ? println(fout, "heur_time = ", round(get_attribute(model, MOA.HeuristicTime()) , digits = 2)) : nothing
    end

    log ? println(fout, "Y_N = ", sols) : nothing

    return sols
end



function run3(fname, method)
    inst = split(fname, "/")[end]
    n = parse(Int64, split(inst, "_")[2])


    
    folder = "./TOres"
    if !isdir(folder)
        mkdir(folder)
    end

    folder = "./TOres/Gurobi"
    if !isdir(folder)
        mkdir(folder)
    end

    if method == "epsilon"
        folder = "./TOres/Gurobi/epsilon"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 
        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_eps=true)
        close(fout)

    end

    if method == "bb"
        folder = "./TOres/Gurobi/bb"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 
        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=false)
        close(fout)
    end

    if method == "bb_heur"
        folder = "./TOres/Gurobi/bb_heur"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=true)
        close(fout)
    end

    if method == "bb_heur_preproc1"
        folder = "./TOres/Gurobi/bb_heur_preproc1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=true, preproc=1)
        close(fout)
    end

    if method == "bb_preproc1"
        folder = "./TOres/Gurobi/bb_preproc1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=false, preproc=1)
        close(fout)
    end

    if method == "bb_heur_preproc2"
        folder = "./TOres/Gurobi/bb_heur_preproc2"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=true, preproc=2)
        close(fout)
    end

    if method == "bb_preproc2"
        folder = "./TOres/Gurobi/bb_preproc2"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=false, preproc=2)
        close(fout)
    end


    if method == "bb_preproc1_tightroot1"
        folder = "./TOres/Gurobi/bb_preproc1_tightroot1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=false, preproc=1, tight_root=1)
        close(fout)
    end

    if method == "bb_preproc2_tightroot1"
        folder = "./TOres/Gurobi/bb_preproc2_tightroot1"
        if !isdir(folder)
            mkdir(folder)
        end

        logname = folder * "/" *inst 
        if isfile(logname) return end 

        fout = open(logname, "w")
        one_solveTO(fname, fout, algo_bb = true, heur=false, preproc=2, tight_root=1)
        close(fout)
    end
end



println("warm up ...")
warm_up()


println("\n\nsolving ", ARGS[1] , "    with ",  ARGS[2])

run( ARGS[1], ARGS[2])


# run3( ARGS[1], ARGS[2])
