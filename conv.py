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
        if not row[0].startswith('#'):
            t.append(float(row[0]))
    return t

def write_av(data, filename):
    f = open(filename, 'wb')
    datawriter = csv.writer(f, delimiter = '\t')
    i = 0
    while i < len(data):
        datawriter.writerow(data[i])
        i += 1
    f.close()

# alpha is equal to one minus the confidence interval
def medianconf(t, alpha):
    tmedian = np.median(t)
    #t = sorted(t)
    n = len(t)
    #nlow = int(np.ceil(0.5 * n - 0.6 * 1.96 * np.sqrt(n)))
    #nhigh = int(np.floor(1 - 0.5 * n + 0.6 * 1.96 * np.sqrt(n)))
    nlow = int(np.ceil(0.5 * alpha * n))
    nhigh = int(np.floor((1.0 - 0.5 * alpha) * n))
    tlow = t[nlow]
    thigh = t[nhigh]
    return tmedian, tlow, thigh

def main(argv):
    filenames = []
    N = 1
    alpha = 0.05
    inv = False

    # Load the command-line arguments
    try:
        opts, args = getopt.getopt(argv,"f:N:a:i")
    except getopt.GetoptError:
        print usage
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-f"):
            filenames.append(arg)
        if opt in ("-N"):
            N = int(arg)
        if opt in ("-a"):
            alpha = float(arg)
        if opt in ("-i"):
            inv = True

    if(len(filenames) == 1):
        t = readtimes(filenames[0])
        print len(t)
        
        if(inv):
            i = 0
            while(i < len(t)):
                t[i] = 1.0 / t[i]
                i += 1
        
        n = int(np.floor(len(t) / N))
        
        print n
        
        nmed = []
        npalpha = []
        nmean = []
        nmin = []
        nmax = []
        nstarts = []
        nends = []

        i = int(np.ceil(1.0 / alpha)) 
        while(i < n):
            print i

            meds = [i]
            palphas = [i]
            means = [i]
            mins = [i]
            maxs = [i]
            starts = [i]
            ends = [i]

            j = 0
            while(j < N):
                ti = t[n * j: n * j + i]
                ti = sorted(ti)
                
                median, tlow, thigh = medianconf(ti, alpha)

                meds.append(median)
                if(N == 1):
                    meds.append(median - tlow)
                    meds.append(thigh - median)

                nstart = int(np.floor(0.5 * alpha * i))
                nend = int(np.floor((1.0 - 0.5 * alpha) * i))

                palphas.append(np.median(ti[nstart:nend]))
                if(N == 1):
                    palphas.append(median - ti[nstart])
                    palphas.append(t[nend] - median)

                means.append(np.mean(ti))
                mins.append(min(ti))
                maxs.append(max(ti))

                nstart = int(np.floor(alpha * i))
                val = np.median(ti[0:nstart])
                starts.append(val)
                if(N == 1):
                    starts.append(val - ti[0])
                    starts.append(ti[nstart] - val)

                nend = int(np.floor((1.0 - alpha) * i))
                val = np.median(ti[nend:i])
                ends.append(val)
                if(N == 1):
                    ends.append(val - ti[nend])
                    ends.append(ti[-1] - val)

                
                j += 1
                
            nmed.append(meds)
            npalpha.append(palphas)
            nmean.append(means)
            nmin.append(mins)
            nmax.append(maxs)
            nstarts.append(starts)
            nends.append(ends)

            i *= 2

        write_av(nmed, "medians.csv")
        write_av(npalpha, "palphas.csv")
        write_av(nmean, "means.csv")
        write_av(nmin, "mins.csv")
        write_av(nmax, "maxs.csv")
        write_av(nstarts, "starts.csv")
        write_av(nends, "ends.csv")

# The main program is called from here
if __name__ == "__main__":
    main(sys.argv[1:])
