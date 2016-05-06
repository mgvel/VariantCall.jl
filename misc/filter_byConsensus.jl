#!/usr/bin/env julia

cons = ARGS[1] # Consensus file e.g: chr3.sm.tsv.gz
vcf  = ARGS[2] # Variant Calling file e.g: chr3.vcf.gz

include("../src/read.jl")

function readConsensus(cons)
	conslist = []
	lines = read(cons)
	header = lines[1]
	for line in lines[2:end]
		cols = split(line, '\t')
		percent = parse(Float64, cols[2])
		if percent >= 10
			push!(conslist, cols[1])
		end
	end
	return conslist
end

conslist = readConsensus(cons)

function readVCF(vcf_path, conslist)
	lines = read(vcf_path)
	for pos = conslist[1:end], line = lines[2:end]
		#pos = parse(Int, pos)
		snp = parse(Int, split(line, '\t')[2])
		
		if pos == snp
			println(line)
		end
	end
end

readVCF(vcf, conslist)

#println(length(conse))


