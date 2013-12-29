#Load the libraries
library(foreach)
library(doMC)

#Register the number of cores to devote to parallel computation:
registerDoMC()
registerCores(n=3)

#Simulate our data
y = rnorm(100)

#Compute the bootstrap distribution via parallel for loop:
boot = foreach(i=1:200, .packages=c('lars'), .errorhandling='remove') %dopar% {
    z = sample(y, replace=TRUE)
    return(mean(z))
}

#Extract the results from the list to a vector:
boots = sapply(boot, function(x) x[[1]])
