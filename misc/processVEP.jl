#!/usr/bin/env julia

vepf = ARGS[1] #  combined.vep

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

function conseq(fh=vepf)
    conseq = []
    file  = open(fh)
    lines = readlines(file)
    for line in lines
        if ismatch(r"^#", line)
            continue
        else
            cols = split(line, '\t')
            if ismatch(r",", cols[7])
                ids = split(cols[7], ',')
                append!(conseq, ids)
            else
                push!(conseq, cols[7])
            end
        end
    end
    conseq = unique(conseq)
end

function parseConseq(vepf=vepf, cons=conseq())
    file  = open(vepf)
    lines = readlines(file)
    for con in cons
        name = con * ".snp"
        open(name, "w")
        con_snp = []
        for line in lines
            if contains(line, con)
                cols = split(line)
                if contains(cols[2], "-")
                    list = expand(cols[2])
                    append!(con_snp, list)
                else
                    push!(con_snp, cols[2])
                end
            end
        end
        writedlm(name, unique(con_snp))
        println(con, '\t', length(unique(con_snp)))
    end
end

parseConseq()
