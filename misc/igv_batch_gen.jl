#!/usr/bin/env julia

"""
This program generates batch sricpt to run IGV
Loads BAM files from localhost tunnel
Reads Variant positions from WIG file for each chromosome
"""

fh = ARGS[1] #      File with list of .wig file names
file = open(fh)
wig = readlines(file)

path = "http://localhost:8000/bam/"
list = readall(pipeline(`curl $path`, `awk '/.bam$/ {print $NF}'`))
bamList = split(list, '\n') # List of BAM files in the tunnel

here = pwd() # presently working directory

for bam in bamList#[1:10]
    out = []
    target = bam[1:end-4]
    rm("$here/PNG/$target", recursive=true)
    mkdir("$here/PNG/$target")  # Creating snapshot directory
    push!(out, "new")
    push!(out, "genome hg19")
    push!(out, "load http://localhost:8000/bam/$bam,$here/somatic.wig,$here/germline.wig.tdf")
    push!(out, "snapshotDirectory $here/PNG/$target")
    for file in wig
        file = chomp(file)
        ln = open(file)
        lines = readlines(ln)
        chr = split(file, '.')
        for po in lines[3:18]
            pos = split(po, '\t')
            position = "goto "*chr[1]*":"*pos[1]*"-"*pos[1]
            push!(out, position)
            push!(out, "sort position")
            push!(out, "snapshot")
        end
    end
    push!(out, "exit")
    writedlm("$target.igv.txt", out)
end
