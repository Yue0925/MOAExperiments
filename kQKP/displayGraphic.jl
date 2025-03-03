using PyPlot

function computeCornerPointsLowerEnvelop(S1, S2)
    # when all objectives have to be maximized
    Env1=[]; Env2=[]
    for i in 1:length(S1)-1
        push!(Env1, S1[i]); push!(Env2, S2[i])
        push!(Env1, S1[i+1]); push!(Env2, S2[i])
    end
    push!(Env1, S1[end]);push!(Env2, S2[end])
    return Env1,Env2
end


function displayGraphics(fname,YN, output::String, L_uqcr, L_qcr, L_uqcrrel)
    println("displayGraphics")
    # DisplayYN   = true          # Non-dominated points corresponding to efficient solutions
    # DisplayUBS  = false         # Points belonging to the Upper Bound Set
    # DisplayLBS  = false         # Points belonging to the Lower Bound Set
    # DisplayInt  = false         # Points corresponding to integer solutions
    # DisplayProj = false         # Points corresponding to projected solutions
    # DisplayFea  = false         # Points corresponding to feasible solutions
    # DisplayPer  = false         # Points corresponding to perturbated solutions

    YN_1=[];YN_2=[]
    for i in 1:length(YN)
        push!(YN_2, YN[i][2])
        push!(YN_1, YN[i][1])
    end

    # --------------------------------------------------------------------------
    # Setup
    figure("Objective space",figsize=(7.5,5))
    xlabel(L"z^2(x)")
    ylabel(L"z^1(x)")
    PyPlot.title("$fname")

    # --------------------------------------------------------------------------
    # Display Non-Dominated points
    # if DisplayYN
        # display only the points corresponding to non-dominated points
        scatter(YN_2, YN_1, color="red", marker="+", label = L"y \in Y_N")
        # display segments joining adjacent non-dominated points
        plot(YN_2, YN_1, color="red", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        # display segments joining non-dominated points and their corners points
        Env1,Env2 = computeCornerPointsLowerEnvelop(YN_2, YN_1)
        plot(Env1, Env2,color="red", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
    # end

    # --------------------------------------------------------------------------
    # Display a Upper bound set (primal, by default)
    # if DisplayUBS
    #     plot(xU, yU, color="green", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
    #     scatter(xU, yU, color="green", label = L"y \in U", s = 150,alpha = 0.3)
    #     scatter(xU, yU, color="green", marker="o", label = L"y \in U")
    # end


    xL = []; yL = []
    for i in 1:length(L_uqcr)
        push!(xL, L_uqcr[i][1])
        push!(yL, L_uqcr[i][2])
    end

    # --------------------------------------------------------------------------
    # Display a Lower bound set (dual, by excess)
    # if DisplayLBS
        plot(yL, xL, color="blue", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        scatter(yL, xL, color="blue", marker="x", label = L"y \in L_{uqcr}")
    # end


    xL = []; yL = []
    for i in 1:length(L_qcr)
        push!(xL, L_qcr[i][1])
        push!(yL, L_qcr[i][2])
    end

    # --------------------------------------------------------------------------
    # Display a Lower bound set (dual, by excess)
    # if DisplayLBS
        plot(yL, xL, color="green", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        scatter(yL, xL, color="green", marker="*", label = L"y \in L_{qcr}")
    # end

    xL = []; yL = []
    for i in 1:length(L_uqcrrel)
        push!(xL, L_uqcrrel[i][1])
        push!(yL, L_uqcrrel[i][2])
    end

    # --------------------------------------------------------------------------
    # Display a Lower bound set (dual, by excess)
    # if DisplayLBS
        plot(yL, xL, color="orange", linewidth=0.75, marker="+", markersize=1.0, linestyle=":")
        scatter(yL, xL, color="orange", marker="o", label = L"y \in L_{uqcrrelax}")
    # end

    # # --------------------------------------------------------------------------
    # # Display integer points (feasible and non-feasible in GravityMachine)
    # if DisplayInt
    #     scatter(XInt,YInt, color="orange", marker="s", label = L"y"*" rounded")
    # end

    # # --------------------------------------------------------------------------
    # # Display projected points (points Δ(x,x̃) in GravityMachine)
    # if DisplayProj
    #     scatter(XProj,YProj, color="red", marker="x", label = L"y"*" projected")
    # end

    # # --------------------------------------------------------------------------
    # # Display feasible points
    # if DisplayFea
    #     scatter(XFeas,YFeas, color="green", marker="o", label = L"y \in F")
    # end

    # # --------------------------------------------------------------------------
    # # Display perturbed points (after a cycle in GravityMachine)
    # if DisplayPer
    #     scatter(XPert,YPert, color="magenta", marker="s", label ="pertub")
    # end

    # --------------------------------------------------------------------------
    legend(bbox_to_anchor=[1,1], loc=0, borderaxespad=0, fontsize = "x-small")
    savefig(output * ".png")
    PyPlot.close()
end

Y_N = -[[791.0, 176.0], 
[768.0, 206.0],
[721.0, 244.0],
[717.0, 265.0],
[705.0, 269.0],
[700.0, 270.0],
[690.0, 277.0],
[688.0, 315.0],
[647.0, 327.0],
[645.0, 346.0],
[632.0, 360.0],
[621.0, 371.0],
[619.0, 378.0],
[610.0, 379.0],
[605.0, 391.0],
[599.0, 402.0],
[598.0, 405.0],
[594.0, 434.0],
[567.0, 450.0],
[554.0, 481.0],
[541.0, 482.0],
[529.0, 489.0],
[525.0, 511.0],
[501.0, 529.0],
[498.0, 533.0],
[487.0, 538.0],
[482.0, 544.0],
[481.0, 566.0],
[448.0, 586.0],
[447.0, 592.0],
[416.0, 607.0],
[407.0, 613.0],
[399.0, 640.0],
[368.0, 667.0],
[361.0, 672.0],
[357.0, 681.0],
[330.0, 691.0]
]




L_uqcr = [
    [-3595.8871541645663, -3485.348136364479], [-3502.2447355924664, -3551.6917791634496]
]

L_qcr = [
    [-873.528624906372, -631.4612849087935], [-862.4037901817937, -796.6766847875115], 
    [-842.1430774452092, -831.5051091557762], [-813.8889292554522, -848.5003658860805], 
    [-754.1161579604086, -855.3281721463427]
]


L_uqcrrelax = [
    [-1937.3961845206989, -1842.8766880683283], [-1923.4892973926621, -1860.188619226661], 
    [-1905.6795244833888, -1871.688085395153], [-1884.483241789277, -1878.6892010829845], 
    [-1859.9848725614522, -1881.9398973371935]
]


displayGraphics("QKP_20_100_100",Y_N, "QKP_20_100_100", L_uqcr, L_qcr, L_uqcrrelax)