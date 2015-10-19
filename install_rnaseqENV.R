is.installed <- function(mypkg){
    is.element(mypkg, installed.packages()[,1])
}

if (!is.installed("dplyr")){
    install.packages('lazyeval', repos="http://cran.rstudio.com/")
    install.packages('dplyr', repos="http://cran.rstudio.com/")
}
if (!is.installed("plyr")){
	install.packages('plyr', repos="http://cran.rstudio.com/")
}
if (!is.installed("tidyr")){
	install.packages('tidyr', repos="http://cran.rstudio.com/")
}
if (!is.installed("stringr")){
	install.packages('stringr', repos="http://cran.rstudio.com/")
}

if (!is.installed("ggplot2")){
    install.packages('ggplot2', repos="http://cran.rstudio.com/")
}

if (!is.installed("pairsD3")){
    install.packages('pairsD3', repos="http://cran.rstudio.com/")
}

if (!is.installed("magrittr")){
    install.packages('magrittr', repos="http://cran.rstudio.com/")
}

if (!is.installed("matrixStats")){
    install.packages('matrixStats', repos="http://cran.rstudio.com/")
}

if (!is.installed("pvclust")){
    install.packages('pvclust', repos="http://cran.rstudio.com/")
}

if (!is.installed("devtools")){
    install.packages('devtools', repos="http://cran.rstudio.com/")
}

if (!is.installed("factoextra")){
    devtools::install_github("kassambara/factoextra")
}

if (!is.installed("rgl")){
    install.packages('rgl', repos="http://cran.rstudio.com/")
}

source("http://bioconductor.org/biocLite.R")
biocLite()

if (!is.installed("Mus.musculus")){
	biocLite("Mus.musculus")
}
if (!is.installed("edgeR")){
	biocLite("limma")
	biocLite("edgeR")
}

if (!is.installed("scde")){
    biocLite("flexmix")
    biocLite("quantreg")
    install.packages("RcppArmadillo", repos="http://cran.rstudio.com/") 
    install.packages("Rook", repos="http://cran.rstudio.com/")
    install.packages("rjson", repos="http://cran.rstudio.com/")
    install.packages("Cairo", repos="http://cran.rstudio.com/")
    install.packages("repmis", repos="http://cran.rstudio.com/")
    install.packages("RColorBrewer", repos="http://cran.rstudio.com/")

    download.file("http://pklab.med.harvard.edu/scde/scde_1.2.1.tar.gz", destfile="scde_1.2.1.tar.gz")
    install.packages("scde_1.2.1.tar.gz", repos=NULL, type="source")
}

# for destiny
install.packages('gridExtra', repos="http://cran.rstudio.com/")
install.packages('plotrix', repos="http://cran.rstudio.com/")
install.packages('spatgraphs', repos="http://cran.rstudio.com/")
biocLite("destiny")

#remove.packages("BiocInstaller")
