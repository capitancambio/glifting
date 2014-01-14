classdef ZeroCenterProcessor < PatternProcessor
	properties

	end
	methods
		function [train,test]=doProcess(~,train,test)
				mVal=mean(train.X(:));	
				train.X=train.X-mVal;
				if~isempty(test)
					test.X=test.X-mVal;
				end
		end
	end
end
