classdef GraphLiftingSetCalculator < LinearLiftingSetCalculator
	%Calculates the sets per channel (no spatial linking)
	properties
	end 
	methods 
		function self=GraphLiftingSetCalculator(topology,weigthAssigner)
			self=self@LinearLiftingSetCalculator(topology,weigthAssigner);
		end



		function [predict,update]=getAdjMatrix(self,vodds,vevens,level)
			Logger.debug('Entering to adj');
			time=cputime();
			nOdds=max(size(vodds));
			nEvens=max(size(vevens));
			xs=[];
			ys=[];
			ws=[];
			nVo=1;
			for vodd=vodds
				[ns,ds]=self.getNeights(vodd,level);
				idx=[];
				i=1;
				for n = ns
					idx=[idx find(vevens==n)];%#ok
					ws=[ws ds(i)];%#ok
					i=i+1;
				end
				xs=[ xs idx ];%#ok
				ys=[ys repmat(nVo,1,max(size(ns)))];%#ok
				nVo=nVo+1;
			end
			Logger.debug('Neightbouring end %4.4f',cputime()-time);
			time=cputime();
			Logger.debug('Sparsing');
			predict=sparse(ys,xs,ws,nOdds,nEvens);
			Logger.debug('Done %4.4f',cputime()-time);
			update=predict';
		end

		function [neights,dists]=getNeights(self,element,level)
			neights=[];
			dists=[];
			prev=0;
			next=0;
			n=element+2^(level-1);
			if  ceil(n/self.topology.samples) == ceil(element/self.topology.samples)  
				neights=[neights n];
				dists=[dists 1 ];
				next=1;
			end	
			n=element-2^(level-1);
			if  ceil(n/self.topology.samples) == ceil(element/self.topology.samples)  
				neights=[neights n];
				dists=[dists 1 ];
				prev=1;
			end
			chan=ceil(element/self.topology.samples);
			sample=mod(element-1,self.topology.samples)+1;
			[ty,tx]=find(chan==self.topology.map);
			topo=self.topology.map;
			p1=[];
			%sprintf('chan %i y:%i,x:%i\n',chan,ty,tx)
			%down
                        w=1;
			if prev
				if (size(topo,1)>=ty+1) && topo(ty+1,tx)~=0 
						neights=[neights (topo(ty+1,tx)-1)*self.topology.samples+sample-2^(level-1)];
						p1=[p1 w];
				end
				%dists=[dists p1];
				%up
				if ty-1>0 && topo(ty-1,tx)~=0
					neights=[neights (topo(ty-1,tx)-1)*self.topology.samples+sample-2^(level-1)];
					p1=[p1 w];
					%sprintf('check %i channel %i\n',2,topo(ty-1,tx))
				end
				%dists=[dists p1];
				%left
				if tx-1>0 && topo(ty,tx-1)~=0
					neights=[neights (topo(ty,tx-1)-1)*self.topology.samples+sample-2^(level-1)];
					p1=[p1 w];
					%sprintf('check %i channel %i\n',3,topo(ty,tx-1))
				end
				%dists=[dists p1];
				%right
				if size(topo,2)>=tx+1 && topo(ty,tx+1)~=0
					neights=[neights (topo(ty,tx+1)-1)*self.topology.samples+sample-2^(level-1)];
					p1=[p1 w];
					%sprintf('check %i channel %i\n',2,topo(ty,tx+1))
				end
			end
			if next 
				if (size(topo,1)>=ty+1) && topo(ty+1,tx)~=0 
						neights=[neights (topo(ty+1,tx)-1)*self.topology.samples+sample+2^(level-1)];
						p1=[p1 w];
				end
				%dists=[dists p1];
				%up
				if ty-1>0 && topo(ty-1,tx)~=0
					neights=[neights (topo(ty-1,tx)-1)*self.topology.samples+sample+2^(level-1)];
					p1=[p1 w];
					%sprintf('check %i channel %i\n',2,topo(ty-1,tx))
				end
				%dists=[dists p1];
				%left
				if tx-1>0 && topo(ty,tx-1)~=0
					neights=[neights (topo(ty,tx-1)-1)*self.topology.samples+sample+2^(level-1)];
					p1=[p1 w];
					%sprintf('check %i channel %i\n',3,topo(ty,tx-1))
				end
				%dists=[dists p1];
				%right
				if size(topo,2)>=tx+1 && topo(ty,tx+1)~=0
					neights=[neights (topo(ty,tx+1)-1)*self.topology.samples+sample+2^(level-1)];
					p1=[p1 w];
					%sprintf('check %i channel %i\n',2,topo(ty,tx+1))
				end
			end
			%nlins=length(dists);
			%nps=length(p1);
			dists=[dists p1];
				
		end
	end
end
