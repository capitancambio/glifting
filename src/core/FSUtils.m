classdef FSUtils
	methods (Static=true)
		function mkdir(path)
			s=mkdir(path);
			Logger.debug('creating %s status:%i',path,s);
		end
		function path=checkPath(path)
			%checks the underlying architecture and changes the file separator	
			Logger.debug('adapting path to arch: %s',path);
			if FSUtils.isWin()
				path=regexprep(path,'/','\\');
			end
		end
		
		function win=isWin()
			win=size(regexp(computer(),'WIN','match'),1)==1;
			Logger.debug('win architecture %i',win);
			
		end
		function data=load(path)
			path=FSUtils.checkPath(path);
			data=load(path);
		end
		
	end
	
end
