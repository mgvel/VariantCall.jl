#!/usr/bin/env julia

include("../src/read.jl")

vcf  = ARGS[1] # Variant Calling file e.g: chr3.vcf.gz

"""
Computing consensus fo variants with at least 3 reads
"""

function consensus(vcf_line)
	cols = split(vcf_line)
	alts = []
	for sample in cols[5:end]
		altRead = parse(Int64, split(sample, ':')[1])
		if altRead >= 10
			push!(alts, 1)
		else
			push!(alts, 0)
		end
	end
	consensus = (sum(alts)/length(alts))*100
end

"""
Filtering each position from input vcf with the consensus
value of 10% and returning filtered variants in .vcf format
"""
function filterVCF(vcf_path)
	lines = read(vcf_path)
	println(chomp(lines[1]))
	for line = lines[2:end]
		cons = consensus(line)
		# minimum 3 reads having mutation in at least 10% of thae samples
		if cons >= 10
			print(line)
		end
	end
end

filterVCF(vcf)
