# ==============================================================================
# Xavier Gandibleux - November 2021
#   Implemented in Julia 1.6

# ==============================================================================
# Using ϵ-constraint / dichotomy / branch-and-bound method with vOptGeneric, compute the set of non-dominated
# points of the following problem:
#
#   Max  sum{j=1,...,n} C(k,j) x(j)                k=1,...,2
#   st   sum{j=1,...,n} A(i,j) x(j) <= B(i)        i=1,...,m
#                       x(j) = 0 or 1

# ==============================================================================

println("""\nProject MOMH 2021" --------------------------------\n""")
verbose = false 
include("parserMomkpZL.jl")
include("parserMomkpPG.jl")

using JuMP, CPLEX
include("../../MultiObjectiveAlgorithms.jl/src/MultiObjectiveAlgorithms.jl")
import .MultiObjectiveAlgorithms as MOA

# ==============================================================================
# Datastructure of a generic bi-objective 0/1 IP where all coefficients are integer
#
#   Max  sum{j=1,...,n} C(k,j) x(j)                k=1,...,p
#   st   sum{j=1,...,n} A(i,j) x(j) <= b_{i}       i=1,...,m
#                       x(j) = 0 or 1

struct _bi01IP
  C  :: Matrix{Int} # objective functions, k=1..2, j=1..n
  A  :: Matrix{Int} # matrix of constraints, i=1..m, j=1..n
  b  :: Vector{Int} # right-hand side, i=1..m
end


function solveBi01IP(C, A, B)

  m, n_before = size(A)
  # scale test
  for n in [40] # , 50 20, 30, 40, 50
    println("n=$n")
    ratio = n/n_before

    # ---- setting the model
    model = Model() ; set_silent(model)

    @variable( model, x[1:n], Bin )
    @objective( model, Max, [ sum(C[1,j] * x[j] for j=1:n), sum(C[2,j] * x[j] for j=1:n)] )
    @constraint( model, cte[i=1:m], sum(A[i,j] * x[j] for j=1:n) <= round(Int, B[i]*ratio))

    set_optimizer(model, () -> MOA.Optimizer(CPLEX.Optimizer))

    set_attribute(model, MOA.Algorithm(), MOA.EpsilonConstraint())

    optimize!(model)

    sol_epsilon = [ objective_value(model; result = i) for i in 1:result_count(model) ]

    set_attribute(model, MOA.Algorithm(), MOA.MultiObjectiveBranchBound())
    set_attribute(model, MOA.LowerBoundsLimit(), 5)

    optimize!(model)

    sol_MOBB = [ objective_value(model; result = i) for i in 1:result_count(model) ]

    if length(sol_epsilon) != length(sol_MOBB)
      @error("different solutions")
    end

    for i in 1:length(sol_epsilon)
      if sol_epsilon[i] != sol_MOBB[i] @error("different solutions") end 
    end

  end

end


function main(fname::String)
  if !isfile(fname)
    @error "This file doesn't exist ! $fname"
  end

  if split(fname, "/")[end] == "readme" return end

  inst = split(fname, "/")[2]
  if inst == "MOMKP"
    # Read and load an instance of MO-01MKP from the collection of E. Zitzler / M. Laumanns
    momkpZL = readInstanceMOMKPformatZL(verbose,fname)

    # Reduce the MO-MKP instance to the two first objectives and store it as a generic Bi-01IP
    dat = _bi01IP(momkpZL.P[1:2,:], momkpZL.W, momkpZL.ω)
  elseif inst == "MOBKP"
    # Read and load an instance of Bi-01BKP from the collection of O. Perederieieva / X. Gandibleux
    momkpPG = readInstanceMOMKPformatPG(verbose,fname)

    # Store it as a generic bi-01IP
    dat = _bi01IP(momkpPG.P, momkpPG.W, momkpPG.ω)
  else
    @error "Unknown input file $fname"
  end


  solveBi01IP(dat.C, dat.A, dat.b) 

end




main(ARGS[1])
