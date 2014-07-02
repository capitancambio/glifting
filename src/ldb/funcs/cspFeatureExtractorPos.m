function patterns=cspFeatureExtractorPos(p,X,Y,seg)
	newX=X(seg(1)-p.over:seg(2)+p.over,:,:);
	projM=cspProjMatrix(newX,Y);
	patterns=[];
	for trial=1:size(X,3)
		feature=cspFeature(projM,newX(:,:,trial),p.m);
		patterns=[patterns; feature'];
	end
	
	
end
