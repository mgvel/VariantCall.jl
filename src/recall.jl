#!/usr/bin/env julia

include("read.jl")

# Function to call variation based on given alt reads and fraction cut-off

function recall(paths = ARGS[1:end], min_alt_read::Int=2, min_alt_frac=0.05)
	for file in paths
		vcf = read(file)

		for line in vcf
			if ismatch(r"^#|CHROM", line)
				print(line)
			else
				cols = split(line, "\t")
				alt_reads  = []
				tot_reads = []
				for gt in cols[5:end]
					push!(alt_reads, parse(Int, split(gt, ':')[1]))
					push!(tot_reads, parse(Int, split(gt, ':')[2]))
				end
				gt = maximum(alt_reads)
				af = maximum(alt_reads ./ tot_reads)
				if gt >= min_alt_read && af >= min_alt_frac
					print(line)
				end
			end
		end
	end
end

recall()
