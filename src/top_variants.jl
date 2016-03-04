#!/usr/bin/env julia

include("read.jl")

function sort(file=ARGS[1])
    lines=read(file)
    readCounts = Dict()
    for ln in lines
        if ismatch(r"^CHROM", ln)
            print()
        else
            cols = split(ln, '\t')
            println(cols[1:5])
            positiveSamples = 0
            for col in cols[5:end]
                read = split(col, ':')[2]
                if read >= 1
                    positiveSamples += 1
                end
            end
        end
    pair = cols[1] * positiveSamples
    push!(readCounts, pair)
    end
end

test = sort()
