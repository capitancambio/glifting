classdef NFoldAdapter < PatternProcessor 
        %Multiplexes the execution flow into a cross validation
        %using the given number of folds
	properties
		folds
		adaptee
	end

	methods
		function self=NFoldAdapter(folds)
			self=self@PatternProcessor();
			self.folds=folds;
		end
		
		function [trRes,tsRes]=process(self,train,~)
			%ignoring test for folding
                        trRes=[];
                        tsRes=[];
			for f=1:self.folds 
				time=cputime();
				%Logger.info('Folder %i',f);
				[trainF,testF]=train.getFold(f,self.folds);
				[trainFR,testFR]=self.doProcess(trainF,testF);
				trRes=[trRes trainFR];%#ok
				tsRes=[tsRes testFR];%#ok
				Logger.info('Folder %i done in (%2.2f)',f,cputime()-time);
			end
				
		end
                function [train,test]=doProcess(self,train,test)
                        [train,test]=self.next.process(train,test);
                        
                end
	end
end
