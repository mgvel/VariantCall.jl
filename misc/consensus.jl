#!/usr/bin/env julia

"""
Consensus checking for variant positions
"""
include("../src/read.jl")

file = ARGS[1]
vcf = read(file)
names = split(vcf[1])[5:end]
header = "Position" * " Consensus" * "$names"
println(header)

for line in vcf[2:end]
	arr =[]
	cols = split(line)
	print(cols[2], '\t')
	#push!(arr, cols[2])
	alts = []
	for sample in cols[5:end]
		altRead = parse(Int64, split(sample, ':')[1])
		if altRead >= 3
			push!(alts, 1)
		else
			push!(alts, 0)
		end
	end
	consensus = (sum(alts)/length(alts))*100
	print(consensus, "% \t")
	#append!(arr, alts)
	for i in alts
		print(i, '\t')
	end
	println()
end

