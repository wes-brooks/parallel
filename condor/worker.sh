if [ -f /usr/bin/R ]
then
	mkdir output
    Rscript code/condor.r $*
	exit 0
else 
    exit 1
fi
