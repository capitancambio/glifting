classdef MagicClass < dynamicprops
	properties
		dynprops={};
	end
	
	methods
		function self=MagicClass()

			self=self@dynamicprops();
			
		end

		function var=get.dynprops(self)
			var=self.dynprops;
		end	
		
		function self=set.dynprops(self,val)
			self.dynprops=val;
		end	
		function sz=count(self)
			sz=length(self.dynprops);
		end

		function [bool]=hasProp(self,strProp)
			% hasProp 
			% inputs: self,strProp
			% outputs: bool
			bool=~isempty(findprop(self,strProp));
			
		end
		function addprop(self,prop)
			addprop@dynamicprops(self,prop);	
			self.dynprops{end+1}=prop;
			
		end
		%magic properties
		function sref=subsref(self,s)
			switch s(1).type
				case '.'
					%if it's a method we call it
					meta=metaclass(self);
					mets={meta.MethodList.Name};
					if find(strcmp(mets,s(1).subs))
						hnd=str2func(s(1).subs);
						args={self,s(2).subs{:}};
						sref=hnd(args{:});
						return;
					end
					ref=findprop(self,s(1).subs);
					if size(ref,1)==0
						self.addprop(s(1).subs);
					end	
					sref=self.(s(1).subs);
					if length(s)>1
						s=s(2:end);
						sref=builtin('subsref',sref,s);
					end

				otherwise
					sref=builtin('subsref',self,s);
			end	

		end
		function self=subsasgn(self,s,value)
			switch s(1).type
				case '.'
					ref=findprop(self,s.subs);		
					if size(ref,1)==0
						self.addprop(s.subs);	
					end	
					self.(s.subs)=value;	
				otherwise
					builtin('subsasgn',self,s);
					
			end	
		end
	end
end	
