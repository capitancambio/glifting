classdef Data < handle

	properties
		X=[];
		Y=[];
		foldCalculator=TrialFoldCalculator();
		meta;
	end

	methods
		function self=Data(X,Y)
			self.X=X;
			self.Y=Y;
			self.meta=struct;
			%self.meta.segs=SegmentDescriptor();	

		end
		
		function [data]=clone(self)
			data=Data(self.X,self.Y);
			data.meta=self.meta;
			data.foldCalculator=self.foldCalculator;
		end
		

		function self=getRidOf(self,classes)
			for class=classes
				Logger.debug(sprintf('getting rid of %i',class))
				idx=(self.Y~=class);
				self.Y=self.Y(idx);
				self.X=self.X(:,:,idx);
				Logger.debug(sprintf('size y: %i',size(self.Y,2)))
			end
		end

		function data=getClass(self,clazz)
			trs=self.Y==clazz;
			data=Data(self.X(:,:,trs),self.Y(trs));
				
		end
		
		function data=metaClass(self,clazz)
			data=self.clone();
			%everything but clazz is labeled as 2, and clazz 1
			idx=data.Y==clazz;
			data.Y(idx)=1;
			data.Y(~idx)=2;
		end
		

		function [cnt]=trials(self)
			cnt=size(self.X,ndims(self.X));	
		end
		
		function [cnt]=channels(self)
			cnt=size(self.X,2);	
		end

		function [cnt]=samples(self)
			cnt=size(self.X,1);	
		end

		function [t]=trial(self,idx)
			% t 
			% inputs: self,idx
			% outputs: trial
			t=self.X(:,:,idx);
			
		end

		function self=delete(self)
			Logger.debug('deleting data');
			clearvars self.X;
			clearvars self.Y;
			self.X=[];
			self.Y=[];
			self.foldCalculator=[];
		end

		function data=slice(self,slice)
			data=Data(self.X(slice,:,:),self.Y);
		end


		function data=getTrialRange(self,trials)
			if ndims(self.X)==3
				data=Data(self.X(:,:,trials(1):trials(2)),self.Y(trials(1):trials(2)));
			else
				data=Data(self.X(:,trials(1):trials(2)),self.Y(trials(1):trials(2)));
			end

		end

		function [train,test]=getFold(self,fold,outOf)
			[train,test]=self.foldCalculator.getFold(self,fold,outOf);
		end
		function [train,test]=calculateFold(self,fold,outOf)
			trialCnt=max(size(self.Y));
			foldLen=floor(trialCnt/outOf);
		 	st=((fold-1)*foldLen);
		        en=foldLen*fold;
			if fold==outOf
				en=trialCnt;
			end
			trIdx=[1:st en+1:trialCnt];
			tsIdx=st+1:en;
			if max(size(size(self.X)))==3
				train=Data(self.X(:,:,trIdx),self.Y(trIdx));
				test=Data(self.X(:,:,tsIdx),self.Y(tsIdx));
			else
				train=Data(self.X(:,trIdx),self.Y(trIdx));
				test=Data(self.X(:,tsIdx),self.Y(tsIdx));
			end
		end

		function idx=merge(self,other)
			idx=[size(self.X,ndims(self.X))+1,size(self.X,ndims(self.X))+size(other.X,ndims(self.X))];
			%dim should be 3!
			self.X=cat(ndims(self.X),self.X,other.X);
			self.Y=[self.Y ; other.Y];
		end
		function toOldFashionFile(self,pathx,pathy,val)

			Logger.debug('X %i %i %i',size(self.X))
			Logger.debug('Y %i ',size(self.Y))
			if val==1
				xe=self.X;
				ye=self.Y;
				save(FSUtils.checkPath( pathx ),'xe')
				save(FSUtils.checkPath( pathy ),'ye')
			else
				x=self.X;
				y=self.Y;
				save(FSUtils.checkPath( pathx ),'x')
				save(FSUtils.checkPath( pathy ),'y')
			end
		end
		
	end
end	
