#!/usr/bin/env julia

dirs = readdir(pwd())

function getPosition(img_name)
	name = img_name
	name = replace(name, ".png", "")
	part = split(name, '\_')
	chr = replace(part[1], "chr", "")
	start = parse(Int, replace(part[2], ",", ""))
	pos = range(start, 1, 40)[21]
	out = "$chr" * ":" * "$pos" 
	return out
end

for dir in dirs
	imgs = readdir(dir)
	for img in imgs
		out = getPosition(img)
		println(out)
	end
end
