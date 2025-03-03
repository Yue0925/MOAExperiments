

"""
format u v w_uv
"""
function readFormat1(fname)
    f = open(fname)

    line = readline(f)

    n = parse(Int64, split(line, " ")[1] ) ; l = parse(Int64, split(line, " ")[2] ) 
    W = zeros(n, n)

    for i in 1:l
        line = readline(f)
        v = split(line, " ")

        i = parse(Int64, v[1]) ; j = parse(Int64, v[2] ) 
        w = parse(Float64, v[3] ) 
        W[i,j] = w

        # println("W[$i, $j] = $w")
    end

    close(f)

    # for i in 1:n
    #     for j in 1:n
    #         if i==j continue end 
    #         if W[i,j] != 0.0 && W[j,i] != W[i, j]
    #             error("directed edges !! W[$i, $j] = $(W[i, j]) and W[$j, $i] = $(W[j, i])")
    #         end
    #     end
        
    # end
    return n, W
end

"""
w,w,w,w ...
w,w,w,w ...
"""
function readFormat2(fname)
    N = 0; W= []; col = 0
    f = open(fname)

    for line in readlines(f)
        N += 1

        if col == 0 
            col = length(split(line, ","))
        elseif col != length(split(line, ","))
            error("line $N, col = ", length(split(line, ",")))
        end

        push!(W, parse.(Float64, split(line, ",")) )
    end
    close(f)

    Mat = reduce(vcat,transpose.(W))

    return N, Mat
end



function Q2_corelation(Q1, fout, maxi, mini)
    n = size(Q1, 1)
    Q2 = zeros( n, n) 

    for i in 1:n 
        for j in 1:n
            if Q1[i, j] ≈ 0
                nothing

            elseif Q1[i, j] < (maxi-mini)/2
                Q2[i, j] = rand((maxi-Q1[i, j]+mini):(maxi)) 

            elseif Q1[i, j] >= (maxi-mini)/2
                Q2[i, j] = rand((mini):(maxi-Q1[i, j]+mini))

            else
                error("Coefficient error Q1[$i, $j] = $(Q1[i, j]), maximum = $maxi, minimum = $mini !")
            end            
        end
    end

    println(fout, "Q2=$Q2")

end



function Q2_negative(Q1, fout)
    Q2 = -Q1
    println(fout, "Q2=$Q2")
end


# function Q2_random()
    
# end




function colpmeleQ2()

    folders = ["instances_neg/", "instances_neqfloat/", "instances_uni/"]

    for folder in folders
        if !isdir("Q2/" * folder)
            mkdir("Q2/" * folder)
        end

        for file in readdir(folder)
            fname = folder * file
            fout = open("Q2/" * folder * file, "w" )

            n, Q1 = nothing, nothing
            println("reading $fname ... ")

            if split(fname, "/")[end-1] == "instances_neg"
                n, Q1 = readFormat1(fname)

            elseif split(fname, "/")[end-1] == "instances_neqfloat"
                n, Q1 = readFormat2(fname)

            elseif split(fname, "/")[end-1] == "instances_uni"
                n, Q1 = readFormat2(fname)
                
            else
                error("Unkown input file $fname ...")
            end

            maxi = maximum(Q1); mini = minimum(Q1)
            if maxi - mini > 1
                Q2_corelation(Q1, fout, maxi, mini)
            else
                Q2_negative(Q1, fout)
            end

            close(fout)
        end
    end


end

colpmeleQ2()