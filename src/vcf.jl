#!/usr/bin/env julia

using GZip

# Function for reading input file
function read(file)
	if ismatch(r".vcf$", file)
		f = open(file)
		lines = readlines(f)
		println("Successfully read $file file!")
		close(f)
	elseif ismatch(r".gz$", file)
		f = GZip.open(file)
		lines = readlines(f)
		println("Successfully read archived $file file!")
		close(f)
	end
	return lines
end

# For checking the input chromosome arguement
function CheckChrmosome(chr)
	match = 0
	possible = ["X"; "Y"; range(1,22)]
	for chrom in possible
		if string(chrom) == chr
			match += 1
		end
	end
	return match
end

# Function to extract only the vcf record containing lines
function records(file)
	lines = read(file)
	record = []
	for ln in lines
		if ismatch(r"^[\d]|X|Y", ln)
			push!(record, "$ln")
		end
	end
	return record
end

# Function for extracting the header lines
function header(lines)
	head = []
	for ln in lines
		if ismatch(r"^#", ln)
			push!(head, "$ln\n")
		end
	end
	if sizeof(head) >= 1
		return head
	else
		print("Header information not found in the input .vcf file!\n")
	end
end

# Function for getting Variant Call Format version information
function version(lines)
	headers = header(lines)
	if sizeof(headers) < 1
		print("Header information not found in the input .vcf file!\n")
	elseif ismatch(r"=VCF", headers[1]) && sizeof(headers) >= 1
		head = headers[1]
		ln = split(head, "=")
		version = ln[2]
		return version
	else
		print("Version information not found in the input .vcf file!\n")
	end
end

# Function for extracting INFO provided in header lines
function HeadInfos(lines)
	headers = header(lines)
	info = []
	if sizeof(headers) < 1
		print("Header information not found in the input .vcf file!\n")
	elseif sizeof(headers) >= 1
		for ln in headers
			if ismatch(r"^##INFO", ln)
				push!(info, "$ln\n")
			end
		end
		return info
	else
		print("INFO not found in the input .vcf file!\n")
	end
end

# Function for extracting start and end position of queried chromosome
function chrange(lines, chr::AbstractString=chr)
	inpt_chr = CheckChrmosome(chr)
	if inpt_chr >= 1
		pos = []
		for rec in lines
			spl = split(rec, "\t")
			if spl[1] == chr
				push!(pos, spl[2])
				#println(spl[2])
			end
		end
		chr_strt = parse(Int, pos[1])
		chr_end   = parse(Int, pos[end])
		return chr_strt, chr_end
	else
		println("Please check the requested Chromosome name! \t *** $chr ***")
	end
end

function getchr(records)
	chrs = []
	for ln in records
		spl = split(ln, "\t")
		push!(chrs, spl[1])
	end
	list  = sort(unique(chrs))
	for ch in list
		print("$ch\n")
	end
end

# Function for extracting queried segment or entire chromosome
function fetch(records, chr::AbstractString, strt=0, stop=0)
	inpt_chr = CheckChrmosome(chr)
	if inpt_chr >= 1
		pos1 = []
		# If specific range is not asked, then entire chomosome is selected
		if strt == 0 && stop == 0
			strt, stop = chrange(records, chr)
		end

		for rec2 in records
			spl2 = split(rec2, "\t")
			if spl2[1] == chr
				push!(pos1, spl2[2])
		#		println(spl2[2])
			end
		end

		pos_strt = parse(Int, pos1[1])
		pos_end   = parse(Int, pos1[end])

		for rec3 in records
			spl3 = split(rec3, "\t")
			cur_pos = parse(Int, spl3[2])
			region  = spl3[1]

			if (strt < pos_strt && stop > pos_end)|| strt < pos_strt || stop > pos_end || stop < pos_strt
				println("Request out of range!")
			elseif region == chr && strt <= cur_pos <= stop
				print(rec3)
			end
		end


	else
		println("Please check the requested Chromosome name! \t *** $chr ***")
	end
end

