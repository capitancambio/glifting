function patterns=lctFeatureExtractor(p,X,Y,seg)
	newX=X(seg(1)-p.over:seg(2)+p.over,:,:);
	patterns=[];
	chans=size(X,2);
	for trial=1:size(X,3)
		feature=[];
		for c=1:chans
			feature=[feature lct(newX(:,c,trial))];	
		end
		patterns=[patterns; feature];
	end
	
	
end
