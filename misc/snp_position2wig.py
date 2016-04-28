#!/bin/env python
"""
a tool for creating wig files from results of variant heterozygous bases.

Usage:
  snp_position2wig.py no_allele_fraction <het_snp_file>
  snp_position2wig.py with_allele_fraction <het_snp_file>

Options:
  -h --help             Show this screen

Author: Ebrahim Afyounian <ebrahim.afyounian@staff.uta.fi>
"""
import docopt

def snp_position2wig_no_allele(snp_file_path):
    h_file = open(snp_file_path, 'r')
    header = next(h_file)
    print('track graphType=bar windowingFunction=none autoScale=off viewLimits=0:1')
    chrom = ''
    value = 1
    for line in h_file:
        cols = line.rstrip('\n').split('\t')
        chr = cols[0]
        pos = cols[1]
        if chrom != chr:
            chrom = chr
            print("variableStep chrom=%s" %chrom)
            print("%s\t%s" %(pos, value))
        else:
            print( "%s\t%s" %(pos, value))
    h_file.close()

def snp_position2wig_with_allele(snp_file_path):
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
    h_file.close()


if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    if args['no_allele_fraction']:
        snp_position2wig_no_allele(args['<het_snp_file>'])
    elif args['with_allele_fraction']:
        snp_position2wig_with_allele(args['<het_snp_file>'])
