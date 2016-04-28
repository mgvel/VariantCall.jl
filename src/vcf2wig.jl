#!/usr/bin/env julia

"""
a tool for creating wig files from results of variant heterozygous bases.
"""
include("read.jl")

function vcf2wig(vcf_path= ARGS[1])
    lines = read(vcf_path)
    println('track graphType=bar windowingFunction=none autoScale=off viewLimits=0:1')
    chrom = ''
    value = 1
    for line in lines
        cols = split(chomp(line),'\t')
        chr = cols[1]
        pos = cols[2]
        if chrom != chr
            chrom = chr
            println("variableStep chrom=$chrom")
            println("$pos\t$value")
        else
            println("$pos\t$value")
        end
    end
end

vcf2wig()

#=
function snp2wig_with_allele(vcf_path):
    h_file = open(snp_file_path, 'r')
    header = next(h_file)
    print( 'track graphType=bar windowingFunction=none autoScale=off viewLimits=0:1')
    chrom = ''
    for line in h_file:
        cols = line.rstrip('\n').split('\t')
        chr = cols[0]
        pos = cols[1]
        value = cols[4]
        if chrom != chr:
            chrom = chr
            print( "variableStep chrom=%s" %chrom)
            print( "%s\t%s" %(pos, value))
        else:
            print( "%s\t%s" %(pos, value))
        end
    end
    h_file.close()
end

"""
if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    if args['no_allele_fraction']:
        snp_position2wig_no_allele(args['<het_snp_file>'])
    elif args['with_allele_fraction']:
        snp_position2wig_with_allele(args['<het_snp_file>'])
"""
=#
