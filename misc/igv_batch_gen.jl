#!/usr/bin/env julia

path = "http://localhost:8000/bam/"
bamList = readall(pipeline(`curl $path`, `awk '/.bam$/ {print $NF}'`))

list = split(bamList, '\n')

println(length(list)-1, " BAM files found!")


for i in list[1:end-1]
    println("new
genome hg19
load http://localhost:8000/bam/$i
snapshotDirectory /home/gnanavel/Work/GBM_NCV-Roadmap/Data/TCGA/mutations/PNG
goto chr18:27,984,924-27,984,924
sort position
snapshot")
end
