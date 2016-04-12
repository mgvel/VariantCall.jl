#!/usr/bin/env julia

using GZip

include("read.jl")

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

out = index()
for i in out
    println(i)
end

function coding()
end

#=
function nonCoding()
end
=#
