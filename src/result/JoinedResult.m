classdef JoinedResult<handle
	properties
		train
		test
	end
	methods
		function self=JoinedResult(train,test)
			self.train=train;
			self.test=test;
		end
	end
end
