classdef SegmentAdapter < PatternProcessor
        %multiplexes the execution along the different segments
        %the train and test elements must be SegmentedData objects

	methods
		function [trRes,testRes]=process(self,train,test)

			trRes=SegmentResult();
                        if~isempty(test)
                                testRes=SegmentResult();
                        else
                                testRes=[];
                        end
                        

			for l=1:train.size()
                                t=cputime;
				Logger.info(' segment %i ',l)
				tr=train.getSegment(l);

                                if~isempty(test)
                                        ts=test.getSegment(l);
                                else
                                        ts=[];
                                end

                                [segTrain,segTest]=self.doProcess(tr,ts);
				trRes.addResult(segTrain,l);
                                if~isempty(test)
                                        testRes.addResult(segTest,l);
                                end
				Logger.info(' segment %i took %f',l,cputime-t)
			end
                        %make sure to return an empty object
		end

                function [train,test]=doProcess(self,train,test)
                        
                        [train,test]=self.next.process(train,test);
                        
                end
	end
	
end
