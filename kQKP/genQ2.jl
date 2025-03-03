
using JuMP, Gurobi, CPLEX, Random

function colpmeleQ2()
    folder = "./instances/"
    for file in readdir(folder)
        include(folder * file)

        if parse(Int64, split(file, "_")[2]) < 30
            continue
        end
        println(file * "...")

        fout = open(folder * file, "a")
        println(fout, "inst_name = \"$file\" ")
        
        # test mono is feasible 
        println("\n -----------------------------")
        println(" solving mono $(file) ... ")
        println(" -----------------------------")
    
        model = Model(Gurobi.Optimizer) ; JuMP.set_silent(model)
        @variable(model, x[1:n], Bin )

        
        @objective(model, Max, x'*Q1*x)

        @constraint(model, x'*w ≤ W)
        @constraint(model, sum(x) == k)
    
    
        # optimize
        optimize!(model) ; solved_time = round(solve_time(model), digits = 2)
        println("solved time $(solved_time)" )
        status = JuMP.termination_status(model)
    
        if status != MOI.OPTIMAL
            @info "Not OPT ..."
            println(fout, "feasible = false ")
            close(fout)
            continue
        end


        println(fout, "feasible = true ")
        Random.seed!(n + density +100 )

        Q2 = zeros(Int64, n, n) ; maxi = maximum(Q1) ; mini = minimum(Q1)
        for i in 1:n 
            for j in 1:i
                # if Q1[i, j] == 0
                #     nothing

                if Q1[i, j] < (maxi-mini)/2
                    Q2[i, j] = rand((maxi-Q1[i, j]+mini):(maxi)) 
                elseif Q1[i, j] >= (maxi-mini)/2
                    Q2[i, j] = rand((mini):(maxi-Q1[i, j]+mini))
                else
                    error("Coefficient error Q1[$i, $j] = $(Q1[i, j]), maximum = $maxi, minimum = $mini !")
                end            
            end
        end

        println(fout, "Q2=$Q2")
        close(fout)
    end
end

colpmeleQ2()