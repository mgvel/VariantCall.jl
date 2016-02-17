module VariantCall

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
	include(Pkg.dir("VariantCall", "src", "vcf.jl"))
	
end # VariantCall module
