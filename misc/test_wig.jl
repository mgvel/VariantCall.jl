fl = open("model-based-cpg-islands-hg19.txt")

txt = readlines(fl)

function expand(locci)
    list = []
    pos = split(locci, ':')
        chr = pos[1]
        region = split(pos[2], '-')
        n = parse(Int64, region[1])
        while n <= parse(Int64, region[end])
             out =  "$n\t$chr"
            push!(list, out)
            n +=  1
        end
    return list
end


for line in txt[2:end]
    cols = split(line, '\t')
    chrm = replace(cols[1], "chr", "")
    start = cols[2]
    last = cols[3]
    chroms = "$chrm" * ":" * "$start" * "-" * "$last"
    positions = expand(chroms)

    for item in positions
        println(item)
    end
end
