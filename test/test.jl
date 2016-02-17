using NGS

chr = ARGS[1]
inputf = ARGS[2]

line = NGS.read(inputf)
record = NGS.records(inputf)
#println(join(record,"\n"))
#print(join(record[1:15]), "\n")

#info = NGS.infos(record)
#println(info)

from, to = chrange(record, chr)
extract = NGS.fetch(record, chr, 1014318, 1232471)

# out1 = NGS.fetch(record, chr)

#print(out1)
chromosomes = NGS.getchr(record)
println(chromosomes)
