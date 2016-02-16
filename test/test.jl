using NGS

chr = ARGS[1]
inputf = ARGS[2]

#line = NGS.read(inputf)
record = NGS.read(inputf)
#println(join(record,"\n"))
#print(join(record[1:15]), "\n")

info = NGS.infos(record)
println(info)

# out1 = NGS.fetch(record, chr)
#=
#print(out1)
chromosomes = getchr(record)
println(chromosomes)
=#