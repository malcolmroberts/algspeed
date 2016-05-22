# run with:
# Rscript timing.R filename1 filename2 m-value
# example:
# Rscript timing.R cconv3_explicit cconv3_implicit 128

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
print(args)

# usage: 

if (length(args) < 3) {
  stop("FIXME: doc. need 3 args .\n", call.=FALSE)
}

filename1 <- args[1]
filename2 <- args[2]
mval <- args[3]

print(filename1)
print(filename2)



filetodf <- function(filename)
{
# Read data from file, dropping first row
    dat <- readLines(filename)[-1]

# Split each line treating 'one or more spaces' as delimiter
    dat <- strsplit(dat, '\\s+')

# Convert to numeric
    dat <- lapply(dat, as.numeric)

# Creat the data frame and fill it
    print( "times" )
    times <- NULL;
    cnames <- c(1:length(dat))
    for( i in 1:length(dat) )  {
        print(i)
        m <- dat[i][[1]][[1]]
        cnames[i] <- toString(m)
        row <- dat[i][[1]][c(3:lengths(dat[i]))]
        cbind(times, row) -> times
    }
    colnames( times ) <- cnames
    return( times )
}

times1 <- filetodf(filename1)
times2 <- filetodf(filename2)

# Show information about the data frames.
typeof(times1)
#times1
summary(times1)

# Show information about the data frames.
typeof(times2)
#times2
summary(times2)

paste("Testing", filename1, "and", filename2, "at m =", mval, sep = " ") 

print("Wilcoxon rank test:")
wilcox.test(times1[,mval], times2[,mval])

print("Mood's median test:")
#mood.medtest(times1[,mval], times2[,mval])

#kruskal.test(times1[,mval], times2[,mval])
median.test <- function(x, y){
#http://stats.stackexchange.com/questions/81864/hypothesis-test-for-difference-in-medians-among-more-than-two-samples
    z <- c(x, y)
    g <- rep(1:2, c(length(x), length(y)))
    m <- median(z)
    fisher.test(z < m, g)$p.value
}

median.test(times1[,mval], times2[,mval])
