#!/usr/bin/env julia

using DataFrames

function read(files=ARGS[1:end])

    for file in files
        name = split(file, "\/")
        ch   = split(name[2], ".")
        chr  = ch[1]
        println("Reading ... $file for chromosome $chr")
        lines = readlines(open(file))

        typ = []
        val = []
        for line in lines
            cols = split(line, "\t")
            push!(typ, cols[1])
            push!(val, cols[2])
        end
        ptable = DataFrame()
        for t in typ, c in val
            push!(ptable, @data(t, c))
        end
        println(length(chr), "\t", chr, "\t", length(typ), "\t", length(val))
        #=
        ptable = DataFrame(chromosome = @data(chr),
                          vartype     = @data(typ),
                         varcount     = @data(val)
                  )
        =#
    end
end
read()
