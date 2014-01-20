classdef KappaHelper
	methods(Static)
		%result has to be a pure Result object
		function votedResult=processVotes(result)
                        votedResult=Result([],[]);
                        counter=-result.predicted;
                        [~,votes]=max(counter,[],2);
			votedResult.expected=result.expected;
                        votedResult.predicted=votes;
		end
		function votes=processVotesArray(predicted)
                        [~,votes]=max(-predicted,[],2);
		end
		function votedResult=processByTrial(result,segLen)
			votes=[];
			vSeg=[0 0];
			nT=length(result.expected)/segLen;
			for trial=1:nT
				counter=[0 0];
				for seg=1:segLen
					tmpVotes=[];
					for k=1:max(result.expected)
					   counter(k)=counter(k)+result.predicted((seg-1)*nT+trial,k);
					   %counter(k)=counter(k)/abs(counter(k));
					end
					[~,class]=max(-counter);
					vSeg(trial,seg)=class;
				end
				[temp,class]=max(-counter);
				votes=[votes class];	
			
			end
			res=0;
			maxK=0;
			for seg=1:segLen
				k=Result(result.expected(1:nT),vSeg(:,seg)).getKappa;
				Logger.debug('Seg %i %0.5f',seg,k);
				if k>maxK
					maxK=k;
					res=Result(result.expected(1:nT),vSeg(:,seg));
				end
			end
			%votedResult=res;
			votedResult=Result(result.expected(1:nT),votes);
		end
		function mKappa=meanSimpleFolders(results)	
				mKappa=[];
				for r=results
					
					[kappa,acc]=KappaHelper.processVotes(r).getKappa;
					mKappa=[mKappa kappa];
				end
				mKappa=mean(mKappa);
			
		end

		function mKappa=meanFolders(appLevels,detLevels,results)	
				mKappa=0;
				for r=results
					
					[kappa,acc]=KappaHelper.getMajorityVoting(appLevels,detLevels,r);
					mKappa=mKappa+kappa/length(results);
				end
		end

		function [kappa,acc]=getMajorityVoting(levelsacc,levelsdetail,result)
			%to acculate lda outputs
			accResult=KappaHelper.getAccumulatedVotes(levelsacc,levelsdetail,result);
			votedResult=KappaHelper.processVotes(accResult);
			[kappa,acc]=votedResult.getKappa();
		end
		function [kappa,acc]=getWeightedVoting(appWeights,detWeights,result)
			%to acculate lda outputs
			accResult=KappaHelper.getWeightedVotes(appWeights,detWeights,result);
			votedResult=KappaHelper.processVotes(accResult);
			[kappa,acc]=votedResult.getKappa();
		end
		function result=getAccumulatedVotes(apps,dets,result)
			%to acculate lda outputs	
			majorityResult=EvaluatedResult(zeros(size(result.getResult(1,1).expected)),zeros(size(result.getResult(1,1).predicted)));
			majorityResult.aproxLevels=apps;
			majorityResult.detailLevels=dets;
			majorityResult.expected=result.getResultAnalysis(1).expected;
			for la=apps
				majorityResult.predicted=majorityResult.predicted+result.getResultAnalysis(la).predicted;
			end	
			for ld=dets;
				
				majorityResult.predicted=majorityResult.predicted+result.getResultDetails(ld).predicted;
			end
			result=majorityResult	;
		end
		function result=getWeightedVotes(accWeights,detWeights,result)
			%to acculate lda outputs	
			majorityResult=EvaluatedResult(zeros(size(result.getResult(1,1).expected)),zeros(size(result.getResult(1,1).predicted)));
			majorityResult.aproxLevels=1:length(accWeights);
			majorityResult.detailLevels=2:length(detWeights)+1;
			majorityResult.expected=result.getResultAnalysis(1).expected;
			for la=1:length(accWeights)
				majorityResult.predicted=majorityResult.predicted+result.getResultAnalysis(la).predicted*accWeights(la);
			end	
			for ld=1:length(detWeights);
				
				majorityResult.predicted=majorityResult.predicted+result.getResultDetails(ld+1).predicted*detWeights(ld);
			end
			result=majorityResult	;
		end
	end
end
