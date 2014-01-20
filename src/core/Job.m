classdef Job

	properties(SetAccess=protected)
		toDelete
		desc
	end	

	methods(Abstract=true)
		self=run(self) 
	end

	methods
		function self=Job(desc)
			self.toDelete=[];
			self.desc=desc;
		end
		function self=delete(self)
			for obj=toDelete
				obj.delete()
			end
		end
	end

end
