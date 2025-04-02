
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
        print(fout, total_time>= 1800.0 ? "TO" : total_time, " & ", NDP, " & ")
    end 

end


function bb_preproc(fname, fout)
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
        print(fout, total_time>= 1800.0 ? "TO" : total_time, " & ", total_nodes, " & ", 
                pruned_nodes, " & ", pruned_dominance_nodes, " & ", NDP, " & "
        )
    end 

end



function bb_heur_preproc(fname, fout)
    failed = false 

    if isfile(fname)
        f = open(fname, "r")
        if length(readlines(f)) < 9 failed = true end 
        close(f)
    else 
        failed = true
    end

    if failed
        print(fout, " & & & & & & ")
    else
        include(fname)
        print(fout, heur_time, " & ", total_time>= 1800.0 ? "TO" : total_time , " & ", total_nodes, " & ", 
                pruned_nodes, " & ", pruned_dominance_nodes, " & ",  NDP, " & "
        )
    end 

end





# function run(fname)
#     fout = open("result.tab", "a")
#     inst = split(fname, "/")[end]

#     n = split(inst, "_")[2]
#     density = split(inst, "_")[3]

    
#     print(fout, inst, " & ", n, " & ", density, " & ")

#     epsilon("./res/epsilon/" * inst, fout)

#     bb_preproc("./res/bb_preproc0/" * inst, fout)

#     bb_preproc("./res/bb_preproc1/" * inst, fout)

#     # bb_heur_preproc("./res/bb_heur_preproc1/" * inst, fout)

#     # bb_heur_preproc("./res/bb_preproc1_tightroot1/" * inst, fout)

    

#     println(fout, "\\\\")

#     close(fout)
# end

# run(ARGS[1])




function runTO(fname)
    fout = open("resultTO.tab", "a")
    inst = split(fname, "/")[end]

    n = split(inst, "_")[2]
    density = split(inst, "_")[3]

    
    print(fout, inst, " & ", n, " & ", density, " & ")


    bb_preproc("./TOres/bb_preproc0/" * inst, fout)

    bb_preproc("./TOres/bb_preproc1/" * inst, fout)



    println(fout, "\\\\")

    close(fout)
end

runTO(ARGS[1])