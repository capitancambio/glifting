classdef SimpleGraphJobsEssex < JobFactory 
        %SimpleGraphJobs just extends 
        %the job factory as the implementation is already there
        methods(Access=public)
                function self=SimpleGraphJobsEssex(inputPath,outputPath)
                        self@JobFactory(inputPath,outputPath);	 
                end
        end

end
