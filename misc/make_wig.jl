#!/usr/bin/env julia


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


function readwig(fh)
    pos = []
    lines = read(fh)
    header = lines[1:2]
    lines  = lines[3:end]
    chr = split(chomp(header[2]), '=')
    for line in lines
        cols = split(line)
        out = chr[2] * ":" * cols[1]
        push!(pos, out)
    end
    chr = chr[2]
    unique(pos)
    return chr, header, pos
end
