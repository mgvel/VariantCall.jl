#!/usr/bin/env julia

sizef = ARGS[1]
chrf  = ARGS[2]

include("../src/read.jl")

function sizes(sizef)
    sizes = readlines(open(sizef))
    sizeD = Dict{ASCIIString,Int64}()
    for size in sizes
        cols = split(size, '\t')
        sizeD[cols[1]] = parse(Int64, chomp(cols[2]))
    end
    return sizeD
end


function chrArray(sizef, chrf)
    sizeD = sizes(sizef)
    lines = read(chrf)
    data = lines[2:end]
    names = split(lines[1])[5:end]
    chr  = split(lines[end])[1]
    array = "chr" *  chr
    array = zeros(sizeD[chr])
    return array, names, data

end

array, samples, data = chrArray(sizef, chrf)
println(length(samples), length(split(data[1])[5:end]))

matrix = Array{Int}(length(array), length(samples))

for pos in array[1:10]
    sample = []
    for del in split(data[1])[5:end]
        alts = parse(Int64, split(del, ':')[1])
        if alts >= 2                               # Number of alternative reads
            push!(sample, 1)
        else
            push!(sample, 0)
        end
    end
    matrix[pos] = sample
end
println(ndims(matrix))

#=
println(length(samples))
println(chr)
=#
