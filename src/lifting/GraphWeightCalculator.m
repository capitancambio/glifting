classdef GraphWeightCalculator < WeightAssigner
	properties
		topology
	end
	methods
		function [self]=GraphWeightCalculator(topology)
			self.topology=topology;
			
		end
		
		function ld=assigneWeights(self,ld)
			predict=ld.predict;
			update=ld.update;
			Logger.debug('calculating weigths graph');
			for i=1:size(predict,1)
				nNeights=1;%sum(predict(i,:));
				predict(i,:)=predict(i,:)*(1/nNeights);
			end
			for i=1:size(update,1)
				nNeights=1;%sum(update(i,:));
				update(i,:)=update(i,:)*(1/(nNeights*2));
			end
			Logger.debug('done');
			ld.predict=predict;
			ld.update=update;
		end
	end


end
