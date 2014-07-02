function img=plotseg(data)


	st=500-1;
	ed=1750;


	img=zeros(22,ed-st);
	for feat=1:1
	
		all=zeros(1,ed-st);
		i=0;
		for seg=data.feat{feat}.segs'
			seg(1)-st
			seg(2)-st
			chans=getChannels(feat,i+1,data)
			img(chans(1),seg(1)-st:seg(2)-st)=length(data.feat{feat}.segs)-i;
			img(chans(2),seg(1)-st:seg(2)-st)=length(data.feat{feat}.segs)-i;
			i=i+1;
		end
	
	end

	imagesc(img);
end
function pos=getChannels(feat,segNum,data)
	pattern(:,:)=data.feat{feat}.projM{segNum}(:,:,1);
	pattern=inv(pattern)';

	[v,pos1]=max(pattern(1,:));
	[v,pos2]=max(pattern(end,:));
	pos=[pos1 pos2]

end
