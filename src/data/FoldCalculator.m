classdef FoldCalculator < handle


		

		methods (Abstract=true)
			[train,test]=getFold(self,data,fold,outOf)
		end
	
end
