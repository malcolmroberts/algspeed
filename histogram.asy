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

real[] tfreq = frequency(t, min(t), max(t), N);
real dx =  (max(t) - min(t)) / N;
tfreq /= dx*sum(tfreq);

real hlow(real[] tfreq, picture pic = currentpicture)
{
  bool[] valid = tfreq > 0;
  real m = min(valid ? tfreq : null);
  real M = max(valid ? tfreq : null);
  bounds my=autoscale(pic.scale.y.scale.T(m),
		      pic.scale.y.T(M),
		      pic.scale.y.scale);
  return pic.scale.y.scale.Tinv(my.min);
}
real low = hlow(tfreq);

histogram(t, min(t), max(t), N,
	  normalize = true, //low = min(t),
	  lightred + opacity(0.5), black, bars = false);

xaxis("time", BottomTop, LeftTicks);
yaxis("Relative frequency", LeftRight, RightTicks);

write("min: ", t[0]);
write("max: ", t[t.length - 1]);

int n = t.length;
real median = t[floor(0.5 * n)];
int nlow = floor(0.025 * n);
int nhigh = ceil(0.975 * n);
real medlow = t[nlow];
real medhigh = t[nhigh];
xequals(median, blue);

xequals(t[nlow], blue + dashed);
xequals(t[nhigh], blue + dashed);
write("median: ", median);
write("medlow: " , medlow);
write("medhigh: " , medhigh);

real tmean = 0;
for(int i = 0; i < n; ++i)
  tmean += t[i];
tmean /= n;
xequals(tmean, red);

write("mean: ", tmean);

pair ldx = (1e-4,0);
if(tmean >= median) {
  ldx *= -1;
}
pair lmean = Scale((tmean, 10) + 6 * S) - ldx;
pair lmedian = Scale((median, 10) + 6 * S) + ldx;
//dot(lmean,  red);
//dot(lmedian,  blue);
label("mean", lmean + 0.1 * S, Align, red);
label("median", lmedian + 0.1 * S, Align, blue);
draw(lmedian--Scale((median, low)), blue, EndArrow);
draw(lmean--Scale((tmean, low)), red, EndArrow);

label(texify(filename), truepoint(S)+0.5*S);
