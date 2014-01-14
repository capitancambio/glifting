classdef PreProcessor<handle

	properties
		next
	end

	methods 
		function self=PreProcessor()
			self.next=0;
		end
		function self=setConf(self,conf)
			self.conf=conf;
		end
		function data=process(self,data)
			data=self.doProcess(data);
			if self.next ~= 0
				data=self.next.process(data);
			end
							
		end
		function next=setNext(self,nextProcessor)
			
			self.next=nextProcessor;
			next=self.next;
			Logger.debug('Next  %s',class(self.next));
		end

	end	

	methods(Abstract)
		data=doProcess(self,data)
	end


end
