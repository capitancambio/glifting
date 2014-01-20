classdef LiftingAnalysis < PatternProcessor
	
	properties
		lifting
		level
	end
	methods
		function self=LiftingAnalysis(lifting,toLevel)
			self.lifting=lifting;
			self.level=toLevel;
		end
		function [trData,tsData]=doProcess(self,trainData,testData)
			self.lifting.train=1;
			trData=self.analyse(trainData);%lifting.transform(trainData.X,self.level,trainData.Y);
			if isempty(testData)
				tsData=[];
			else
				self.lifting.train=0;
				tsData=self.analyse(testData);%lifting.transform(trainData.X,self.level,trainData.Y);
			end
		end

		function data=analyse(self,data)
			%st=cputime();

			[nData,~]=self.lifting.transform(data,self.level,data.Y);
			data=nData;
			%Logger.debug('applying wavelet analysis to the data set took %0.2f s',cputime()-st)
		end
        end

end
