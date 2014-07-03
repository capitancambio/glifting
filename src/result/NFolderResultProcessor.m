classdef NFolderResultProcessor< PatternProcessor 
	
	properties 
		cnf
	end

	methods
		function self=NFolderResultProcessor(cnf)
			self.cnf=cnf;
		end
		%here i'm expecting an array of results (one per folder...)
		function [train,test]=process(self,train,test)
			self.cnf.dontWrite=1;
			meanKappa=[];
			meanAcc=[];
			meanTestAcc=[];
			meanTestKappa=[];
			agg=ResultLineAggregator(self.cnf.resAggPath);
			for r=1:length(train)
				[votedTrain,votedTest]=self.doProcess(train(r),test(r));
				meanKappa=[meanKappa votedTrain.kappa];%#ok +kappa/length(results);
				meanAcc=[meanAcc votedTrain.acc];%#ok length(results);
				meanTestKappa=[meanTestKappa votedTest.kappa];%#ok /length(results);
				meanTestAcc=[meanTestAcc votedTest.acc];%#ok /length(results);

			end	
			agg.close();
			agg=ResultLineAggregator(self.cnf.resAggPath);
			agg.addLine(sprintf('%i,%i,%0.2f,%s,%f,%f,%f,%f',self.cnf.user,self.cnf.feats,self.cnf.thres,self.cnf.prefix,median(meanAcc),median(meanKappa),median(meanTestAcc),median(meanTestKappa)))
			agg.close();
		end

                function [train,test]=doProcess(self,train,test)
                        [train,test]=self.next.process(train,test);
                        
                end


	end

end
