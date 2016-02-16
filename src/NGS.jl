module NGS

	# dependaencies
	using Base
	using GZip
	
	# Exported methods
	export read,
			records,
			infos,
			version,
			header,
			chromosomes,
			fetch,
			chrange,
			region,
			@vcf_recrd
	
	# Load package files
	include(Pkg.dir("NGS", "src", "vcf.jl"))
	
end # NGS module
