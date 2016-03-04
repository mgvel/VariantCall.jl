#!/usr/bin/env julia

using GZip

function readchr(fh=ARGS[1])
    if ismatch(r".gz$", fh)
        f = GZip.open(fh)
        lines = readlines(fh)
        close(fh)
    else
        f = open(fh)
        lines = readlines(fh)
        close(fh)
    end
    return lines
end

#=
function index()
end

function coding()
end

function nonCoding()
end
=#
