classdef Conf
	properties(Constant=true)
		DEBUG=true;
		BASE_DATA_PATH='/home/javi/';
	end

	methods(Static=true)
		function path=basify(path)
			%  
			% inputs: path
			% outputs: path
			path=sprintf('%s/%s',Conf.BASE_DATA_PATH,path);
			
		end
	end

end
