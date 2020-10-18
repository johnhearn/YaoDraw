using BitBasis, StatsBase, LinearAlgebra, Plots

@recipe function user_recipe(measurements::Array{BitStr{n,Int},1}) where n
    max = (1<<n)-1
    
    hist = fit(Histogram, Int.(measurements), 0:max+1)
    hist = normalize(hist, mode=:pdf)

    seriestype := :bar
    bins := max+1
    xticks --> (0:max)
    tick_direction --> :out
    xrotation --> 45
    xformatter --> y -> "|"*string(Int(y); base=2, pad=n)*">"
    legend --> :none

    hist.edges[1] .- 0.5, hist.weights
end