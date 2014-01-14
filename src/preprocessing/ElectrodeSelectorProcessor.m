classdef ElectrodeSelectorProcessor  < PreProcessor
	properties
		electrodes
	end



	methods 		
		function self=ElectrodeSelectorProcessor(electrodes)
			self=self@PreProcessor();
			self.electrodes=electrodes;
	
		end
		function data=doProcess(self,data)
			Logger.debug('Size after %i %i %i',size(data.X));
			data.X=data.X(:,self.electrodes,:);
			Logger.debug('Size before %i %i %i',size(data.X));
		end

	end

	
end
