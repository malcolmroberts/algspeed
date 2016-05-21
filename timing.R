# run with:
# Rscript timing.R

# Set the filename
filename <- 'cconv3_implicit'

# Set the index (starting at 1) of the row that we want to look at.
index1 <- 2
index2 <- 3

# Read data from file, dropping first row
dat <- readLines(filename)[-1]

# Split each line treating 'one or more spaces' as delimiter
dat <- strsplit(dat, '\\s+')

# Convert to numeric
dat <- lapply(dat, as.numeric)

# Select the data that we want
print("times:")
times1 <- data.frame(dat[index1][[1]][c(3:lengths(dat[index1]))])
times1

# Compute things
summary(times1)
print("median:")
median(as.matrix(times1))

# Select the data that we want
print("times:")
times2 <- data.frame(dat[index2][[1]][c(3:lengths(dat[index2]))])
times2

# Compute things
summary(times2)
print("median:")
median(as.matrix(times2))


# Error: could not find function "mood.medtest"
#mood.medtest(times1, times2)

#kruskal.test(as.list(times1), as.list(times2))
wilcox.test(times1[,1], times2[,1])

#times1[,'timing']
#times1$timing
