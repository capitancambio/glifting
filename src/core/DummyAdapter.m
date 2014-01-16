classdef DummyAdapter < Adapter
        %forwards the adaptation
	methods
		function self=DummyAdapter(other,patternProcessor)
			self=self@Adapter(other,patternProcessor);
			
		end
		function result=doAdapt(self,train,test)
			result = self.adaptee.adapt(train,test);

		end
	end
end
