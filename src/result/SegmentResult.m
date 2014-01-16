classdef SegmentResult < handle
	%TODO test
	properties
		results={}
		expected
	end
	methods
		function self=SegmentResult()
		end

		function self=addResult(self,result,segment)
				self.expected=result.expected;
				self.results{segment}=result;
		end

		function [result]=getResult(self,segment)
			result=self.results{segment};
		end

		function [sz]=size(self)
			sz=length(self.results);
		end
		

		function [merged]=mergeMetaClasses(self,results,expected)
			merged=SegmentResult();
			nSegs=self.size;
			%this should give always a round num other wise 
			%sth is wrong
			sExpected=expected(1:length(expected)/nSegs);
			for s=1:self.size()
				segs={};
				for i=1:length(results)
					%lol
					segs{i}=results{i}.results{s};
				end 
				merged.addResult(self.results{s}.mergeMetaClasses(segs,sExpected),s);
			end
		end
	end
end
