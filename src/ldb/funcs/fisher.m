function f=fisher(X,Y)
[sampleNo, featureDim]=size(X);
nClasses=max(Y);

F=[];

for class=1:nClasses
	indClass=(Y==class);
	indNClass=(Y~=class);
	means=    sqrt(sum((mean(X(indClass))-mean(X(indNClass))).^2));
	stds=std(X(indClass)).^2+std(X(indNClass)).^2;
	F=[F mean(means./stds)];
end

f=mean(F);





