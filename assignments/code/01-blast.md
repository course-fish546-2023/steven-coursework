# Download Software

<https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz>

    cd /home/jovyan/applications
    curl -O https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz

    cd /home/jovyan/applications
    tar -xf ncbi-blast-2.13.0+-x64-linux.tar.gz

    ~/applications/ncbi-blast-2.13.0+/bin/blastx -h

# Make a database

    cd ../data
    curl -O https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
    mv uniprot_sprot.fasta.gz uniprot_sprot_r2023_01.fasta.gz
    gunzip -k uniprot_sprot_r2023_01.fasta.gz
    ls ../data

    ~/applications/ncbi-blast-2.13.0+/bin/makeblastdb \
    -in ../data/uniprot_sprot_r2023_01.fasta \
    -dbtype prot \
    -out ../blastdb/uniprot_sprot_r2023_01

# download query

    curl https://eagle.fish.washington.edu/cnidarian/Ab_4denovo_CLC6_a.fa \
    -k \
    > ../data/Ab_4denovo_CLC6_a.fa

    head ../data/Ab_4denovo_CLC6_a.fa
    echo "How many sequences are there?"
    grep -c ">" ../data/Ab_4denovo_CLC6_a.fa

    ## >solid0078_20110412_FRAG_BC_WHITE_WHITE_F3_QV_SE_trimmed_contig_1
    ## ACACCCCACCCCAACGCACCCTCACCCCCACCCCAACAATCCATGATTGAATACTTCATC
    ## TATCCAAGACAAACTCCTCCTACAATCCATGATAGAATTCCTCCAAAAATAATTTCACAC
    ## TGAAACTCCGGTATCCGAGTTATTTTGTTCCCAGTAAAATGGCATCAACAAAAGTAGGTC
    ## TGGATTAACGAACCAATGTTGCTGCGTAATATCCCATTGACATATCTTGTCGATTCCTAC
    ## CAGGATCCGGACTGACGAGATTTCACTGTACGTTTATGCAAGTCATTTCCATATATAAAA
    ## TTGGATCTTATTTGCACAGTTAAATGTCTCTATGCTTATTTATAAATCAATGCCCGTAAG
    ## CTCCTAATATTTCTCTTTTCGTCCGACGAGCAAACAGTGAGTTTACTGTGGCCTTCAGCA
    ## AAAGTATTGATGTTGTAAATCTCAGTTGTGATTGAACAATTTGCCTCACTAGAAGTAGCC
    ## TTC
    ## How many sequences are there?
    ## 5490

# blast

    ~/applications/ncbi-blast-2.13.0+/bin/blastx \
    -query ../data/Ab_4denovo_CLC6_a.fa \
    -db ../blastdb/uniprot_sprot_r2023_01 \
    -out ../output/Ab_4-uniprot_blastx.tab \
    -evalue 1E-20 \
    -num_threads 20 \
    -max_target_seqs 1 \
    -outfmt 6

# Joining with Annotation information

First need to change formate of blast output in bash…

    tr '|' '\t' < ../output/Ab_4-uniprot_blastx.tab \
    > ../output/Ab_4-uniprot_blastx_sep.tab

## Now into R

    library(tidyverse)

read in data

    bltabl <- read.csv("../output/Ab_4-uniprot_blastx_sep.tab", sep = '\t', header = FALSE)

    spgo <- read.csv("https://gannet.fish.washington.edu/seashell/snaps/uniprot_table_r2023_01.tab", sep = '\t', header = TRUE)

joining

    left_join(bltabl, spgo,  by = c("V3" = "Entry")) %>%
      select(V1, V3, V13, Protein.names, Organism, Gene.Ontology..biological.process., Gene.Ontology.IDs) %>% mutate(V1 = str_replace_all(V1, 
                pattern = "solid0078_20110412_FRAG_BC_WHITE_WHITE_F3_QV_SE_trimmed", replacement = "Ab")) %>%
      write_delim("../output/blast_annot_go.tab", delim = '\t')
