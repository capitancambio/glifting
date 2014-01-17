classdef Classifier < handle
	
	methods(Abstract)
		result=train(self,data)
		result=test(self,data)
	end
	
end



