classdef LazyLiftingSetCalculator < SetCalculator
	%Calculates the sets per channel (no spatial linking) 
	properties 
		level
		topology
		weigthCalculator
		totChannels
	end
	methods 
		function self=LazyLiftingSetCalculator(topology)
			self.topology=topology;
			self.weigthCalculator=0;
			self.totChannels=length(self.topology.getOddChannels)+length(self.topology.getEvenChannels);
			
		end

		function [self]=train(lifting,data,Y,level)
			%IN 
				
		end
		
		function levels=calculateSets(self,level)
			levels=[];
			for l=1:level
				levels=[levels self.getLevel(l)];
			end
			
		end
		function levelDefinition=getLevel(self,level)
			vodds=[];
			vevs=[];
			% my odds : odds idx  in odd channel even idx in even channel
			 
			vevs=self.getOddIdx(self.topology.getEvenChannels,self.topology.samples,level);
			vevs=[vevs self.getEvenIdx(self.topology.getOddChannels,self.topology.samples,level)];

			vodds=self.getEvenIdx(self.topology.getEvenChannels,self.topology.samples,level);
			vodds=[ vodds self.getOddIdx(self.topology.getOddChannels,self.topology.samples,level)];
				
			%[predict,update]=getAdjMatrix();
			levelDefinition=LevelDefinition;
			levelDefinition.vodds=sort(vodds);
			levelDefinition.veven=sort(vevs);
			[levelDefinition.predict,levelDefinition.update]=self.getAdjMatrix(levelDefinition.vodds,levelDefinition.veven,level);
			if isa(self.weigthCalculator,'double')==0
				levelDefinition=self.weigthCalculator.assigneWeights(levelDefinition);
			end
			
		end
		function vodd=getOddIdx(self,channels,sigLen,level)
			vodd=[];
			desp=1;
			for chan=channels
				vodd=[vodd (chan-1)*sigLen+desp:2^level:chan*sigLen];
			end
		end
		function vev=getEvenIdx(self,channels,sigLen,level)
			vev=[];
			desp=1+2^(level-1);	
			for chan=channels
				vev=[vev (chan-1)*sigLen+desp:2^level:chan*sigLen];
			end
		end


		function [predict,update]=getAdjMatrix(self,vodds,vevens,level)
			nOdds=max(size(vodds));
			nEvens=max(size(vevens));
			%lazy no real operation performed
			predict=sparse([],[],[],nOdds,nEvens,0);
			update=predict';
			
		end

		function mat=getApproxMatrix(self,idxs,values,level)
			l2=2^level;
			%per channel
			sampNum=(self.topology.samples/l2);
			xs=ceil((idxs./l2)/sampNum);	
			%n=zeros(totChannels,floor(sampNum));
			%for i = 1:max(size(xs))
				%n(xs(i),mod(i,sampNum)+1)=values(i);	
			%end
			
			mat=zeros(self.totChannels,floor(sampNum));
			ys=mod(1:length(xs),sampNum)+1;
                        %copy paste from sub2ind
                        idx = xs + (ys - 1).*self.totChannels;
			%idx=sub2ind(size(z),xs,ys);
			mat(idx)=values;
			
		end
	end
end
