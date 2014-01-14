classdef DataReaderProcessor< PatternProcessor
	properties
		trainReader
		testReader
	end

	methods
		function [self]=DataReaderProcessor(trainReader,testReader)
			self.trainReader=trainReader;
			self.testReader=testReader;
		end
		
		%From segments to trials
		function [tr,ts]=doProcess(self,~,~)
			tr=self.trainReader.get();
			ts=[];
			if ~isempty(self.testReader)
				ts=self.testReader.get();
			end
		end

	end
				
end
