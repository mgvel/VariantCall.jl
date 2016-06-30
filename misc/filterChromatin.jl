#!/usr/bin/env julia

variants =   ARGS[1]
bed = ARGS[2] 

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

function getchr(variant)
    chr = split(variant, ':')[1]
	return chr
end

function readBED(bed_file, chr)
    pos = []
    bed = read(bed_file)
    for line in bed
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

function checkChromatin(variant, chromatin)
	parts  = split(chomp(variant), ':')
	chromatinPos = readBED(chromatin, parts[1])
	
    out = 0
	for pos in chromatinPos
       #println(typeof(variant), '\t', variant, typeof(pos), '\t', pos)
       cols = split(pos, ':') 
        if (parts[1] == cols[1]) && (parts[2] == cols[2])
          out += 1
        end
    end
	return out
end

function filterChromatin(variants, bed)
	lines = read(variants)
	for line in lines
	    variant = chomp(line)
		openChrommatin = checkChromatin(variant, bed)
		if openChrommatin >= 1
            print(line)
        else
			continue
		end
	end
end

filterChromatin(variants, bed)
