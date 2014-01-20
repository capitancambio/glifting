classdef GenericJob < Job
	
	properties
		processor
	end

	methods
		function self=GenericJob(desc,processor)
			self=self@Job(desc);
			self.processor=processor;
		end
		function run(self)
			self.processor.process([],[]);
		end
	end
end
