#!/usr/bin/env julia

"""
Fixing VCF files generated from variant calling
to load into IGV
"""

function fixHeader(vcf=ARGS[1])
    file = open(vcf)
    lines = readlines(file)
    info = "##fileformat=VCFv4.1
##fileDate=20151202
##source=Variant Calling
##reference=/wrk/annalam/organisms/homo_sapiens/hg19_nochr.fa
##INFO=Juliette
##INFO=--alt-reads=2 --alt-frac=0.05"
    println(info)
    header = "#" * shift!(lines)
    println(header)
    for i in lines#[1:5]
        println(chomp(i))
    end
end

fixHeader()
