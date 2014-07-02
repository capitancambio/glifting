ser=3
xfile=sprintf('/home/javi/Dropbox/uni/src/matlab/csp/x%d.mat',user)
yfile=sprintf('/home/javi/Dropbox/uni/src/matlab/csp/y%d.mat',user)
xefile=sprintf('/home/javi/Dropbox/uni/src/matlab/csp/xe%d.mat',user)
yefile=sprintf('/home/javi/Dropbox/uni/src/matlab/csp/ye%d.mat',user)
load(xfile);
load(yfile);
load(xefile);
load(yefile);
featureExtractor=@cspFeatureExtractor
discriminantCalculator=@fisher
tdp=curriedTDA(x,y,featureExtractor,discriminantCalculator)
[s,d]=ldb(500,1700,31,tdp)



