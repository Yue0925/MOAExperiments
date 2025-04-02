


folder = "./instances/"
for file in readdir(folder)
    include(folder * file)

    println(file * "...")
    
    Q = (Q1 .+ Q2)

    Q3 = zeros(Int64, n, n) ; maxi = maximum(Q) ; mini = minimum(Q)

    for i in 1:n-1
        for j in i+1:n
            # if Q1[i, j] == 0
            #     nothing

            if Q[i, j] < (maxi-mini)/2
                Q3[i, j] = rand((maxi-Q[i, j]+mini):(maxi)) 
            elseif Q[i, j] >= (maxi-mini)/2
                Q3[i, j] = rand((mini):(maxi-Q[i, j]+mini))
            else
                error("Coefficient error Q[$i, $j] = $(Q[i, j]), maximum = $maxi, minimum = $mini !")
            end            
        end
    end

    fout = open("./TOinstances/" * file, "w")

    println(fout, "n = ", n)

    println(fout, "Q1 = ", Q1)

    println(fout, "Q2 = ", Q2)
    println(fout, "Q3 = ", Q3)


    close(fout)
end