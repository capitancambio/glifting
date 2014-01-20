classdef MulticlassAdapter < PatternProcessor 
	%results for class vs metaclass ie [ 1 2 2 3 3] is transformed to 1 vs (2 3) [ 1 2 2 2 2]
	methods
		function [trRes,tsRes]=process(self,train,test)
			classes=1:max(train.Y);
			tr=cell(1,max(classes));
			ts=cell(1,max(classes));
			metaTest=[];
			%time=cputime;
			%times=[];
                        %get meta classes and process
			for cl=classes
				%tx=cputime;
				metaTrain=train.metaClass(cl);	
				if ~isempty(test)
					metaTest=test.metaClass(cl);	
				end
				[cTrain,cTest]=self.doProcess(metaTrain,metaTest);
                                tr{cl}=cTrain;
                                ts{cl}=cTest;
				%times=[times cputime-tx];
			end
			trRes=tr{1}.mergeMetaClasses(tr,train.Y);
			tsRes=[];
			if ~isempty(test)
				tsRes=ts{1}.mergeMetaClasses(ts,test.Y);
			end
			%trRes.originalData=train;
			%tsRes.originalData=test;
		end

                function [train,test]=doProcess(self,train,test)
                        [train,test]=self.next.process(train,test);
                        
                end
		
	end
end
