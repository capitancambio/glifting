classdef LinearLiftingSetCalculator < LazyLiftingSetCalculator
	%Calculates the sets per channel (no spatial linking)
	properties
	end 
	methods 
		function self=LinearLiftingSetCalculator(topology,weigthAssigner)
			self=self@LazyLiftingSetCalculator(topology);
			self.weigthCalculator=weigthAssigner;
		end



		function [predict,update]=getAdjMatrix(self,vodds,vevens,level)
			Logger.debug('Entering to adj');
			time=cputime();
			nOdds=max(size(vodds));
			nEvens=max(size(vevens));
			total=max(size(vodds))+max(size(vevens));
			xs=[];
			ys=[];
			nVo=1;
			for vodd=vodds
				nVe=1;
				ns=self.getNeights(vodd,level);
				idx=[];
				for n = ns
					idx=[idx find(vevens==n)];
				end
				xs=[ xs idx ];

				
				ys=[ys repmat(nVo,1,max(size(ns)))];
				nVo=nVo+1;
			end
			Logger.debug('Neightbouring end %4.4f',cputime()-time);
			time=cputime();
			Logger.debug('Sparsing');
			predict=sparse(ys,xs,ones(size(ys)),nOdds,nEvens);
			Logger.debug('Done %4.4f',cputime()-time);
			update=predict';	
		end

		function r=isLinked(self,i1,i2,level)
			r= (i1==(i2-2^(level-1)) || i1==(i2+2^(level-1))) && (ceil(i1/self.topology.samples) == ceil(i2/self.topology.samples));
		end
		function neights=getNeights(self,element,level)
			neights=[];
			n=element+2^(level-1);
			if  ceil(n/self.topology.samples) == ceil(element/self.topology.samples)  
				neights=[neights n];
			end	
			n=element-2^(level-1);
			if  ceil(n/self.topology.samples) == ceil(element/self.topology.samples)  
				neights=[neights n];
			end	
		end
	end
end
