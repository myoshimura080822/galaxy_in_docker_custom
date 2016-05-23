# galaxy_in_docker_custom

This extension add NGS analysis tools for Dockerfiles 
in the bgruening/docker-galaxy-stable images from Björn A. Grüning.

https://github.com/bgruening/docker-galaxy-stable

# History(Tag)
- myoshimura080822/galaxy_in_docker_base:0520
  - replace sailfish-0.9.2 binary
    - from SailfishBeta-0.9.2 to Sailfish-0.9.2
  - remove sailfish from PATH
  - add wigToBigWig
    - http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig
  - add toolshed-tools below
    - cuffnorm 
- myoshimura080822/galaxy_in_docker_base:0408
  - add toolshed-tools below
    - bowtie2          
    - cuffcompare      
    - cuffdiff        
    - cufflinks        
    - cuffquant        
    - express          
    - fastqc           
    - gffread          
    - hisat2           
    - sam_merge        
    - samtools_flagstat
    - tophat2 
    - rseqc
- myoshimura080822/galaxy_in_docker_base:0404
  - add SailfishBeta-0.9.2

# Installation
- Install Docker on your computer
- get the Image: ```docker pull myoshimura080822/galaxy_in_docker_custom```
- follow the Usage of [Readme](https://github.com/bgruening/docker-galaxy-stable/blob/master/README.md)
- start Galaxy

# Install modules
- tree
- zsh
- vim custom setting
- R
  - Mus.musculus database
  - edgeR
  - flexmix
  - scde
- python required packages
- galaxy tools
  - eXpress
  - edgeR
  - tophat2
  - bowtie2
  - fastq-mcf
  - fastqc
  - toolfactory
  - toolfactory2
