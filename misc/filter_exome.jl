#!/usr/bin/env julia

# Remove variants from exonic (coding) region of the genome

using GZip

function read(file)
    if ismatch(r".gz$", file)   # Gzipped .gz files
		f = GZip.open(file)
		lines = readlines(f)
		close(f)
    else   # Gzipped .vcf files
		f = open(file)
		lines = readlines(f)
		close(f)
	end
	return lines
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
    lines = read(bed_file)
end

header, ln = readwig()
bed = readBED()

println(length(ln))
println(length(bed))

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
