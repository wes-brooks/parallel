% title: Parallel computing in R
% subtitle: Local and distributed
% author: Wesley Brooks
% author: somesquares.org
% thankyou: Thanks everyone!
<!---% thankyou_details: And especially these people:--->
<!---% contact: <span>website</span> <a href="http://somesquares.org/blog/">website</a>--->
<!---% contact: <span>github</span> <a href="http://github.com/wesesque">wesesque</a>--->
<!---% contact: <span>twitter</span> <a href="http://twitter.com/buckyphilia">@buckyphilia</a>--->
% favicon: http://www.stat.wisc.edu/sites/all/libraries/uw_madison_omega/favicon.ico

---
title: Introduction
subtitle: Overview of parallelization in R
class: segue dark nobackground



---
title: What is parallel computing?

Run parts of your code on many different processors simultaneously.

Often loops are prime candidates for parallelization.



---
title: Parallelize your problem
build_lists: true

Required for parallelization: 

- Independent processing chunks
- Independent data chunks



---
title: Parallelize your code
build_lists: true

How to do parallelization:

- Break the code into independent pieces
- Send each piece to a processor
- Run each piece
- Compile the results into a single data structure
- Your gains from parallelization will depend on how difficult each step is (for the programmer and the computer).



---
title: Parallelize your code
build_lists: true

Your gains from parallelization will depend on how difficult each step is (for the programmer and the computer).

- Low effort for modest gain: multicore parallelization
- High effort for massive gain: distributed parallelization



---
title: Quick and dirty parallelization
subtitle: Multicore parallelization
class: segue dark nobackground





---
title: Quick and dirty
subtitle: Multicore parallelization

Modern computers typically have from two to eight processing cores, of which basic R uses only one.

One way to make use of your spare computing power:

- Get R packages `foreach` and `doMC`
- Minimal effort to parallelize for loops
- Code at github.com/wesesque/parallel/code/foreach.r




---
title: Quick and dirty
subtitle: Multicore parallelization

<pre class="prettyprint" data-lang="R">
library(foreach)
library(doMC)

#Register the number of cores to devote to parallel computation:
registerDoMC()
registerCores(n=3)

y = rnorm(100)

#Compute the bootstrap distribution via parallel computation:
boot = foreach(i=1:200, .packages=c('lars'), .errorhandling='remove') %dopar% {
    z = sample(y, replace=TRUE)
    return(mean(z))
}

#Extract the results from the list to a vector:
boots = sapply(boot, function(x) x[[1]])
</pre>




---
title: More powerful parallelization
subtitle: Distributed computing via condor
class: segue dark nobackground






---
title: More powerful parallelization
subtitle: What is condor?
build_lists: true

Condor is a distributed computing platform that was developed by the UW-Madison CS department.

- Sends your job to run on any idle processor within a grid
- Center for High Throughput Computing (CHTC) manages a campus-wide grid (no R on these machines)
- There is a combined stat/CS grid accessible via the `desk` servers (R on _some_ of these)

---
title: More powerful parallelization
subtitle: A pitfall!
build_lists: true

- _You_ need to make sure that each compute node has a working version of R
- _You_ need to send any necessary R packages to the compute node.
- My shorthand: any computer with "stat" in the name probably has R
- Also, I test for R's presence when the job starts.
- Theoretically, one could send R as _part_ of the job, but on Linux R links to system libraries in places like `/usr/bin`


---
title: More powerful parallelization
subtitle: How does one use condor?
build_lists: false

Remember the list of "steps":

- Break the code into independent pieces
- Send each piece to a processor
- Run each piece
- Compile the results into a single data structure

Condor only does steps two and three, but you can use dozens or hundreds of processors at once.



---
title: More powerful parallelization
subtitle: Pieces of a condor job
build_lists: false

You must create these files, which call each other in this order:

- A condor submit file
- A worker shell script
- Your R script

See `github.com/wesesque/parallel/condor` and `github.com/wesesque/parallel/code/condor.r`



---
title: Example submit file
build_lists: false

<pre class="prettyprint" data-lang="condor">
universe = vanilla
log = logs/log_$(Cluster)_$(Process).log
error = logs/err_$(Cluster)_$(Process).err
output = logs/out_$(Cluster)_$(Process).out
executable = condor/worker.sh
arguments = $(Cluster) $(Process)
requirements = (Target.OpSys=="LINUX" && Target.Arch=="X86_64"  && regexp("stat", Machine))
should_transfer_files = YES
when_to_transfer_output = ON_EXIT_OR_EVICT
transfer_input_files = code, R-libs, condor, seeds.csv
transfer_output_files = output
notification = Never
on_exit_remove = (ExitBySignal == False) && (ExitCode == 0)
queue 40
</pre>


---
title: Example worker shell script
build_lists: false

<pre class="prettyprint" data-lang="bash">
if [ -f /usr/bin/R ]
then
	mkdir output
    Rscript code/condor.r $*
	exit 0
else 
    exit 1
fi
</pre>




---
title: Example R script (1/2)

<pre class="prettyprint" data-lang="R">
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
</pre>



---
title: Example R script (2/2)

<pre class="prettyprint" data-lang="R">
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
</pre>


---
title: More powerful parallelization
subtitle: Submitting to condor
build_lists: false

The condor binaries are in `/unsup/condor/bin`

- Submit the example: `/unsup/condor/bin/condor_submit condor/simulation.condor`
- Check your queue: `/unsup/condor/bin/condor_q`
- Check the grid's status: `/unsup/condor/bin/condor_status`
- Cancel a job: `/unsup/condor/bin/condor_rm 21`

