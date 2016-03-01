#!/usr/bin/env julia

using GZip

# Function for reading input .vcf file
function read(file)
	if ismatch(r".vcf$", file)   	# Normal .vcf files
		f = open(file)
		lines = readlines(f)
		close(f)
	elseif ismatch(r".gz$", file)   # Gzipped .vcf files
		f = GZip.open(file)
		lines = readlines(f)
		close(f)
	end
	return lines
end
