classdef LevelDefinition < handle
	properties
		vodds
		veven
		predict
		update
		
	end
	methods
		function [other]=clone(self)
			other=LevelDefinition();
			other.vodds=self.vodds;
			other.veven   = self.veven;
			other.predict = self.predict;
			other.update  = self.update;
		end
		
	end
	
end
