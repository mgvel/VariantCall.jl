#!/usr/bin/env julia

fh = ARGS[1]
file = open(fh)
wig = readlines(file)

path = "http://localhost:8000/bam/"
list = readall(pipeline(`curl $path`, `awk '/.bam$/ {print $NF}'`))
bamList = split(list, '\n')

#println(length(bamList)-1, " BAM files found!")
#println(typeof(wig))

for bam in bamList[1:10]
    out = []
    push!(out, "new")
    push!(out, "genome hg19")
    push!(out, "load http://localhost:8000/bam/$bam")
    push!(out, "snapshotDirectory /home/gnanavel/Work/GBM_NCV-Roadmap/Data/TCGA/mutations/PNG/")
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
    writedlm("$bam.txt", out)
end

#=
    println("new
genome hg19
load http://localhost:8000/bam/$i
snapshotDirectory /home/gnanavel/Work/GBM_NCV-Roadmap/Data/TCGA/mutations/PNG
goto chr18:27,984,924-27,984,924
sort position
snapshot")
end
=#
