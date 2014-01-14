classdef InMemoryFoldCalculator < FoldCalculator

		properties
			nFolds
			folds
		end

		

		methods
			function self=InMemoryFoldCalculator(nfolds)  
%				self=self@FoldCalculator
				self.folds={};
				self.nFolds=nfolds;
			end
			function addFold(self,tr,ts,foldIdx)	
				self.folds{foldIdx,1}=tr;
				self.folds{foldIdx,2}=ts;
			end
			function [tr,ts]=getFold(self,data,fold,outOf)
				assert(self.nFolds==outOf);
				%Logger.debug('Accessing fold %i',fold)
				tr=self.folds{fold,1};
				ts=self.folds{fold,1};
			end
		end
	
end
