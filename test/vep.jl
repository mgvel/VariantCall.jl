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

function expand(locci)
    for g in locci
        if ismatch(r"-", g)
            pos = split(locci, ':')
            region = split(pos[2], '-')
            n = parse(Int64, region[1])

            while n <= parse(Int64, region[end])
                println(pos[1], ':', n)
                n +=  1
            end
        else
            println(g)
        end
    end
end

#=
for g in gl[1:50]
    if ismatch(r"-", g)
        expand(g)
    else
        println(g)
    end
end
=#
