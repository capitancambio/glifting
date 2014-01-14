classdef SegmentedData < Data

	properties
		segments={}
		descriptor
	end

	methods

		function self=SegmentedData()
			self=self@Data([],[]);	
			self.descriptor=SegmentedDataDescriptor();
			self.meta.segs=SegmentDescriptor();
		end

		function [data]=clone(self)
			% clone 
			% inputs: self
			% outputs: data
			data=SegmentedData();
			data.descriptor=self.descriptor;
			data.meta=self.meta;
			data.foldCalculator=self.foldCalculator;
			for s=self.isize()
				data.addSegment(s,self.getSegment(s).clone());
			end
			

			
		end
		function data=getClass(self,clazz)
			trs=self.Y==clazz;
			data=Data(self.X(:,:,trs),self.Y(trs));
				
		end
		function self=delete(self)
			%Logger.info('deleting data');
			for s= 1:self.size
				self.segments{s}.delete;
			end
		end

		function data=slice(self,from,to)
			data=SegmentedData();
			for i=1:self.size
				data.addSegment(i,self.segments{i}.slice(from,to));
			end
		end

		function [train,test]=getFold(self,fold,outOf)
			[train,test]=self.foldCalculator.getFold(self,fold,outOf);
		end
		function s=size(self)
			s=length(self.segments);
		end
		function s=isize(self)
			s=1:length(self.segments);
		end

		function data=getSegment(self,idx)
			data=self.segments{idx};
		end
		function data=addSegment(self,idx,data)
			self.Y=data.Y;
			data.meta.segment=idx;
			self.segments{idx}=data;
			Logger.debug('# segments: %i',length(self.segments))
		end

		function data=deleteSegments(self,idx);
			self.segments(idx)=[];	
			Logger.debug('# segments: %i',length(self.segments))
		end

		function data=metaClass(self,clazz)
			data=SegmentedData();
			data.meta=self.meta;
			for i=self.size
				data.addSegment(i,self.segments{i}.metaClass(clazz));
			end
		end
		function [train,test]=calculateFold(self,fold,outOf)
			train=SegmentedData();
			test=SegmentedData();
			for i=1:self.size
				[trainA,testA] =self.segments{i}.calculateFold(fold,outOf);
				train.addSegment(i,trainA);
				test.addSegment(i,testA);
			end
		end
		function toFile(self,path)
			Logger.info(sprintf('write wavelet data to file %s',path));
			data=self;	
			save(FSUtils.checkPath( path ),'data');
		end


		function [idx]=segmentsForTrial(self,trial)
			nSegs=self.descriptor.nSegs;	
			idx=trial:nSegs:size(self.X,3);		

		end
		function [t]=trials(self)
			t=self.descriptor.trials;	
		end

		function [self]=merge(self,other)
			% merge 
			% inputs: other
			% outputs: self
			
			for i=1:self.size
				self.segments{i}.merge(other.segments{i});
			end
		end		
		
	end
	 methods(Static)
		function [sData]= fromFile(path)
			Logger.info(sprintf('reading segmented data from file %s',path));
			data=FSUtils.load(path);
			sData=data.data;
		end	
	end
end	
