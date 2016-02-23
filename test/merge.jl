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

function merge(headers, samples)


end

id, data = extract()
println(length(id), "\t", length(data))

ln = 1
while ln <= length(id)
	println(id[ln] * " +++++++++ ")
	ln += 1
end

#=
ln  = 1
while ln <= sizeof(id)
		println(id[ln])
		ln += 1
end
=#
