classdef ResultLineAggregator < handle

	properties
		fd
		visitors
	end

	methods
		function self=ResultLineAggregator(path)
			self.fd=fopen(path,'a+');
			Logger.debug('Agg file %i',self.fd);
			self.visitors=0;	
		end

		function self=setHeader(self,str)
			bytes=fprintf(self.fd,'%s\n',str);
		end
		function self=addLine(self,str)
			%self.visitors=self.visitors+1;
			%while self.visitors~=1
				%pause(0.001);
				%Log.info('locked!');
			%end
			bytes=fprintf(self.fd,'%s\n',str);
			Logger.debug('Adding line %i',bytes);
			%self.visitors=self.visitors-1;
			
		end
		function self=close(self)
			Logger.info('Closing agg file');
			status=fclose(self.fd);
			Logger.info('Closing agg file stat %i',status);
		end
	end		
end
