import graph;
import stats;

size(20cm, 10cm, IgnoreAspect);

scale(Linear, Log);
bool speed = true;

string filename;
filename = getstring("external data:");
file fin = input(filename).line();
real[][] a = fin.dimension(0,0);
a = transpose(a);

write("read " + (string)(a[0].length) + " values.");

real[] t = a[0];

if(speed) {
  for(int i = 0; i < t.length; ++i)
    t[i] = 1.0 / t[i];
}

t = sort(t);
  
int nbins = 2 * bins(t);

real[] tfreq = frequency(t, min(t), max(t), nbins);
real dx =  (max(t) - min(t)) / nbins;
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

histogram(t, min(t), max(t), nbins,
	  normalize = true, //low = min(t),
	  lightred + opacity(0.5), black, bars = false);

string xleg = speed ? "computations per second" : "time (s)";
xaxis(xleg, BottomTop, LeftTicks);
yaxis("Relative frequency", LeftRight, RightTicks);

write("min: ", t[0]);
write("max: ", t[t.length - 1]);

int n = t.length;
real alpha = 0.05;
real median = t[floor(0.5 * n)];
int nlow = floor(0.5 * alpha * n);
int nhigh = ceil((1.0 - 0.5 * alpha) * n);
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

pair q = truepoint(N, true);
label(texify(filename), q, 4*N);

pair ldx = 6e-2 * (truepoint(E, true).x - truepoint(W, true).x , 0);
if(tmean >= median) {
  ldx *= -1;
}
ldx = 0.0;

bool dolabels = true;
if(dolabels) {
  pair lmean = Scale((tmean, low) - ldx) + 0.75*S;
  pair lmedian = Scale((median, low) + ldx) + 1.0*S;
  pair lalpha = Scale((t[nlow], low) + ldx) + 1.25*S;
  pair lahpla = Scale((t[nhigh], low) + ldx) + 1.5*S;

  label("mean: "+ format("%5.2f", tmean), lmean, Align, red);
  draw(lmean--Scale((tmean, low)), red+dashed, EndArrow);

  label("median: "+ format("%5.2f", median), lmedian, Align, blue);
  draw(lmedian--Scale((median, low)), blue+dashed, EndArrow);
  
  label(format("%5.3f", 0.5 * alpha) + "\%: " + format("%5.2f", t[nlow]),
	lalpha + 0.1 * S, Align, blue);
  draw(lalpha--Scale((t[nlow], low)), blue+dashed, EndArrow);
  
  label(format("%5.3f", (1.0 - 0.5 * alpha)) + "\%: " + format("%5.2f", t[nhigh]),
	lahpla + 0.1 * S, Align, blue);
  draw(lahpla--Scale((t[nhigh], low)), blue+dashed, EndArrow);
  
}
