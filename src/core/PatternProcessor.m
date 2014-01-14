classdef PatternProcessor<handle

	properties
		next
	end

	methods 
		function self=PatternProcessor()
			self.next=0;
		end
		function [trainData,testData]=process(self,trainData,testData)
			[trainData,testData]=self.doProcess(trainData,testData);
			if isa(self.next,'double')==0
				[trainData,testData]=self.next.process(trainData,testData);
			end
			[trainData,testData]=self.postProcess(trainData,testData);
							
		end
		function next=setNext(self,nextProcessor)
			self.next=nextProcessor;
			next=self.next;
		end
		function [trainData,testData]= postProcess(self,trainData,testData)
			
		end

	end	

	methods(Abstract)
		[trainData,testData]=doProcess(self,trainData,testData)

	end


end
