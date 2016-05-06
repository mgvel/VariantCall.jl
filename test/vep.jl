#!/usr/bin/env julia

f1 = ARGS[1]
f2 = ARGS[2]

"""
Expanding the dashed intervals into single nucleotide positions
example:
Y:2688071-2688075 =>
                    Y:2688071
                    Y:2688072
                    Y:2688073
                    Y:2688074
                    Y:2688075
"""
function expand(locci)
    list = []
    pos = split(locci, ':')
        chr = pos[1]
        region = split(pos[2], '-')
        n = parse(Int64, region[1])
        while n <= parse(Int64, region[end])
             out = "$chr" * ":" * "$n"
            push!(list, out)
            n +=  1
        end
    return list
end

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

    list = []
    for g in locci
        if ismatch(r"-", g)
            test = expand(g)
            for i in test
                push!(list, i)
            end
        else
            push!(list, g)
        end
    end
    return list
end

gl = readVEP(f1)
sm = readVEP(f2)

glOnly = setdiff(Set(gl), Set(sm))

"""
smOnly contains only variants excluding the common variants found in germline
"""
smOnly = setdiff(Set(sm), Set(gl))

common = intersect(Set(gl), Set(sm))
smf = open(f2)
lines = readlines(smf)
"""
fetching the variant position based annoation for the filtered
somatic variants
"""
for g in smOnly
    for line in lines
        if ismatch(r"^#", line)
            continue
        else
            cols = split(line, '\t')
            if g == cols[2]
                println(chomp(line))
            elseif ismatch(r"-", cols[2])
                pos = expand(cols[2])
                for item in pos
                    if g == item
                        println(chomp(line))
                    end
                end
            end
        end
    end
end
