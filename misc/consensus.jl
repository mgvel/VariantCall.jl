#!/usr/bin/env julia

"""
Consensus checking for variant positions across samples
"""
file = ARGS[1] # .vcf/.vcf.gz file
include("../src/read.jl")

vcf = read(file)
header = []
names = split(vcf[1])[5:end]  # assumes the first line as header
push!(header, "Position")
push!(header, "Consensus")
append!(header, names)

for col in header
	print(col, '\t')
end
println()

for line in vcf[2:end]
	arr =[]
	cols = split(line)
	print(cols[2], '\t')
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
	@printf("%6.3f", consensus)
	for i in alts
		print('\t', i)
	end
	println()
end
