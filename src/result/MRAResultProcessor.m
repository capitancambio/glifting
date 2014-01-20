classdef MRAResultProcessor < PreProcessor
	properties 
		cnf
	end


	methods(Static)
		%function [kappaLevelA,accLevelA,kappaLevelD,accLevelD,kappaMajority,accMajority]=getKappas(result)
		function [majorityResult,kappaLevel,resultLevel]=getKappas(result,anal,detal)
			kappaLevel=cell(2,11);
			resultLevel=cell(2,11);
			for i=anal
				kappaLevel{1,i}=-10;
				kappaLevel{2,i}=-10;
			end
			%using this to sum all the results
			majorityResult=Result(zeros(size(result.getResult(result.levels(1),2).expected)),zeros(size(result.getResult(result.levels(1),2).predicted)));
			%mayorityMode=[];
			%per level
			%
			for i=anal
				votedResult=MRAResultProcessor.processVotes(result.getResultAnalysis(i));
				[kappa,acc]=votedResult.getKappa();
				kappaLevel{1,i}=kappa;
				resultLevel{1,i}=result.getResultAnalysis(i);
				%mayorityMode=[mayorityMode;votedResult.predicted];
				Logger.debug('Level %i %s %0.2f acc %0.2f',i,'aprox',kappa,acc);
				majorityResult.expected=result.results{i,1}.expected;
				majorityResult.predicted=majorityResult.predicted+result.results{i}.predicted;

				votedResult=MRAResultProcessor.processVotes(result.getResultDetails(i));
				[kappa,acc]=votedResult.getKappa();
				kappaLevel{2,i}=kappa;
				resultLevel{2,i}=result.getResultDetails(i);
				Logger.debug('Level %i %s %0.2f acc %0.2f',i,'detail',kappa,acc);
				majorityResult.expected=result.results{i,2}.expected;
				majorityResult.predicted=majorityResult.predicted+result.results{i,2}.predicted;
				%mayorityMode=[mayorityMode;votedResult.predicted];
			end
			%majorityResult.predicted=majorityResult.predicted/abs(majorityResult.predicted);
			pres=MRAResultProcessor.processVotes(majorityResult);
			[kappaMajority,accMajority]=pres.getKappa();
			%modeRes=Result(pres.expected,mode(mayorityMode));
			Logger.debug('Kappa majority %0.2f acc %0.2f',kappaMajority,accMajority);
			%[kappaMajority,accMajority]=modeRes.getKappa();
			%Logger.debug('Kappa mode %0.2f acc %0.2f',kappaMajority,accMajority);
			%majorityResult=modeRes;

		end
		function presult=processVotes(result)
			votes=zeros(size(result.expected));
			for pat=1:length(result.expected)
				counter=zeros(1,max(result.expected));
				for k=1:max(result.expected)
			           counter(k)=result.predicted(pat,k);
				end
    				[~,class]=max(-counter);
				votes(pat)= class;	
			end
			presult=Result(result.expected,votes);
		end

	end
	methods

		function self=MRAResultProcessor(cnf)
			self.cnf=cnf;
		end

	

		function result=doProcess(self,jresult)
			%train
			%[kappaLevelA,accLevelA,kappaLevelD,accLevelD,kappaMajority,accMajority]=MRAResultProcessor.getKappas(result);
			[majresTrain,bestKappas]=MRAResultProcessor.getKappas(jresult,[1:11]);
			majresTrain.meta.bestKappas=bestKappas;
			result=majresTrain;
		end
		function [kappa,resultLevel,kappasLevel]=doProcessFilter(self,jresult,anal,detal)
			%train
			%[kappaLevelA,accLevelA,kappaLevelD,accLevelD,kappaMajority,accMajority]=MRAResultProcessor.getKappas(result);
			[majresTrain,bestKappas,resultLevel]=MRAResultProcessor.getKappas(jresult,anal,detal);
			majresTrain.meta.bestKappas=bestKappas;
			majresTrain.meta.resultLevel=resultLevel;
			kappasLevel=bestKappas;
			result=majresTrain;
			kappa=majresTrain;
		end

		function str=toStr(self,kappaLevelA,accLevelA,kappaLevelD,accLevelD,kappaMajority,accMajority)
			eType='eval';
			strAccsA=sprintf('%0.8f,',accLevelA{:});
			strKappasA=sprintf('%0.8f,',kappaLevelA{:});
			strAccsD=sprintf('%0.8f,',accLevelD{:});
			strKappasD=sprintf('%0.8f,',kappaLevelD{:});
			str=sprintf('%s,%i,%s,%i,%i,%s,%s %s %s %s',self.cnf.prefix,self.cnf.user,self.cnf.w_name,self.cnf.level,self.cnf.cspFeatures,eType,strAccsA,strKappasA,strAccsD,strKappasD);
			str=sprintf('%s%0.8f,%0.8f',str,accMajority,kappaMajority);
		end
	end
	
end
