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
title: Parallelize your problem
build_lists: true

Requirements: 

- Independent processing chunks
- Independent data chunks



---
title: Parallelize your code
build_lists: true

Steps: 

- Break the code into independent pieces
- Send each piece to a processor
- Compile the results




---
title: Slide with a figure
subtitle: Subtitles are cool too
class: img-top-center

<img height=150 src=figures/200px-6n-graf.svg.png />

- Some point to make about about this figure from wikipedia
- This slide has a class that was defined in theme/css/custom.css

<footer class="source"> Always cite your sources! </footer>





---
title: Segue slide
subtitle: I can haz subtitlz?
class: segue dark nobackground






---
title: Maybe some code?
class: 

press 'h' to highlight an important section (that is highlighted
with &lt;b&gt;...&lt;/b&gt; tags)

<pre class="prettyprint" data-lang="R">
models = foreach(i=1:n, .packages=c('glmnet'), .errorhandling='remove') %dopar% {
    #Fit one location's model here
    loc = coords.unique[i,]
    gw = gweights[[i]]

            if (is.null(oracle)) {
            m = gwglmnet.fit.inner(x=x, y=y, family=family, bw=bw, coords=coords, loc=loc, s=s, verbose=verbose, mode.select=mode.select, gwr.weights=gw, prior.weights=prior.weights, gweight=gweight, adapt=adapt, precondition=precondition, predict=predict, tuning=tuning, simulation=simulation, alpha=alpha, interact=interact, N=N, shrunk.fit=shrunk.fit, AICc=AICc)
            } else {
        m = gwselect.fit.oracle(x=x, y=y, family=family, bw=bw, coords=coords, loc=loc, indx=indx, oracle=oracle[[i]], N=N, mode.select=mode.select, tuning=tuning, predict=predict, simulation=simulation, verbose=verbose, gwr.weights=gw, prior.weights=prior.weights, gweight=gweight, AICc=AICc)
    }

    if (verbose) {
            cat(paste("For i=", i, "; location=(", paste(round(loc,3), collapse=","), "); bw=", round(bw,3), "; s=", m[['s']], "; sigma2=", round(tail(m[['sigma2']],1),3), "; nonzero=", paste(m[['nonzero']], collapse=","), "; weightsum=", round(m[['weightsum']],3), ".\n", sep=''))
    }
    return(m)
}

gwglmnet.object[['models']] = models
</pre>

