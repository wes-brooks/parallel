#Load the command line arguments:
args = commandArgs(trailingOnly=TRUE)
cluster = as.integer(args[1])
process = as.integer(args[2])

#Establish the simulation parameters
settings = 4
mu = rep(c(0,1), settings/2)
sigma = rep(c(1,2), each=settings/2)
params = data.frame(mu, sigma)

#Simulation parameters are based on the value of process
N = 10 #Ten repetitions per setting
setting = process %/% N + 1
parameters = params[setting,]

#Seed the RNG
seeds = as.vector(read.csv("seeds.csv", header=FALSE)[,1])
set.seed(seeds[process+1])

#Simulate our "data" and analyze it:
y = rnorm(n=100, mean=parameters$mu, sd=parameters$sigma)
m = mean(y)

#Write the results of the analysis to a file:
sink(paste("output/simulation.", cluster, ".", process, ".txt", sep=""))
cat(m)
sink()
