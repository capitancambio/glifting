classdef PatternProcessor<handle
        %Process the 
	properties
		next
	end

	methods 
		function [trainData,testData]=process(self,trainData,testData)
			[trainData,testData]=self.doProcess(trainData,testData);
			if ~isempty(self.next)
                                [trainData,testData]=self.next.process(trainData,testData);
			end
			%[trainData,testData]=self.postProcess(trainData,testData);
							
		end
		function next=setNext(self,nextProcessor)
			self.next=nextProcessor;
			next=self.next;
		end
	end	

	methods(Abstract)
		[trainData,testData]=doProcess(self,trainData,testData)

	end


end
