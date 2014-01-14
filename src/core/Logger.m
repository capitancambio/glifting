classdef Logger

	properties(Constant=true)
		DEBUG=1;
		INFO=2;
		WARNING=3;
		ERROR=4;
		LEVEL_STR={'DEBUG','INFO','WARNING','ERROR'};
		UNK_CLASS='UNK';
	end

	methods(Static=true) 
		function clear(level)
			Logger.handlers([]);
			if exist('level')~=1
				level=Logger.INFO;
			end
			Logger.level(level);
			Logger.addHandler(ConsoleLoggerHandler(level));
		end
		function debug(varargin)
			Logger.logmsg(Logger.DEBUG,sprintf(varargin{:}));	
			
		end
		function info(varargin)
			Logger.logmsg(Logger.INFO,sprintf(varargin{:}));	
			
		end
		function warn(varargin)
			Logger.logmsg(Logger.WARNING,sprintf(varargin{:}));	
			
		end
		function err(varargin)
			Logger.logmsg(Logger.ERROR,sprintf(varargin{:}));	
			
		end

		function addHandler(handler)
			h=Logger.handlers();
			h=[h handler];
			Logger.handlers(h);
		end
		function level=level(logLevel)
			persistent mLevel;
			if exist('logLevel')
				mLevel=logLevel;
			end
			level=mLevel;
		end
		%there we go, always making workarounds in matlab...
		function outhandlers=handlers(inhandlers)
			persistent handlers;
			if exist('inhandlers')
				handlers=inhandlers;
			end
			outhandlers=handlers;
			
		end
	end


	methods (Access=private,Static=true)
		function logmsg(level,msg)
			[stack,i]=dbstack(2);
			from=Logger.UNK_CLASS;
			if size(stack,1)>0
				from=stack.name;
			end
			if Logger.level <= level
				for hand=Logger.handlers()
					hand.logmsg(level,msg,from);	
				end
			end
		end
	end

end
