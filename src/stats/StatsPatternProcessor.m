classdef StatsPatternProcessor < PatternProcessor
	properties
		pca
		erd
	end

	methods
		function [trData,tsData]=doProcess(self,trainData,testData)
			time=cputime();
			Logger.debug('Applying stats');
			Logger.debug('size %ix%ix%i',size(trainData.X))
			%zero center the data
			trData=self.featurise(trainData);
			if ~isempty(testData)
				tsData=self.featurise(testData);
			else
				tsData=[];
			end
			Logger.debug('size %ix%i',size(trData.X))
			Logger.debug('Applying stats ( %2.2f s) ',cputime()-time);
				
			
		end

		function rdata=featurise(~,data)
			%super matrix containing a bunch of stats
			%newTrainX=[];
			stats=[];
			%stats=[stats; Stats.energy(data.X)];
			%stats=[stats; Stats.entropy(data.X)];
			%stats=[stats; Stats.means(data.X)];
			%stats=[stats; Stats.medians(data.X)];
			%stats=[stats Stats.skwenesses(data.X)];
			%stats=[stats Stats.kurtosisis(data.X)];
			stats=[stats; Stats.var(data.X)];
			%stats=[stats; Stats.avStds(data.X)];
			%stats=[stats; Stats.stds(data.X.^2)];
			%stats=[stats; Stats.balancedPower(data.X)];
			%stats=[stats; Stats.balancedStds(data.X)];
			%stats=[stats LZComp.get(data.X)];
			%stats=[stats Stats.approximateEntroopy(data.X)];
			%stats=[stats; Stats.getPSD(data.X)];
			%stats=[stats; Stats.fft(data.X)];
			%stats=[stats; self.erd.featurise(data,train).X];
			%stats=[stats Stats.energy(fff)];
			%stats=[stats Stats.anova(data.X)];

			for i=1:size(stats,2)
				s=stats(:,i);
				stats(:,i)=Stats.normalize(s);	
			end
			%mean(stats(:))	
			%pause
			%stats=stats-mean(stats(:));
			%for i=1:size(stats,2);
				%stats(:,i)=stats(:,i)/sum(stats(:,i));
				
			%end
			%stats=stats-mean(stats(:));
%			%assert(size(stats,1)==size(data.X,2)*4);
%			if train==1
%				[pcam,vecs]=PCA.getPCA(stats);
%				%pcam=PCA.selectRows(pcam,vecs,0.995);
%				self.pca=pcam(:,2:0);
%			end
%			projected=[];
%			for v=1:size(stats,2)
%				projected(:,v)=self.pca'*stats(:,v);	
%			end
				
			rdata=Data(stats,data.Y);
			
		end
	end
				
end
