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
    names = split(lines[1])[5:end]
    chr  = split(lines[end])[1]
    array = "chr" *  chr
    array = zeros(sizeD[chr])
    return array

end
array = chrArray(sizef, chrf)
println(length(array))

for v in array[1:10]
    println(v)
end

#=
println(length(samples))
println(chr)
=#
