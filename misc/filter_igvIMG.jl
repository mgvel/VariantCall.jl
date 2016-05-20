#!/usr/bin/env julia

pnglist = filter!(r"\.png", readdir())

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

function getSNPs(pnglist=pnglist)
	snps = []
	for img in pnglist
		img = replace(img, ".png", "")
		parts = split(img, '\_')
		chr = replace(parts[1], "chr", "")
		start = parse(Int, replace(parts[2], ",", ""))
		endp  = parse(Int, replace(parts[3], ",", ""))
		pos = "$chr" * ":" * "$start" * "-" * "$endp"
		vars = expand(pos)
		append!(snps, vars)
	end
	snps = unique(snps)
	for snp in snps
		println(snp)
	end
end

getSNPs()
