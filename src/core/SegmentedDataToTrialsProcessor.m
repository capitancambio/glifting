classdef SegmentedDataToTrialsProcessor < PatternProcessor
	properties
	end

	methods
		%From segments to trials
		function [tr,ts]=doProcess(~,tr,ts)
			Logger.debug('segments to trial');
			dataTr=tr.getSegment(1);
			dataTs=ts.getSegment(1);
			trSegmentDesc=SegmentDescriptor();
			tsSegmentDesc=SegmentDescriptor();
			trSegmentDesc.addSegment([1,size(dataTr.X,3)]);
			tsSegmentDesc.addSegment([1,size(dataTs.X,3)]);
			for s=2:tr.size
				idx=dataTr.merge(tr.getSegment(s));
				trSegmentDesc.addSegment(idx);
				tr.getSegment(s).delete;
			end				
			for s=2:ts.size
				idx=dataTs.merge(ts.getSegment(s));
				tsSegmentDesc.addSegment(idx);
				ts.getSegment(s).delete;
			end
			Logger.debug('Data size %ix%ix%i',size(dataTr.X));
			tr=dataTr;
			tr.meta.segs=trSegmentDesc;
			ts=dataTs;			
			ts.meta.segs=tsSegmentDesc;
		end

	end
				
end
