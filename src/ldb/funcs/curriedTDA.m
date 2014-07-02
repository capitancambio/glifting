function f=curriedTDA(p,X,Y,featureExtractor,discriminantCalculator)
	f=@(seg)trialsDiscriminantAdapter(p,X,Y,featureExtractor,discriminantCalculator,seg);
end
