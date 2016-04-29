#!/usr/bin/env julia

# Remove variants from exonic (coding) region of the genome

using GZip
using DataFrames

#bed = ARGS[2]   #"Exome_region.bed"

function read(file)
    if ismatch(r".gz$", file)   # Gzipped .gz files
		f = GZip.open(file)
		lines = readlines(f)
		close(f)
    else
		f = open(file)
		lines = readlines(f)
		close(f)
	end
	return lines
end

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
Read .wig file
"""
function readwig(fh=ARGS[1])
    pos = []
    lines = read(fh)
    header = lines[1:2]
    lines  = lines[3:end]
    return header, lines
end

function readBED(bed_file=ARGS[2])
    pos = []
    bed = read(bed_file)
    for line in bed
        bed = split(line, '\t')
        chr = replace(bed[1], "chr", "")
        start, last = bed[2], bed[3]
        chroms = "$chr" * ":" * "$start" * "-" * "$last"
        region = expand(chroms)
        push!(pos, region)
    end
    return pos
end

header, ln = readwig()
bed = readBED()

println(length(ln))
for i in bed[1:15]
    println(i)
end
#=
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


function nonCoding()
end
=#
