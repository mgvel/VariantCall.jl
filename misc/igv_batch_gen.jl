#!/usr/bin/env julia

path = "http://localhost:8000/bam/"
list = readall(pipeline(`curl $path`, `awk '/.bam$/ {print $NF}'`))

fH = ARGS[1]
wig = split(readall(fH), '\n')

bamList = split(list, '\n')

println(length(bamList)-1, " BAM files found!")
println(length(wig))

for i in bamList[1:end-1]
    println("new")
    println("genome hg19")
    println("load http://localhost:8000/bam/$i")
    println("snapshotDirectory /home/gnanavel/Work/GBM_NCV-Roadmap/Data/TCGA/mutations/PNG/$i")
    for file in wig[1]
        ln = open(chomp(file))
        lines = split(readall(ln), '\n')
        chr = split(file, '.')
        for po in lines[3:50]
            pos = split(po, '\t')
            println("goto ", chr[1], ':', pos[1], '-', pos[1])
        end
    end
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
