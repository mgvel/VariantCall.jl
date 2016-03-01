#!/usr/bin/env julia

inp = ARGS[1] # example input /proj/tay6575/tcga_gbm/filtered_vcf/vep/chrY.ncv
lines = readlines(open(inp))

types = []
for ln in lines
	cols  = split(ln, "|")
	if ismatch(r"&", cols[2])
		names = split(cols[2], "\&")
		append!(types, names)
	else
		push!(types, cols[2])
	end
end

list = []

for name in (types)
	push!(list, chomp(name))
end
typecounts = Dict{ASCIIString,Int64}()

for word in list
	typecounts[word]=get(typecounts, word, 0) + 1
end

for ln in unique(list)
	println("$ln", "\t", typecounts["$ln"])
end
