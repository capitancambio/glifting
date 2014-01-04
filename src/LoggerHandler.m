classdef LoggerHandler

	properties(GetAccess = 'public', SetAccess = 'public')
		level=Logger.WARNING;
	end

	methods(Abstract=true)
		self=logmsg(self,level,msg,from) 
	end

end
