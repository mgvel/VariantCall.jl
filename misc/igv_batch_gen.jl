#!/usr/bin/env julia

path = "http://localhost:8000/bam/"
list = readall(pipeline(`curl $path`, `awk '/.bam$/ {print $NF}'`))

fH = ARGS[1]
wig = split(readall(fH), '\n')

bamList = split(list, '\n')

println(length(bamList)-1, " BAM files found!")
println(length(wig))

for f in wig
    println(f)
end

for i in bamList[1:end-1]
    for file in wig
        ln = open(file)
        lines = readall(ln)
        chr = split(file, '.')
        println(i, '\t', chr[1])
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
