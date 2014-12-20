#!/usr/bin/python -u

import csv # to load the input file.
import numpy as np # numerical methods such as FFTs.
import getopt # to pass command-line arguments
import sys # to check for file existence, etc.
import scipy.stats # Science! (Wilcoxon signed-rank test)

def readtimes(filename):
    t = []
    csvReader = csv.reader(open(filename, 'rb'), delimiter = '\t')
    for row in csvReader:
        t.append(float(row[0]))
    return t

def medianconf(t):
    tmedian = np.median(t)
    t = sorted(t)
    n = len(t)
    nlow = int(np.floor(0.5 * n - 0.6 * 1.96 * np.sqrt(n)))
    nhigh = int(np.ceil(1 + 0.5 * n + 0.6 * 1.96 * np.sqrt(n)))
    tlow = t[nlow]
    thigh = t[nhigh]
    return tmedian, tlow, thigh

def main(argv):
    filenames = []

    # Load the command-line arguments
    try:
        opts, args = getopt.getopt(argv,"f:")
    except getopt.GetoptError:
        print usage
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-f"):
            filenames.append(arg)

    if(len(filenames) == 1):
        t = readtimes(filenames[0])
        print medianconf(t)

    if(len(filenames) == 2):
        t1 = readtimes(filenames[0])
        t2 = readtimes(filenames[1])
        print "Read " + str(len(t1)) + " values."
        t1med, t1low, t1high = medianconf(t1)
        t2med, t2low, t2high = medianconf(t2)
        print t1med, t1low, t1high
        print t2med, t2low, t2high
        if(t1med > t2med):
            diff = max(t1high - t1med, t2med - t2low)
        else: 
            diff = max(t1med - t1low, t2high - t2med)
        print "diff: " + str(diff)
        if(t1low < t2high or t2low < t1high):
            print "The confidence intervals overlap."
        else:
            print "The confidence intervals do not overlap."

        if(len(t1) != len(t2)):
            print "Error: arrays differ in length, so WSR is not valid."
            sys.exit(1)
        T , p = scipy.stats.wilcoxon(t1, t2)
        print p
        if(p < 0.05):
            print "The difference in medians is significant."
        else:
            print "The difference in medians is not significant."

# The main program is called from here
if __name__ == "__main__":
    main(sys.argv[1:])
