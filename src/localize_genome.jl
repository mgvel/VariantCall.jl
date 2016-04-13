#!/usr/bin/env julia
# Minimal annotation about the genomic postion
# Try to classifiy genomic position at single neucleotide resolution
# Using EnsEMBL vep libraries

using GZip

include("read.jl")

"""
Read entire chromosome from input file and return the lines
"""
function readchr(fh=ARGS[1])
    if ismatch(r".gz$", fh)
        f = GZip.open(fh)
        lines = readlines(f)
    else
        f = open(fh)
        lines = readlines(fh)
    end
    return lines
end

function index(lines=readchr())
    pos = []
    #lines = readchr()
    for line in lines
        cols = split(line, "\t")
        push!(pos, cols[2])
    end
    return pos
end

"""
out = index()
for i in out
    println(i)
end

function coding()
end
"""
test = readchr()
for i in test
    chomp(i)
    println(i)
end

#=
function nonCoding()
end
=#
