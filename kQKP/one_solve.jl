using JuMP, CPLEX, Gurobi, LinearAlgebra
include("../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA



function one_solve(fname, fout; log=true, algo_bb =false, algo_eps=false, heur=false, preproc=0)
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

        log ? println(fout, "heur = ", heur) : nothing
        log ? println(fout, "LBS_limit = ", 3) : nothing
        log ? println(fout, "preproc = ", preproc) : nothing

    elseif algo_eps
        set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())
        set_attribute(model, MOA.EpsilonConstraintStep(), 0.01)

    else
        @error("unknown algo parameter " )
        return []
    end


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


    if algo_bb
        println("total nodes: ",  node_count(model) )

        println("pruned nodes: ", get_attribute(model, MOA.PrunedNodeCount()) )
        
        println("heuristic time ", get_attribute(model, MOA.HeuristicTime()) )

        log ? println(fout, "total_nodes = ", node_count(model)) : nothing
        log ? println(fout, "pruned_nodes = ", get_attribute(model, MOA.PrunedNodeCount())) : nothing
        log ? println(fout, "heur_time = ", round(get_attribute(model, MOA.HeuristicTime()) , digits = 2)) : nothing
    end

    log ? println(fout, "Y_N = ", sols) : nothing

    return sols
end

function warm_up()
    one_solve("./warmup/QKP_5_100_100", nothing, log = false, algo_eps=true )

    one_solve("./warmup/QKP_5_100_100", nothing, log = false, algo_bb = true, heur=true, preproc=1 )
end



function run(fname, method)
    inst = split(fname, "/")[end]
    # n = parse(Int64, split(inst, "_")[2])
    # if n!=20 && n!=25
    #     return
    # end

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
        fout = open(logname, "w")
        one_solve(fname, fout, algo_bb = true, heur=false, preproc=2)
        close(fout)
    end


end

# fname = "./instances/QKP_10_100_75"

println("warm up ...")
warm_up()
println("\n\nsolving ", ARGS[1], "\t with \t ", ARGS[2])
run(ARGS[1], ARGS[2])
