classdef SegmentDescriptor < handle
	properties
		segments={}
	end
	methods
		function self=SegmentDescriptor()
			
		end

		function [self]=addSegment(self,segment)
			Logger.debug('Adding Segment %i,%i',segment);
			self.segments{end+1}=segment;
		end
		
		function [segment]=getSegment(self,idx)
			segment=self.segments{idx};
		end

		function sz=size(self)
			sz=length(self.segments);
		end
		function retval=cnt(self)
			retval=length(self.segments);
		end
	end
end
