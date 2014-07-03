classdef SimpleGraphJobsEssexNFold < JobFactory 
        %SimpleGraphJobsEssexNFolder 
        %The same as SimpleGraphJobsEssex but using 
        %xvalidation
        methods(Access=public)
                function self=SimpleGraphJobsEssexNFold(inputPath,outputPath)
                        self@JobFactory(inputPath,outputPath);	 
                end

                function conf=buildConf(self,user)
                        conf=buildConf@JobFactory(self,user);
                        conf.folds=5;
                        conf.prefix=sprintf('simple_experiment_x_val_%i',conf.user);
                        conf.dontWrite=1;
                
                end

                function experiment=setUpProcessing(self,conf,experiment)
                        %multiplex the xvalidation
                        experiment.add(NFoldAdapter(conf.folds));
                        %the rest of the experiment remains the same
                        experiment=setUpProcessing@JobFactory(self,conf,experiment);

                end

                function [experiment]=setUpResults(self,cnf,experiment)
                        %multiplex the folders
                        experiment.add(NFolderResultProcessor(cnf));
                        experiment=setUpResults@JobFactory(self,cnf,experiment);
                        
                        
                end
        end

end
