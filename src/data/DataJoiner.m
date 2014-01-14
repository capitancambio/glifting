classdef DataJoiner < handle
	properties

		name
		cnf
	end
	methods
		function self=DataJoiner(name,cnf)
			self.name=name;
			self.cnf=cnf;
		end
		function [data]=get(self)
			datas=self.loadDir()	;
			data=self.join(datas)	;
			data.Y=data.Y';
		end

		function [datas]=loadDir(self)
			path=sprintf('%s/%s/',self.cnf.inputPath,self.name);
			dirlist=dir(sprintf('%s/*mat',path));
			%sort list entries by name, the date format assures that they are in order
			[~,idx]=sort({dirlist.name});
			dirlist=dirlist(idx);
			d2l=length(dirlist)/2;
			datas=[];
			for d=1:d2l
				x=FSUtils.load(sprintf('%s/%s',path,dirlist(d).name));
				y=FSUtils.load(sprintf('%s/%s',path,dirlist(d+d2l).name));
				data=Data(x.x,y.y);
				datas=[datas data];

			end
				
		end
		function [data]=join(~,datas)
			data=datas(1);
			for i=2:length(datas)
				data.X=cat(3,data.X,datas(i).X);
				data.Y=[data.Y,datas(i).Y];
			end
		end
		

	end
end
