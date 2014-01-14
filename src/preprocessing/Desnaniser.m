classdef Desnaniser < PatternProcessor
	properties

	end
	methods
		function self=Desnaniser()
			
		end
		function [data]=doProcess(self,data)
			toDel=[];
			for trial=1:size(data.X,3)	
				if sum(sum(isnan(data.X(:,:,trial))))~=0
					Logger.debug('Found hostile nan in trial %i',trial)
					toDel=[toDel trial];
				end
			end
			data.X(:,:,toDel)=[];
			data.Y(toDel)=[];
		end
		
	end
end
