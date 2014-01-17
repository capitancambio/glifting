
classdef AdderProcessor < PatternProcessor
        %Dummy processor for testing purposes
	properties
	end

	methods
		function [train,test]=doProcess(~,trainData,testData)
                        train=Result(trainData.X+1,trainData.Y);
                        test=[];
                        if ~isempty(testData)
                                test=Result(testData.X+1,testData.Y);
                        end
				
		end

	end
				
end