# Get unique pair of alteration records REF => ALT
function alts(records)
	alt = []
	for line in records
		tmp = split(line, "\t")
		# if ID column present
		if ismatch(r"[\d]", tmp[3])
			#tmp[4] => REF ; $tmp[5] => ALT
			pair = tmp[4] *" => " * tmp[5]
			push!(alt, pair)
		else
			#tmp[3] => REF ; $tmp[4] => ALT
			pair = tmp[3] *" => " * tmp[4]
			push!(alt, pair)
		end
	end
	alt = unique(alt)
	return alt
end

# Get unique list of alteration (ALT) types
function uniqalts(records)
	alt = []
	for line in records
		tmp = split(line, "\t")
		# if ID column present
		if ismatch(r"[\d]", tmp[3])
			#$tmp[5] => ALT
			push!(alt, tmp[5])
		else
			#$tmp[4] => ALT
			push!(alt, tmp[4])
		end
	end
	alt = unique(alt)
	return alt
end

# INFO Fixed field from input VCF file
function info(records)
	info = []
	for line in records
		tmp = split(line, "\t")
		#tmp[5] => ALT
		push!(info, tmp[8])
	end
	info = unique(info)
	return info
end

# AA : ancestral allele
function infoAA(records)
	inf = info(records)
	aa = []
	for line in inf
		tmp = split(line, ";")
		for col in tmp
			#tmp[end] => AA
			if ismatch(r"AA=", col)
				push!(aa, col)
			end
		end
	end
	return aa
end

# 1000G : membership in 1000 Genomes
function E1000G(records)
	tg = []
	for line in records
		if ismatch(r"E_1000G", line)
			push!(tg, line)
		end
	end
	return tg
end

function merge(vcfiles)


end
#=
def variant_merge(vcf_paths):
 481         sort_in, sort_out = shell_stdinout('sort -k2,2 -k3,3n -k4,4 -k5,5')
 482         cons_headers = []    # Consensus headers
 483         vcf_samples = []     # Sample names of each VCF
 484         for vcf_index, vcf_path in enumerate(vcf_paths):
 485                 info('Merging VCF file %s...' % vcf_path)
 486                 vcf = zopen(vcf_path)
 487                 for line in vcf:
 488                         if not line.startswith('#'): break
 489                 headers = line.rstrip('\n').split('\t')
 490                 gtype_col = (4 if not 'ESP6500' in headers else
 491                         headers.index('ESP6500') + 1)
 492                 if not cons_headers: cons_headers = headers[:gtype_col]
 493                 if cons_headers != headers[:gtype_col]: error('Header mismatch!')
 494                 vcf_samples.append(headers[gtype_col:])
 495                 for line in vcf:
 496                         sort_in.write('%d\t%s' % (vcf_index, line))
 497         sort_in.close()
 498
 499         print('\t'.join(cons_headers + sum(vcf_samples, [])))
 500         vcf_sample_counts = [len(samples) for samples in vcf_samples]
 501         S = sum(vcf_sample_counts)
 502         vcf_sample_col = [sum(vcf_sample_counts[0:k])
 503                 for k in range(len(vcf_samples))]
 504
 505         info('Merged VCF will contain:')
 506         info('- %d header columns' % len(cons_headers))
 507         for samples, path in zip(vcf_samples, vcf_paths):
 508                 info('- %d columns from %s' % (len(samples), path))
 509
 510         prev = None
 511         calls = [':0:0'] * S
 512         for line in sort_out:
 513                 cols = line.rstrip('\n').split('\t')
 514                 vcf_index = int(cols[0])
 515                 call_col = vcf_sample_col[vcf_index]
 516                 if prev != cols[1:5]:
 517                         if prev != None:
 518                                 print('\t'.join(prev + calls))
 519                         prev = cols[1:gtype_col+1]
 520                         calls = [':0:0'] * S
 521                 calls[call_col:call_col+vcf_sample_counts[vcf_index]] = \
 522                         cols[gtype_col+1:]
 523
 524         print('\t'.join(prev + calls))    # Handle the last line

#function contigs
#function filters
#function formats
#function metadata
=#
