classdef TrialFoldCalculator < FoldCalculator

		methods
			function [tr,ts]=getFold(self,datao,fold,outOf)
				[tr,ts]=datao.calculateFold(fold,outOf);
			end
		end
	
end
