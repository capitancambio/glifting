classdef SegmentFilterProcessor < PatternProcessor
	properties
		ignoreList	
	end



	methods
		function self=SegmentFilterProcessor(ignoreList)
			self.ignoreList=ignoreList;
		end
		%From segments to trials
		function [tr,ts]=doProcess(self,tr,ts)
			Logger.debug('segments to trial');
			tr.deleteSegments(self.ignoreList);
			ts.deleteSegments(self.ignoreList);
			
		end

	end
				
end
