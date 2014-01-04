classdef ConsoleLoggerHandler < LoggerHandler

	methods

		function self=ConsoleLoggerHandler(level)
			self.level=level;
		end
		function logmsg(self,level,msg,from)
			if self.level<=level
				fprintf('[%s] - %s - %s\n',Logger.LEVEL_STR{level},from,msg);
			end
		end
	end	
	
end
