#!/usr/bin/env julia

# FIXME I AM VERY SLOW

include("read.jl")

function extract(paths = ARGS[1:end])
	headers = []
	samples = []
	for fl in paths
		println("Extracting ... ... ... ", basename(fl))
		vcf = read(fl)
		for line in vcf
			if ismatch(r"^#|CHROM", line)
				push!(headers, line)
			else
				push!(samples, line)
			end
		end
	end
	return headers, samples
end

function merge_names(headers)
	def = []
	sampl = []
	for entry in headers
		line  = split(entry, "\t")
		push!(def, line[1:4])
		push!(sampl,line[5:end])
	end
	def = unique(def)
	sampl = unique(sampl)
	names = (def, sampl)
	return names
end

function merge_vcf(samples)
	out = []
	def = []
	for entry in samples
		line  = split(entry, "\t")
		push!(def, line[1:4])
		end
	def = unique(def)

	 for item in def
		push!(out, item)
		for ln in samples
			cols = split(ln, "\t")
			if item == cols[1:4]
				push!(out, cols[5:end])
			end
		end
		push!(out, "\n")
	end
	return out
end

headers, samples = extract()
head = merge_names(headers)
data = merge_vcf(samples)

println(head)
ln = 1
while ln <=lenght(data)
	println(data[ln])
	ln += 1
end
