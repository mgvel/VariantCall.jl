#!/usr/bin/env julia

"""
This program generates batch sricpt to run IGV
Loads BAM files from localhost tunnel
Reads Variant positions from WIG file for each chromosome
"""

fh = ARGS[1] #      File with list of .wig file names
file = open(fh)
wig = readlines(file)

fP = ARGS[2] # GBM-pairs.txt
fil2 = open(fP)
bamList = readlines(fil2)

here = pwd() # presently working directory

for line in bamList[1:5]
    out = []
    target = chomp(line)
    bam = split(target, ',')
    tumor, normal = bam[1], bam[2]
    rm("$here/PNG/$target", recursive=true)
    mkdir("$here/PNG/$target")  # Creating snapshot directory
    push!(out, "new")
    push!(out, "genome hg19")
    push!(out, "load http://localhost:8000/bam/$tumor.bam,$here/somatic.wig,$here/germline.wig.tdf,http://localhost:8000/bam/$normal.bam")
    push!(out, "maxPanelHeight 1000")
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
