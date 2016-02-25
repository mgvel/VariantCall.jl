#!/usr/bin/env julia

include("read.jl")

function recall(paths = ARGS[1:end], min_alt_read::Int=4, min_alt_frac=0.2)
   for file in paths
     vcf = read(file)
      
      for line in vcf
        if ismatch(r"^#|CHROM", line)
          println(line)
        else
          cols = split(line, "\t")
          gt_reads  = []
          alt_reads = []
        
          for gt in cols[5:end]
            push!(gt_reads, split(gt, ':')[1])
            push!(alt_reads, split(gt, ':')[2])
          end
          println(gt_reads)  
        end
      end
   end
end

recall()
