#!/usr/bin/env julia

pnglist = readdir()

println(length(pnglist))

for i in pnglist
	println(i)
end
