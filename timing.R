# run with:
# Rscript timing.R

# Set the filename
filename <- 'cconv3_implicit'

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
    times<-NULL;
    cnames <- c(1:length(dat))
    for( i in 1:length(dat) )
        {
            print(i)
            m <- dat[i][[1]][[1]]
            print(m)
            cnames[i] <- toString(m)
            row <- dat[i][[1]][c(3:lengths(dat[i]))]
            print(row)
            cbind(times, row) -> times
        }
    colnames( times ) <- cnames
    return( times )
}

times <- filetodf(filename)

# Show information about the data frame.
typeof(times)
times
summary(times)

# Compare the m=64 times with the m=128 times
wilcox.test(times[,"64"], times[,"128"])
