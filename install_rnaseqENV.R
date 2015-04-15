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
