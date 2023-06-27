r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)

.libPaths()

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("ChIPseeker")

BiocManager::install("genomation")

library(ChIPseeker)
library(genomation)

#install.packages("tidyverse", repos = "http://cran.us.r-project.org")
#install.packages("mgcv", repos = "http://cran.us.r-project.org")
#install.packages("ggplot2", repos = "http://cran.us.r-project.org"))
