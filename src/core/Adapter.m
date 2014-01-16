classdef Adapter < handle
        %changes the tranformation flow by applying different strategies such
        %as crossvalidations, processing of different segments, mra, etc.
        %before data it can exectute a processing chain
	properties
		adptee
		patternProcessor
	end

	methods
		function self=Adapter(adptee,patternProcessor)
			self.adptee=adptee;
			self.patternProcessor=patternProcessor;
		end
	end	

	methods(Abstract)
		[train,test]=doAdapt(self,train,test);
	end

        methods (Access=public)
                function [train,test]=adapt(train,test)
			if ~isempty(self.patternProcessor) 
				[train,test]=self.patternProcessor.process(train,test);
			end
                        [train,test]= self.doAdapt(train,test);

                end

        end

end
