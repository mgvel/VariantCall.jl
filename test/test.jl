using NGS

chr = ARGS[1]
inputf = ARGS[2]

#line = NGS.read(inputf)
record = NGS.records(inputf)
#println(join(record,"\n"))
#print(join(record[1:15]), "\n")

#inf = NGS.info(record)
#aa = NGS.infoAA(record)
thouG = NGS.E1000G(record)
for ln in thouG
	println(ln)
end

#println(info)

#from, to = chrange(record, chr)
#extract = NGS.fetch(record, chr, 17104729, 18078510)
#=
alterations = NGS.uniqalts(record)
for ln in alterations#[1:30]
	println(ln)
end
=#
# out1 = NGS.fetch(record, chr)

#print(out1)
#chromosomes = NGS.getchr(record)
#println(chromosomes)