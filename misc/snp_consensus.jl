#!/usr/bin/env julia

sizef = ARGS[1]
chrf  = ARGS[2]

include("../src/read.jl")

size = open(sizef)
sizes = readlines(size)

chrom = length = []
for size in sizes
    cols = split(size)
    push!(chrom, cols[1])
    push!(chrom, cols[2])
end

sizes = Dict{ASCIIString,Int64}()

lines = read(chrf)

samples = split(lines[1])[5:end]
chr =   split(lines[end])[1]

println(length(samples))
println(chr)
