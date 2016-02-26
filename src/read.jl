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
