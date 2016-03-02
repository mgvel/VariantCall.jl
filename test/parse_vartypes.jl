#!/usr/bin/env julia

# Complete @ Wed Mar 2 15:50:53 EET 2016
# Program from parsing Ensembl gene ids for matching variant types
# 13 variant types from test/variant_types.txt and
# test/chr*.vep files are used as input

# Reading 13 variant types
function getlist(fh = ARGS[1])
    list = readlines(open(fh))
    return list
end

# Reading all the lines from inut .vep files
function reads(files = ARGS[2:end])
    lines = []
    for file in files
        println("Reading file ... $file")
        fh = open(file)
        line = readlines(fh)
        append!(lines, line)
        close(fh)
    end
    return lines
end

# Parsing the matching types from vep files
# and writing into corresponding  .gnid files
function parse(list, lines)
    for var in list
        genid = []
        var = chomp(var)
        outname = "$var.gnid"
        outf = open(outname, "w")
        for line in lines
            if ismatch(r"^#", line)
                print()
            else
                cols = split(line, '\t')
                if contains(cols[7], var)
                    gene = cols[4]*"\n"
                    push!(genid, gene)
                end
            end
        end
        genid = unique(genid)
        println("writing .... $outf")
        write(outf, genid, "\n")
    end
end

list  = getlist()
lines = reads()
parse(list, lines)
