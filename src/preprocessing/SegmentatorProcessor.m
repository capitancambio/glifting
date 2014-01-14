classdef SegmentatorProcessor < PreProcessor
	properties
		len
		overlap
	end



	methods 		
		function self=SegmentatorProcessor(len,overlap)
			self=self@PreProcessor();
			self.len=len;
			self.overlap=overlap;
	
		end
		function sdata=doProcess(self,data)
			sdata=SegmentedData();
			dLen=size(data.X,1);
			trials=size(data.X,3);
			sgCnt=1;
			%Logger.debug('Segmenting data...');
			for st=1:self.overlap:(dLen-self.len)
				%Logger.debug('Len %i max seg %i', dLen,dLen-self.len)
				sdata.addSegment(sgCnt,data.slice(st:st+self.len-1));
				sgCnt=sgCnt+1;
			end
			desc=SegmentedDataDescriptor();
			desc.len=self.len;
			desc.overlap=self.overlap;
			desc.trials=trials;
			desc.segs=sgCnt-1;
			sdata.descriptor=desc;

		end

	end

	
end
