## Parallel computing in R




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