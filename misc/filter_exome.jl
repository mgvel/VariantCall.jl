#!/usr/bin/env julia

# Remove variants from exonic (coding) region of the genome

using GZip
using DataFrames

wigf = ARGS[1]   # chr*.wig
bedf = ARGS[2]   # Exome_region.bed

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
function readwig(fh)
    pos = []
    lines = read(fh)
    header = lines[1:2]
    lines  = lines[3:end]
    chr = split(chomp(header[2]), '=')
    for line in lines
        cols = split(line, '\t')
        out = chr[2] * ":" * cols[1]
        push!(pos, out)
    end
    unique(pos)
    return header, pos
end

function readBED(bed_file, chr::AbstractString=chr)
    pos = []
    bed = read(bed_file)
    #println(chr, "+++++++++")
    for line in bed#[218670:218690]
        bed = split(line, '\t')
        chrm = replace(bed[1], "chr", "")
        #println(chrm, "********")
        if chrm == chr
            start, last = bed[2], bed[3]
            chroms = "$chrm" * ":" * "$start" * "-" * "$last"
            region = expand(chroms)
            append!(pos, region)
        end
    end
    pos = unique(pos)
    return pos
end

header, ln = readwig(wigf)
bed = readBED(bedf, "Y")

com = intersect(ln, bed)
println(length(ln), '\t', length(bed), '\t', length(com))

#=
for i = ln[1:20], j = bed[1:20]
    println(i, '\t', j)
end
=#
