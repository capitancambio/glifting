classdef MRAResult < handle
	%TODO test
	properties
		results={}
		levels
		meta=MagicClass();
		expected
	end
	methods
		function self=MRAResult(levels)
			self.levels=levels;
			self.expected=[];
		end
		function result=getTrialRange(self,range)
			result=MRAResult(self.levels);
			for l=self.levels
				result.results{l,1}=self.results{l,1}.getTrialRange(range);	
				result.results{l,2}=self.results{l,2}.getTrialRange(range);	
				result.expected=result.results{l,2}.expected;
			end
		end
		function addResultDetail(self,result,level)
			self.expected=result.expected;
			self.results{level,2}=result;
		end
		function addResultAnalysis(self,result,level)
				self.results{level,1}=result;
		end
		function addResult(self,result,level,node)
			if level~=1
				self.results{level,node}=result;
			end
		end
		function res=getResultAnalysis(self,level)
			res=self.results{level,1};
		end
		function res=getResultDetails(self,level)
			if level~=1
				res=self.results{level,2};
			else
				res=self.results{level,1};
			end
		end
		function res=getResult(self,level,node)
			res=self.results{level,node};
		end

		function [merged]=mergeMetaClasses(self,results,expected)
			merged=MRAResult(self.levels);
			merged.meta=self.meta;
			for l=self.levels
				for j=1:2
					levs={};
					for i=1:length(results)
						%lol
						levs{i}=results{i}.results{l,j};
					end 
					merged.results{l,j}=self.results{l,j}.mergeMetaClasses(levs,expected);
				end
			end
		end
	end
end
