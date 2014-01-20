classdef JobManager < handle
	
	properties
		jobs={}
	end
		

	methods
		function self=JobManager()
			self.jobs={};
		end
		function self=addJob(self,job)
			self.jobs{1+end}= job;
		end
		function self=addJobs(self,jobs)
			self.jobs=[self.jobs jobs(:)];
		end

		function self=run(self)
			Logger.clear(Logger.DEBUG);	
			nJobs=length(self.jobs);
			for i=1:nJobs
				self.jobs{i}.run();
			end
			%Alarm.play();	
		end

		function self=parallelRun(self)
			nJobs=length(self.jobs);
			Logger.debug('Running in parallel total jobs %i',nJobs);
			matlabpool(2)	
			ejobs=self.jobs;
			parfor i=1:nJobs
				ejobs{i}.run();
			end	

		end
	end
end
