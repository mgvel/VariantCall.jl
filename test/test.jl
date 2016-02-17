using VariantCall

chr = ARGS[1]
inputf = ARGS[2]

#line = VariantCall.read(inputf)
record = VariantCall.records(inputf)
#println(join(record,"\n"))
#print(join(record[1:15]), "\n")

#inf = VariantCall.info(record)
#aa = VariantCall.infoAA(record)
thouG = VariantCall.E1000G(record)
for ln in thouG
	println(ln)
end

#println(info)

#from, to = chrange(record, chr)
#extract = VariantCall.fetch(record, chr, 17104729, 18078510)
#=
alterations = VariantCall.uniqalts(record)
for ln in alterations#[1:30]
	println(ln)
end
=#
# out1 = VariantCall.fetch(record, chr)

#print(out1)
#chromosomes = VariantCall.getchr(record)
#println(chromosomes)
