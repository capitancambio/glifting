classdef WaveletData<Data
	properties
		%one data obj inside every level
		levelsAnalysis={}
		levelsDetail={}
		levelIdx=[]
		processor
	end

	methods
		function self=WaveletData(Y)
	                self=self@Data([],Y);
			self.foldCalculator=TrialFoldCalculator();
			self.meta.segs=SegmentDescriptor();
		end

		
		function self=delete(self)
			Logger.info('deleting wavelet data');
			self.levelsAnalysis=[];
			self.levelsDetail=[];
			
		end
		function toFile(self,path)
			Logger.info(sprintf('write wavelet data to file %s',path));
			data.Y=self.Y;
			data.levelsDetail=self.levelsDetail;
			data.levelsAnalysis=self.levelsAnalysis;
			data.levelIdx=self.levelIdx;
			data.foldCalculator=self.foldCalculator;%#ok
			save(FSUtils.checkPath( path ),'data');
		end
		function [data]=getLevelDetail(self,level)
			if level==1
				% 0,0 is equal
				data=self.levelsAnalysis{level};
			else
				data=self.levelsDetail{level};
			end
			data.Y=self.Y;
		end
		function [data]=getLevelAnalysis(self,level)
			data=self.levelsAnalysis{level};
			data.Y=self.Y;
		end

		function [self]=addLevelAnalysis(self,data,level)
			data.meta=struct(self.meta);
			data.meta.level=[1,level];
			self.levelsAnalysis{level}=data;
			self.levelIdx=[self.levelIdx level];
			%self.levelIdx=unique(self.levelIdx);
		end
		function [self]=addLevelDetail(self,data,level)
			if level~=1
				%data.Y=self.Y;
				data.meta=struct(self.meta);
				data.meta.level=[2,level];
				self.levelsDetail{level}=data;
				%self.levelIdx=[self.levelIdx level];
				%self.levelIdx=unique(self.levelIdx);
			end
		end
		function [levels]=getLevels(self)
			levels=self.levelIdx;
		end

%		function [train,test]=getFold(self,fold,outOf)
%			[train,test]=self.foldCalculator.getFold(self,fold,outOf);
%		end	
		function [train,test]=calculateFold(self,fold,outOf)
			train=WaveletData([]);
			test=WaveletData([]);
			for l=self.levelIdx
				data=self.getLevelDetail(l);
				Logger.debug('size! data %i %i %i',size(data.X))
				Logger.debug('size! Y %i %i',size(data.Y))
				[t,ts]=data.getFold(fold,outOf);
				Logger.debug('tr! data %i %i %i',size(t.X))
				Logger.debug('ts! data %i %i %i',size(ts.X))
				train.Y=t.Y;
				train.addLevelDetail(t,l);
				test.Y=ts.Y;
				test.addLevelDetail(ts,l);
				data=self.getLevelAnalysis(l);
				[t,ts]=data.getFold(fold,outOf);
				train.Y=t.Y;
				train.addLevelAnalysis(t,l);
				test.Y=ts.Y;
				test.addLevelAnalysis(ts,l);
			end
		end
		function self=filterLevels(self,app,det)
			for l=self.levelIdx
				if sum(app==l)==0
					self.levelsAnalysis{l}=Data([],[]);
				end
				if sum(det==l)==0
					self.levelsDetail{l}=Data([],[]);
				end
			end	
			if isa(self.foldCalculator,'TrialFoldCalculator')==0
				Logger.debug('Filtering levels')
				for f=1:self.foldCalculator.nFolds
					[tr,ts]=self.getFold(f,self.foldCalculator.nFolds);
					self.foldCalculator.addFold(tr.filterLevels(app,det),ts.filterLevels(app,det),f);
				end
			end
		end

		function self=merge(self,other)
			%TODO FIX THE Y PROBLEM, BETTER, REWRITE THE WHOLE DATA STUFF TO GET SOMETHING MORE EFFICIENT...
			if min(size(self.Y))==0
				self.Y=self.levelsAnalysis{2}.Y;
			end
			Logger.debug('Size before merge Y %i %i X %i %i %i',size(self.Y),size(self.levelsAnalysis{2}.X));
			self.Y=[self.Y;other.levelsAnalysis{2}.Y];
			for l=self.levelIdx
				if l~=1
					self.getLevelAnalysis(l).merge(other.getLevelAnalysis(l));
					self.getLevelDetail(l).merge(other.getLevelDetail(l));
				end

			end
			Logger.debug('Size after merge Y %i %i X %i %i %i',size(self.Y),size(self.levelsAnalysis{2}.X));
		end	
	end

	 methods(Static)
		function [wData]= fromFile(path)
			wData=WaveletData([]);
			Logger.info(sprintf('reading wavelet data from file %s',path));
			%MARK DATA
			data=FSUtils.load(path);
			data=data.data;
			wData.Y=data.Y;
			wData.levelsDetail=data.levelsDetail;
			wData.levelsAnalysis=data.levelsAnalysis;
			wData.levelIdx=data.levelIdx;
			if ismember('foldCalculator',fieldnames(data))
				wData.foldCalculator=data.foldCalculator;
			else
				wData.foldCalculator=TrialFoldCalculator();
			end
		end	
    	end

end
