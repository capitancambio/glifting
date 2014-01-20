classdef SplitProcessor < PatternProcessor
	properties
		trainPerc
	end
	methods
		function self=SplitProcessor(trainPerc)
			self=self@PatternProcessor();
			self.trainPerc=trainPerc;
		end
		function [train,test]=doProcess(self,data,~)
			nTrials=size(data.X,3);
			
			cut=ceil(nTrials*self.trainPerc);
			Logger.debug(' %i size data %i %i %i',cut,size(data.X))
			train=Data(data.X(:,:,1:cut),data.Y(1:cut));
			test=Data(data.X(:,:,cut:end),data.Y(cut:end));
			Logger.debug('size train %i %i %i',size(train.X))
		end
	end
end
