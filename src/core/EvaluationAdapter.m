classdef EvaluationAdapter < PatternProcessor 
        properties
                classifierProvider
        end

	methods
		function self=EvaluationAdapter(classifierProvider)
			self=self@PatternProcessor();
                        self.classifierProvider=classifierProvider;
		end
		
		function [trainRes,testRes]=process(self,train,test)
			classifier=self.classifierProvider.new();
			classifier.train(train);
			trainRes=classifier.test(train);	
			%trainRes.originalData=train;
			testRes=Result([],[]);
			if ~isempty(test)
				testRes=classifier.test(test);
			end
			%result.originalData=test;
			%result=JoinedResult(trainRes.normalise,result.normalise);
                        self.doProcess(trainRes,testRes);
		end	

                function [train,test]=doProcess(self,train,test)
                        if ~isempty(self.next)
                                [train,test]=self.next.process(train,test);
                        end
                end
	end


end
