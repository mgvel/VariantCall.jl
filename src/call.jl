#!/usr/bin/env julia

function sam(genome_path, bam_paths...; alt_reads=3, alt_frac=0.1,
	min_mapq=10, region="", max_depth=1_000_000)
	lines = []
	genome_path = expanduser(genome_path)
	bam_paths = map(expanduser, bam_paths)

	samples = map(s -> replace(s, r".bam$", ""), bam_paths)
	S = length(samples)
	println("CHROM\tPOSITION\tREF\tALT\t", join(samples, '\t'))

	#spileup = expanduser("~/tools/pypette/compiled/spileup")
	spileup = expanduser("/home/gnanavel/Work/spileup")
	mpileup_options = ""
	if region != ""; mpileup_options = "-r$(region)"; end

	max_alleles = 100
	push!(lines, pipeline(`samtools mpileup -d $(max_depth) -A -x -R -sB -q0 $(mpileup_options) -f $(genome_path) $(bam_paths)`, `$(spileup) $(alt_reads) $(min_mapq)`))

	return lines
end

function format(lines)
	for line in lines
		cols = split(rstrip(line), '\t')
		assert(length(cols) >= 3)
		if cols[3] == "N"; continue; end

		total_reads = zeros(Int32, length(samples))
		allele_reads = zeros(Int32, length(samples), max_alleles)
		alleles = Array{ASCIIString}(0)

		for (s, pileup) in enumerate(cols[4:end])
			if pileup == ""; continue; end
			t = split(pileup, ' ')
			for a in 1:3:length(t)
				count = int(t[a+1])
				total_reads[s] += count
				if t[a] == "."; continue; end
				idx = findfirst(allele -> allele == t[a], alleles)
				if idx == 0 && length(alleles) >= max_alleles; continue; end
				if idx == 0; push!(alleles, t[a]); idx = length(alleles); end
				allele_reads[s, idx] = count
			end
		end

		for a in 1:length(alleles)
			frac = allele_reads[:, a] ./ total_reads
			alt_gt = (allele_reads[:, a] .>= alt_reads) & (frac .>= alt_frac)
			if !any(alt_gt); continue; end

			# Reformat indels in VCF4 format
			ref = cols[3]; alt = alleles[a]
			if length(alt) >= 2
				if alt[2] == '+'    # Insertion
					alt = string(alt[1] == '.' ? ref : alt[1], alt[3:end])
				elseif alt[2] == '-'  # Deletion
					ref = string(ref, alt[3:end])
					alt = alt[1] == '.' ? ref[1] : alt[1]
				end
			end

			print("$(cols[1])\t$(cols[2])\t$(uppercase(ref))\t$(uppercase(alt))")
			for s in 1:length(samples)
				print("\t$(allele_reads[s, a]):$(total_reads[s])")
				if alt_gt[s]; print(":*"); end
			end
			println()
		end
	end
end

function call(genome_path, bam_paths...; alt_reads=3, alt_frac=0.1,
	min_mapq=10, region="", max_depth=1_000_000)

	genome_path = expanduser(genome_path)
	bam_paths = map(expanduser, bam_paths)

	samples = map(s -> replace(s, r".bam$", ""), bam_paths)
	S = length(samples)
	println("CHROM\tPOSITION\tREF\tALT\t", join(samples, '\t'))

	#spileup = expanduser("~/tools/pypette/compiled/spileup")
	spileup = expanduser("/home/gnanavel/Work/spileup")
	mpileup_options = ""
	if region != ""; mpileup_options = "-r$(region)"; end

	max_alleles = 100
	for line in eachline(pipeline(`samtools mpileup -d $(max_depth) -A -x -R -sB -q0 $(mpileup_options) -f $(genome_path) $(bam_paths)`, `$(spileup) $(alt_reads) $(min_mapq)`))
		cols = split(rstrip(line), '\t')
		assert(length(cols) >= 3)
		if cols[3] == "N"; continue; end

		total_reads = zeros(Int32, length(samples))
		allele_reads = zeros(Int32, length(samples), max_alleles)
		alleles = Array{ASCIIString}(0)

		for (s, pileup) in enumerate(cols[4:end])
			if pileup == ""; continue; end
			t = split(pileup, ' ')
			for a in 1:3:length(t)
				count = int(t[a+1])
				total_reads[s] += count
				if t[a] == "."; continue; end
				idx = findfirst(allele -> allele == t[a], alleles)
				if idx == 0 && length(alleles) >= max_alleles; continue; end
				if idx == 0; push!(alleles, t[a]); idx = length(alleles); end
				allele_reads[s, idx] = count
			end
		end

		for a in 1:length(alleles)
			frac = allele_reads[:, a] ./ total_reads
			alt_gt = (allele_reads[:, a] .>= alt_reads) & (frac .>= alt_frac)
			if !any(alt_gt); continue; end

			# Reformat indels in VCF4 format
			ref = cols[3]; alt = alleles[a]
			if length(alt) >= 2
				if alt[2] == '+'    # Insertion
					alt = string(alt[1] == '.' ? ref : alt[1], alt[3:end])
				elseif alt[2] == '-'  # Deletion
					ref = string(ref, alt[3:end])
					alt = alt[1] == '.' ? ref[1] : alt[1]
				end
			end

			print("$(cols[1])\t$(cols[2])\t$(uppercase(ref))\t$(uppercase(alt))")
			for s in 1:length(samples)
				print("\t$(allele_reads[s, a]):$(total_reads[s])")
				if alt_gt[s]; print(":*"); end
			end
			println()
		end
	end
end
