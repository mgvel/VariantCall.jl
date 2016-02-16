#!/usr/bin/env julia

import GZip

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
function infos(lines)
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
	pos = []
	for rec in lines
		spl = split(rec, "\t")
		if spl[1] == chr
			push!(pos, spl[2])
			#println(spl[2])
		end
	end
	chr_start = parse(Int, pos[1])
	chr_end   = parse(Int, pos[end])
	return chr_start, chr_end
end

function getchr(records)
	chrs = []
	for ln in records
		spl = split(ln, "\t")
		push!(chrs, spl[1])
	end
	list  = unique(chrs)
	return list
end

# Function for extracting queried segment or full chromosome
function fetch(records, chr::AbstractString, start=0, stop=0)
	pos1 = []
	
	# If specific range is not asked entire chomosome is selected as range
	if start == 0 && stop == 0
		start, stop = chrange(records, chr)
	end
	
	for rec2 in records
		spl2 = split(rec2, "\t")
		if spl2[1] == chr	
			push!(pos1, spl2[2])
		#	println(spl2[2])
		end
	end

	pos_start = parse(Int, pos1[1])
	pos_end   = parse(Int, pos1[end])

	for rec3 in records
		spl3 = split(rec3, "\t")
		cur_pos = parse(Int, spl3[2])
		region  = spl3[1]
			
		if (start < pos_start && stop > pos_end)|| start < pos_start || stop > pos_end || stop < pos_start
			println("Request out of range!")
		elseif region == chr && start <= cur_pos <= stop
			print(rec3)
		end
	end	
end
#=
#function alts(lines)
#function contigs

#function filters
#function formats
#function metadata
=#