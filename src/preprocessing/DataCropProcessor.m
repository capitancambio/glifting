classdef DataCropProcessor < PreProcessor
	properties
		st
		en
	end



	methods 		
		function self=DataCropProcessor(st,en)
			self=self@PreProcessor();
			self.st=st;
			self.en=en;
		end
		function data=doProcess(self,data)
			Logger.debug('Size after %i %i %i',size(data.X));
			data.X=data.X(self.st:self.en,:,:);
			Logger.debug('Size before %i %i %i',size(data.X));
		end

	end

	
end
