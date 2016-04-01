#!/usr/bin/env julia

include("read.jl")

"""
For checking the input chromosome arguement
"""
function CheckChrmosome(chr)
	match = 0
	possible = ["X"; "Y"; "M"; range(1,22)]
	for chrom in possible
		if string(chrom) == chr
			match += 1
		end
	end
	return match
end

"""
Function to extract only the vcf record containing lines
"""
function records(file)
	lines = read(file)
	record = []
	for ln in lines
		if ismatch(r"^[\d]|X|Y|M", ln)
			push!(record, "$ln")
		end
	end
	return record
end

"""
Function for extracting the header lines
"""
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

"""
Function for getting Variant Call Format version information
"""
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

"""
Function for extracting INFO provided in header lines
"""
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

"""
Function for extracting start and end position of queried chromosome
"""
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

"""
Function for extracting queried segment or entire chromosome
"""
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

"""
Get unique pair of alteration records REF => ALT
"""
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

"""
Get unique list of alteration (ALT) types
"""
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

"""
INFO Fixed field from input VCF file
"""
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

"""
AA : ancestral allele
"""
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

"""
1000G : membership in 1000 Genomes
"""
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

#function contigs
#function filters
#function formats
#function metadata
=#
