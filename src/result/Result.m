classdef Result < handle
	properties
		predicted
		originalData
		expected
		confusion=[];
		originalOuts=[];
		meta=MagicClass();
	
	end

	methods 
		function self=Result(expected,prediction)
			self.predicted=prediction;
			self.expected=expected;
		end

		function [result]=getTrialRange(self,range)
			r=range(1):range(2);
			result=Result(self.expected(r),self.predicted(r,:));
		end

		function [self]=normalise(self)
			if ~isempty(self.predicted)
				maxV=max(self.predicted);	
				minV=min(self.predicted);	
				fact=(maxV-minV);
				self.predicted=bsxfun(@minus,self.predicted,min(self.predicted));
				self.predicted=bsxfun(@rdivide,self.predicted,fact);
				self.predicted=self.predicted*2-1;
			end
		end
		

		%function confusion=calculateConfusion(self)
			%%Y=self.predicted;
			%%Ye=self.expected;
                         %%a,a is the number of hits
                        %%Ye==i positions where class is i
                         %%then check where are the positions ok in the expected vector
                        %%H(classCnt,classCnt)=(Y(Ye==i)==i)
                        %%moreefficient
			%%H=zeros(classCnt,classCnt);
                        %%for i=1:classCnt
                                %%Yei=Ye==i;
                                %%for j=1:classCnt

                                        %%H(i,j)=sum(Y(Yei)==j);
                                %%end
                        %%end
                        %%H
                        %%pause

			%%confusion=H;
		%end
		function [kappa,acc]=getKappa(self)
			if size(self.confusion,1)==0
				%self.confusion=self.calculateConfusion();
			        classCnt=max(self.expected);
                                self.confusion=accumarray([self.expected,self.predicted],ones(length(self.expected),1),[classCnt,classCnt]);
			end

			[kappa,acc]=kappa1(self.confusion);
		end
		%this method maybe static but its more handy like this
		function [merged]=mergeMetaClasses(~,results,expected)
			%self 2 class result that we will merge with the others	
			
			nClasses=length(results);
			merged=Result(expected,zeros(length(expected),nClasses));

			for c=1:nClasses
				merged.predicted(:,c)=results{c}.predicted(:,1);	
			end
		end
		
	end
end



