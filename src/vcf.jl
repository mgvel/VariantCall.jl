#!/usr/bin/env julia

module vcf
import GZip

# Function for reading input file
function read(vcfile)
	function lines(vcfile)
		if ismatch(r".vcf$", vcfile)
			f = open(vcfile)
			lines = readlines(f)
			close(f)
		elseif ismatch(r".gz$", vcfile)
			f = GZip.open(vcfile)
			lines = readlines(f)
			close(f)
		end
		return lines
	end
	
	# Function to extract only the vcf record containing lines
	function records(lines)
		records = []
		for ln in lines
			if ismatch(r"^[\d]|X|Y", ln)
				push!(record, "$ln")
			end
		end
		return records
	end
end

#=
# Function to extract only the vcf record containing lines
function record(lines)
	record = []
	for ln in lines
		if ismatch(r"^[\d]|X|Y", ln)
			push!(record, "$ln")
		end
	end
	return record
end
=#

# Function for getting Variant Call Format version information
function version(lines)
	#if ln 
	ln = split(lines, "=")
	version = ln[2]
	return version
end

# Function for extracting the header lines
function header(lines)
	header = []
	headlines = lines[1:100]
	for ln in headlines
		if ismatch(r"^#", ln)
			push!(header, "$ln\n")
		end
	end
	return header
end

# Function for extracting INFO provided in header lines
function infos(header)
	for ln in header
		if ismatch(r"^##INFO", ln)
			print(ln)
		end
	end
end

# Function for extracting start and end position of queried chromosome                 
function chrange(lines, chr::AbstractString=chr)
	pos = []
	for rec in records
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

lines = read.lines(inputf)
record = read.records(lines)
from, to = chrange(lines, chr)
print(from, "\t", to, "\t\n")

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
function fetch(records, chr::AbstractString=chr, start=from, stop=to)
	pos1 = []
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

#function alts(lines)
#function contigs

#function filters
#function formats
#function metadata

println(sizeof(record))
out1 = fetch(record)
print(out1)
chromosomes = getchr(record)
println(chromosomes)

#version = version(lines[1])
#header = header(lines)
#info = infos(header)
end