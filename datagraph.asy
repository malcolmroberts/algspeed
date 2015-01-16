import graph;
import utils;

//asy datagraphs -u "xlabel=\"\$\\bm{u}\cdot\\bm{B}/uB$\"" -u "doyticks=false" -u "ylabel=\"\"" -u "legendlist=\"a,b\""

texpreamble("\usepackage{bm}");

size(200,150,IgnoreAspect);

//scale(Linear,Linear);
scale(Log,Linear);

bool dolegend=true;

string filenames=getstring("filenames");
string filename;
string legendlist="";
int n=-1;
bool flag=true;
int lastpos;

bool doxticks=true;
bool doyticks=true;
string xlabel="$x$";
string ylabel="$y$";

usersetting();
bool myleg=((legendlist == "") ? false: true);
string[] legends=set_legends(legendlist);

bool errorbars = false;

while(flag) {
  ++n;
  int pos = find(filenames,",",lastpos);
  if(lastpos == -1) {filename = ""; flag = false;}
  filename = substr(filenames,lastpos,pos-lastpos);

  pen p = Pen(n);
  if(n == 1) p += dashed;
  if(n == 2) p = darkgreen + Dotted;
  
  if(flag) {
    lastpos = pos > 0 ? pos+1 : -1;
   
    file fin = input(filename).line();
    real[][] a = fin.dimension(0,0);
    
    a = transpose(a);
    real[] x = a[0];
    real[] y = a[1];

    if(a.length == 4) {
      real[] ly = a[2];
      real[] hy = a[3];
      errorbars(x, y, 0*x,hy, 0*x, ly, Pen(n));
    }
    draw(graph(x, y), p, myleg ? legends[n] : texify(filename));
  }
}

if(doxticks)
  xaxis(xlabel,BottomTop,LeftTicks);
else
  xaxis(xlabel);
if(doyticks)
  yaxis(ylabel,LeftRight,RightTicks);
else
  yaxis(ylabel,LeftRight);

//if(dolegend) attach(legend(),point(plain.E),20plain.E);
