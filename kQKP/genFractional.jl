

    folder = "./instances/"
    for file in readdir(folder)

        include(folder * file )

        Q1_ = Q1 .* 1.0 ; Q2_ = Q2 .* 1.0
        for i in 1:n
            for j in 1:n
                if Q1[i, j] != 0 
                    Q1_[i, j] += rand(0.0:0.01:1.0) * (rand(0.0:0.1:1.0) >= 0.5 ? 1.0 : -1.0)
                end
                if Q2[i, j] != 0 
                    Q2_[i, j] += rand(0.0:0.01:1.0) * (rand(0.0:0.1:1.0) >= 0.5 ? 1.0 : -1.0)
                end

            end
        end

        if !isdir("./fractional/")
            mkdir("./fractional/")
        end
    
        fout = open("./fractional/" * file , "w")
        println(fout, "n = ", n)
        println(fout, "density = ", density)
        println(fout, "Q1 = ", Q1_)
        println(fout, "w = ", w)
        println(fout, "W = ", W)
        println(fout, "k = ", k)
        println(fout, "inst_name = \"$inst_name\"")
        println(fout, "feasible = ", feasible)
        println(fout, "Q2 = ", Q2_)

        close(fout)
    end
