classdef PreProcessorWrapper < PatternProcessor
	properties
		preProcessor
	end
	methods
		function self=PreProcessorWrapper(preProcessor)
			self.preProcessor=preProcessor;
		end
		
		function [train,test]=doProcess(self,train,test)
			train=self.preProcessor.doProcess(train);
			if ~isempty(test)
				test=self.preProcessor.doProcess(test);
			end
		end
		
	end
end
