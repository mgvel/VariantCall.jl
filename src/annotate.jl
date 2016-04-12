
function annotate(vcf_path)
    shell('table_annovar.pl anno_tmp.vcf ~/tools/annovar-170715/humandb '
            '-buildver hg19 --remove --otherinfo --outfile annotated '
            '-operation g,f,f,f '
            '-protocol refGene,cosmic70,1000g2014oct_all,esp6500si_alltable_annovar.pl anno_tmp.vcf ~/tools/annovar-170715/humandb '
            '-buildver hg19 --remove --otherinfo --outfile annotated '
            '-operation g,f,f,f '
            '-protocol refGene,cosmic70,1000g2014oct_all,esp6500si_all')
end

#=
function annotate(vcf_path, method, dbs,)
    shell('table_annovar.pl anno_tmp.vcf ~/tools/annovar-170715/humandb '
            '-buildver hg19 --remove --otherinfo --outfile annotated '
            '-operation g,f,f,f '
            '-protocol refGene,cosmic70,1000g2014oct_all,esp6500si_alltable_annovar.pl anno_tmp.vcf ~/tools/annovar-170715/humandb '
            '-buildver hg19 --remove --otherinfo --outfile annotated '
            '-operation g,f,f,f '
            '-protocol refGene,cosmic70,1000g2014oct_all,esp6500si_all')
end
=#
