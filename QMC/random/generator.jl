




using JuMP, CPLEX 





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




function completeG(n::Int64, iem::Int64)
    W = zeros(Int64, n, n) ; mini = 1000
    for i in 1:n-1
        for j in i+1:n
            W[i, j] = rand(5:50)
            mini = (mini>W[i, j]) ? W[i, j] : mini
        end        
    end
    # W_bis = zeros(Int64, n, n) ; maxi = maximum(W)
    # len = n*(n-1)/2
    # for i in 1:n-1 
    #     for j in i+i:n
    #         if W[i, j] < (maxi-mini)/2
    #             W_bis[i, j] = rand((maxi-W[i, j]+mini):(maxi)) 
    #         elseif W[i, j] >= (maxi-mini)/2
    #             W_bis[i, j] = rand((mini):(maxi-W[i, j]+mini))
    #         else
    #             error("Coefficient error W[$i, $j] = $(W[i, j]), maximum = $maxi, minimum = $mini !")
    #         end            
    #     end
    # end

    # --------------------
    name = "MaxCut_$(n)_$(iem)"
    folder = "./instances/"
    if !isdir(folder)
        mkdir(folder)
    end

    println("\n -----------------------------")
    println(" solving mono $(name) ... ")
    println(" -----------------------------")

    model = Model(CPLEX.Optimizer) ; JuMP.set_silent(model)
    @variable(model, x[i=1:n-1, j=i+1:n], Bin )
    @variable(model, y[1:n], Bin)
    @objective(model, Max, sum([W[i, j]*x[i, j] for i=1:n-1 for j=i+1:n]))
    @constraint(model, [i=1:n-1, j=i+1:n], x[i, j] ≤ y[i] + y[j])
    @constraint(model, [i=1:n-1, j=i+1:n], x[i, j] ≤ 2-(y[i] + y[j]))


    # relax_integrality(model)
    # optimize
    optimize!(model) ; solved_time = round(solve_time(model), digits = 2)
    println(" n = $(n)")
    println("solved time $(solved_time)" )
    status = JuMP.termination_status(model)

    if status != MOI.OPTIMAL
        @info "Not OPT ..."
        return #continue
    end

    fout = open(folder * name, "w")
    println(fout, "n = $(n)")

    println(fout, "Q1 = $W")

    Q2_corelation(W, fout, maximum(W), minimum(W))

    close(fout)

end







for n in 10:5:30
    for iem in 1:3
        completeG(n, iem)
    end
    
end