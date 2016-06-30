#!/usr/bin/env julia

using GZip

chromatinf = ARGS[1] # open chromatin file e.g: wgEncodeDukeDnaseGliobla.fdr01peaks.hg19.bed
vcf  = ARGS[2] # Variant Calling file e.g: chr3.vcf.gz

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
            #out = "$chr" * ":" * "$n"
            push!(list, n)
            n +=  1
        end
    return list
end

function getchr(records=read(vcf))
    chr = split(records[5], '\t')[1]
	return chr
end

function readBED(bed_file, chr::AbstractString=getchr())
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

function checkChromatin(vcf_line, chromatin=chromatinf)
    chromatinPos = readBED(chromatin)
    println(chromatinPos)
    snp = split(vcf_line, '\t')[2]
    out = in(snp, chromatinPos)
    return out
end

function filterChromatin(vcf_path)
	lines = read(vcf_path)
	println(chomp(lines[1]))
	for line = lines[2:end]
		openChrommatin = checkChromatin(line)
		if openChrommatin == true
            print(line)
        else
			continue
		end
	end
end

filterChromatin(vcf)
