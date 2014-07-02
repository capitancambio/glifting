function f=dist(X,Y)
[sampleNo, featureDim]=size(X);
nClasses=max(Y);
dist=[];
for class=1:nClasses
	indClass=find(Y==class);
	indNClass=find(Y~=class);
	x1=X(indClass,:);
	x2=X(indNClass,:);
	n1=size(x1,1);
	n2=size(x2,1);
	fc=abs(mean(x1)-mean(x2))*inv((n1*cov(x1)+n2*cov(x2))/(n1+n2));
%	cents=sqrt(sum((mean(X(indClass,:))-mean(X(indNClass,:))).^2));
%	stdev=mean(std(X(indClass,:),1).^2+std(X(indNClass,:),1).^2);
	dist=[dist mean(fc)];   
end
f=-1*mean(dist);




