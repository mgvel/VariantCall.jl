module VariantCall

	# dependaencies
	using Base
	using GZip
	
	# Exported methods
	export read,
			records,
			infos,
			infoAA,
			HeadInfos,
			version,
			header,
			chromosomes,
			fetch,
			chrange,
			region,
			alts,
			uniqalts,
			E1000G,
			@vcf_recrd
	
	# Load package files
	include(Pkg.dir("VariantCall", "src", "vcf.jl"))
	
end # VariantCall module
