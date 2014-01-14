classdef TopologyDefinition < handle

	properties
		map
		samples
	end	

	methods
		function self=TopologyDefinition(map,samples)
			self.map=map;
			self.samples=samples;
		end
		function chans=getOddChannels(self)
			chans=[1:2:15];
			chans=[];
		end
		function chans=getEvenChannels(self)
			chans=[1:1:15];
		end
	end
end
