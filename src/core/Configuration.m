classdef Configuration < MagicClass
	properties

	end
	methods
		function self=Configuration()
			self=self@MagicClass();
		end

		function [other]=clone(self)
			other=Configuration;
			
			for i=1:length(self.dynprops)
				prop=self.dynprops{i};
				s.type='.';
				s.subs=prop;
				other.subsasgn(s,self.(prop));

			end
				
		end
		
	end
	methods(Static)
		function [confs]=range(conf,attrName,range)
			confs=[];
			for val=range
				new=conf.clone();
				s.type='.';
				s.subs=attrName;
				new.subsasgn(s,val);
				confs=[confs,new];%#ok
			end
				 
				
		end
		
	end
end

