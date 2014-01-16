
classdef AdderProcessor < PatternProcessor
        %Dummy processor for testing purposes
	properties
	end

	methods
		function [train,test]=doProcess(~,trainData,testData)
                        train=Result(trainData.X+1,trainData.X+1);
                        test=[];
                        if ~isempty(testData)
                                test=Result(testData.X+1,testData.X+1);
                        end
				
		end

	end
				
end
