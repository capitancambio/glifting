classdef LinearWeightCalculator < WeightAssigner
	methods
		function ld=assigneWeights(self,ld)
			predict=ld.predict;
			update=ld.update;
			Logger.debug('calculating weigths');
			for i=1:size(predict,1)
				nNeights=sum(abs(predict(i,:)));
				predict(i,:)=predict(i,:)*(1/nNeights);
			end
			for i=1:size(update,1)
				nNeights=sum(abs(update(i,:)));
				update(i,:)=update(i,:)*(1/(nNeights*2));
			end
			Logger.debug('done');
			ld.predict=predict;
			ld.update=update;
		end
	end


end
