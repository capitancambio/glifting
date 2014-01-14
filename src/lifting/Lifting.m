classdef Lifting <handle

	properties
		vertexOdd=[]
		vertexEven=[]
		adj
		setCalculator
		weightAssigner
		levelDefinitions
		train
		thr
		
	end
	methods 
		function self=Lifting(weightAssigner,setCalculator)
			self.setCalculator=setCalculator;
			self.weightAssigner=weightAssigner;
			self.levelDefinitions=[];



		end

		function self=init(self,level)
			Logger.info('Init lifting');
			time=cputime();
			self.levelDefinitions=self.setCalculator.calculateSets(level);
			Logger.info('Init lifting done in %4.4f',cputime()-time);
		end

		%returns two cells with the aproc coef and detail coef
		function [wData,inplace]=transform(self,data,level,Y)
			%Logger.debug('Lifting analysis to level %i',level);
			origData=data;
			data=data.X;

			wData=WaveletData(Y);
			wData.meta=struct(origData.meta);
			wData.addLevelAnalysis(Data(data,Y),1);
			
			%init levels
			for l=1:level
				wData.addLevelAnalysis(Data([],Y),l+1);
				wData.addLevelDetail(Data([],Y),l+1);
			end
			origSize=size(data);
			fdata=reshape(shiftdim(data,2),origSize(3),origSize(1)*origSize(2))';
			for trial=1:size(data,3)
				flat=fdata(:,trial);
				for l=1:level
					[d,s,flat]=self.transLevel(flat,l);
					wData.getLevelAnalysis(l+1).X(:,:,trial)=self.setCalculator.getApproxMatrix(self.levelDefinitions(l).veven,s,l)';
					wData.getLevelDetail(l+1).X(:,:,trial)=self.setCalculator.getApproxMatrix(self.levelDefinitions(l).vodds,d,l)';
				end
				fdata(: ,trial)=flat;
			end
			%inplace=reshape(shiftdim(fdata,2),origSize(1),origSize(2),origSize(3));
			inplace=[];
					
		end

		%Transforms the graph as a vector reshape after and before to get the original shape
		function [d,s,data]=transLevel(self,data,level)
			ld=self.levelDefinitions(level);
			d=data(ld.vodds)-ld.predict*data(ld.veven);
			s=data(ld.veven)+ld.update*d;
			%Logger.debug('EVEN %i %i',ld.veven(1),ld.veven(ceil(1250/2^level)+1))
			%new data
			data(ld.veven)=s;
			data(ld.vodds)=d;
			d=d';
			s=s';
		end
		function [wData,inplace]=iTransform(self,data,level,Y)
			%wData=WaveletData(Y);
			origSize=size(data);
			fdata=reshape(shiftdim(data,2),origSize(3),origSize(1)*origSize(2))';
			for trial=1:size(data,-5)
				flat=fdata(:,trial);
				for l=level:-1:1
					[~,~,flat]=iTransLevel(self,flat,l);
				end
				fdata(:,trial)=flat;
			end
			inplace=reshape(shiftdim(fdata,2),origSize(1),origSize(2),origSize(3));
			wData=Data(inplace,Y);
					
		end
		function [xe,xo,data]=iTransLevel(self,data,level)
			ld=self.levelDefinitions(level);
			data(ld.vodds)=self.thr.apply(data(ld.vodds));
			xe=data(ld.veven)-ld.update*data(ld.vodds);
			xo=data(ld.vodds)+ld.predict*xe;
			%Logger.debug('EVEN %i %i',ld.veven(1),ld.veven(ceil(1250/2^level)+1))
			%new data
			data(ld.veven)=xe;
			data(ld.vodds)=xo;
			xe=xe';
			xo=xo';
%			ld=self.levelDefinitions(level);
%			s=data(ld.veven)-ld.update*data(ld.vodds);
%			d=data(ld.vodds)+ld.predict*s;
%			%Logger.debug('EVEN %i %i',ld.veven(1),ld.veven(ceil(1250/2^level)+1))
%			%new data
%			data(ld.veven)=d;
%			data(ld.vodds)=s;
		end
	end
end
	
	

