
function epsilon(fname, fout)
    failed = false 

    if isfile(fname)
        f = open(fname, "r")
        if length(readlines(f)) < 3 failed = true end 
        close(f)
    else
        failed = true
    end

    if failed
        print(fout, " & & ")
    else
        include(fname)
        print(fout, total_time, " & ", NDP, " & ")
    end 

end


function bb_heur(fname, fout)
    failed = false 

    if isfile(fname)
        f = open(fname, "r")
        if length(readlines(f)) < 9 failed = true end 
        close(f)
    else
        failed = true
    end

    if failed
        print(fout, " & & & & & ")
    else
        include(fname)
        print(fout, heur_time, " & ", total_time, " & ", total_nodes, " & ", 
                pruned_nodes, " & ", NDP, " & "
        )
    end 

end



function bb_heur_preproc1(fname, fout)
    failed = false 

    if isfile(fname)
        f = open(fname, "r")
        if length(readlines(f)) < 9 failed = true end 
        close(f)
    else 
        failed = true
    end

    if failed
        print(fout, " & & & & & ")
    else
        include(fname)
        print(fout, heur_time, " & ", total_time, " & ", total_nodes, " & ", 
                pruned_nodes, " & ", NDP, " & "
        )
    end 

end

function run(fname)
    fout = open("result.txt", "a")
    inst = split(fname, "/")[end]

    n = split(inst, "_")[2]
    d = split(inst, "_")[end]

    print(fout, inst, " & ", n, " & ", d, " & ")

    epsilon("./res/Gurobi/epsilon/" * inst, fout)
    bb_heur("./res/Gurobi/bb_heur/" * inst, fout)
    bb_heur_preproc1("./res/Gurobi/bb_heur_preproc1/" * inst, fout)

    println(fout, "\\\\")

    close(fout)
end


run(ARGS[1])