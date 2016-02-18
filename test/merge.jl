#!/usr/bin/env julia

using GZip
function read(file)
	if ismatch(r".vcf$", file)
		f = open(file)
		lines = readlines(f)
		close(f)
	elseif ismatch(r".gz$", file)
		f = GZip.open(file)
		lines = readlines(f)
		close(f)
	end
	return lines
end

function merge(paths = ARGS[1:end])
	headers = []
	samples = []
	for fl in paths
		println("Merging ... ...\t", basename(fl))
		vcf = read(fl)
		for line in vcf
			if ismatch(r"^#", line)
				push!(headers, line)
			else
				push!(samples, line)
			end
		end
	end
	return samples
end

println(sizeof(merge()))

