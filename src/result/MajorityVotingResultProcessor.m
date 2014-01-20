
classdef MajorityVotingResultProcessor< PatternProcessor 
	properties 
		map
		cnf
		segs
		levels
		trainKappas=[];
                model
	end
	methods
		function self=MajorityVotingResultProcessor(cnf)
			self.cnf=cnf;

		end
		function [train,test]=doProcess(self,train,test)
                        result=JoinedResult(train,test);
			self.segs=result(1).train.size;
			self.levels=max(self.cnf.levels);
                        self.map=MatrixResultMap(result,self.segs,self.cnf.levels);
                        self.map.populate();
                        
                        self.all();

				
		end

		function [kappa,acc,testKappa,testAcc]=all(self)
		        	
			nlevels=max(self.cnf.levels)-min(self.cnf.levels)+1;
			[kappas,accs]=self.map.voteTrain(1:self.segs*nlevels*2);
			[testKappas,testAccs]=self.map.voteTest(1:self.segs*nlevels*2);
                        kappa=mean(kappas);
                        acc=mean(accs);
                        testKappa=mean(testKappas);
                        testAcc=mean(testAccs);
			Logger.info('all,%i,%f, %f,%f,%f\n',self.cnf.user,mean(acc),kappa,testAcc,testKappa);
			if isfield(self.cnf,'dontWrite')
				%do nothing
			else

				agg=ResultLineAggregator(self.cnf.resAggPath);
				agg.addLine(sprintf('%i,%s,%f,%f,%f,%f',self.cnf.user,self.cnf.prefix,acc,kappa,testAcc,testKappa));
				agg.close();
			end

		end

	end
end
