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

#matrix = Array{Int}(10, length(samples))

for (pos, value) in enumerate(array[9411207:9412000])
    alts = zeros(length(samples))
    print("pos-", pos, "\t")
    for line in data
        content = split(line)[5:end]
        site    = split(line)[2]
        if pos == site
            println(alts)
        else
            for del in content
                alts = parse(Int64, split(del, ':')[1])
                if alts >= 2                # Number of alternative    reads
                    print(1,"\t")
                else
                    print(0,"\t")
                end
            end
		println()		
        end
    end
end
