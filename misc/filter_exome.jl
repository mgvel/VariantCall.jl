#!/usr/bin/env julia

# Remove variants from exonic (coding)/masked low resolution mapping regions of the genome

using GZip

wigf = ARGS[1]   # .wig file
bedf = ARGS[2]   # .bed file

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
    chr = chr[2]
    unique(pos)
    return chr, header, pos
end

function readBED(bed_file, chr::AbstractString=chr)
    pos = []
    bed = read(bed_file)
    for line in bed[5265:5999]
        bed = split(line, '\t')
        chrm = replace(bed[1], "chr", "")
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


function printWIG(wigf, bedf)
    chr, header, ln = readwig(wigf)
    bed = readBED(bedf, chr)
    ncDNA = setdiff(Set(ln), Set(bed))

    for line in header
        println(chomp(line))
    end

   for i in ncDNA
       pattern = chr * ":"
       println(replace(i, pattern, ""), ' ',"1 ++++++")
   end
end

printWIG(wigf, bedf)
