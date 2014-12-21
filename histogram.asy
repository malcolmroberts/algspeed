import graph;
import stats;

size(400, 200, IgnoreAspect);

scale(Linear, Log);

string filename;
filename = getstring("external data:");
file fin = input(filename).line();
real[][] a = fin.dimension(0,0);
a = transpose(a);
real[] t = sort(a[0]);

int N = 2 * bins(t);

histogram(t, min(t), max(t), N,
	  normalize = true, low = min(t),
	  lightred + opacity(0.5), black, bars = false);

write("min: ", t[0]);
write("max: ", t[t.length - 1]);


int n = t.length;
real median = t[floor(0.5 * n)];
int nlow = floor(0.5 * n - 0.6 * 1.96 * sqrt(n));
int nhigh = ceil(1 + 0.5 * n + 0.6 * 1.96 * sqrt(n));
real medlow = t[nlow];
real medhigh = t[nhigh];
xequals(median, blue);
xequals(t[nlow], blue + dashed);
xequals(t[nhigh], blue + dashed);
write("median: ", median);
write("medlow: " , medlow);
write("medhigh: " , medhigh);

xequals(t[floor(0.05 * n)], blue + dotted);
xequals(t[ceil(0.95 * n)], blue + dotted);

real mean = 0;
for(int i = 0; i < n; ++i)
  mean += t[i];
mean /= n;
xequals(mean, red);
write("mean: ", mean);

xaxis("time", BottomTop, LeftTicks);
yaxis("Relative frequency", LeftRight, RightTicks);

