#!/usr/bin/env julia

using GZip

function read(file)
	if ismatch(r".vcf$", file)
		f = open(file)
		lines = readlines(f)
		close(f)
	elseif ismatch(r".gz$", file)
		f = GZip.open(file)
		lines = readlines(f)
		close(f)
	end
	return lines
end

function merge(paths = ARGS[1:end])
	headers = []
	samples = []
	for fl in paths
		println("Merging ... ... ..: ", basename(fl))
		vcf = read(fl)
		for line in vcf
			if ismatch(r"^#", line)
				push!(headers, line)
			else
				push!(samples, line)
			end
		end
	end
	return headers, samples
end


id, data = merge()
println(sizeof(id), "\t", sizeof(data))

#=
ln  = 1
while ln <= sizeof(id)
		println(id[ln])
		ln += 1
end

sort_in, sort_out = shell_stdinout('sort -k2,2 -k3,3n -k4,4 -k5,5')
        cons_headers = []    # Consensus headers
				483         vcf_samples = []     # Sample names of each VCF
         for vcf_index, vcf_path in enumerate(vcf_paths):
                 info('Merging VCF file %s...' % vcf_path)
                 vcf = zopen(vcf_path)
                 for line in vcf:
                         if not line.startswith('#'): break
                 headers = line.rstrip('\n').split('\t')
                 gtype_col = (4 if not 'ESP6500' in headers else
                         headers.index('ESP6500') + 1)
                 if not cons_headers: cons_headers = headers[:gtype_col]
                 if cons_headers != headers[:gtype_col]: error('Header mismatch!')
                 vcf_samples.append(headers[gtype_col:])
                 for line in vcf:
                         sort_in.write('%d\t%s' % (vcf_index, line))
         sort_in.close()

=#
