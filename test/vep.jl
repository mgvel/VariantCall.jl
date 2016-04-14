#!/usr/bin/env julia

f1 = ARGS[1]
f2 = ARGS[2]

"""
Reads EnsEMBL Variant Effect Predictor (VEP) Results
and returning mutation locci as a list
"""
function readVEP(fh)
    locci = []
    file  = open(fh)
    lines = readlines(file)
    for line in lines
        if ismatch(r"^#", line)
            continue
        else
            cols = split(line, '\t')
            push!(locci, cols[2])
        end
    end
    return locci
end

gl = readVEP(f1)
sm = readVEP(f2)

println(length(gl))
println(length(sm))


for g in gl[1:50]
    println(g)
end
