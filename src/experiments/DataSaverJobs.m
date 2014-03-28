classdef DataSaverJobs < JobFactory
        %DataSaverJobs 
        properties(Access=private)
                outputPath
        end
        
        methods(Access=public)
                function self=DataSaverJobs(inputPath,outputPath)
                        self@JobFactory(inputPath,'');	 
                        self.outputPath=outputPath;
                end

                function conf=buildConf(self,user)
                        conf=buildConf@JobFactory(self,user);
                        %Add the output path
                        conf.outputPath=self.outputPath;
                end
                function experiment=setUpProcessing(~,conf,experiment)
                        %%INIT LIFTING%%
                        %weighting strategy
                        weightCalculator=LinearWeightCalculator();
                        %builds the graph given the electrode layout
                        setCalculator=GraphLiftingSetCalculator(TopologyDefinition(topology(),conf.len),weightCalculator);
                        lifter=Lifting(weightCalculator,setCalculator);
                        %init lifting strcuture to the 6th level
                        lifter.init(conf.level);
                        %%END INITLIFTING%%

		        %Multiplex Segments	
                        experiment.add(SegmentToSegmentAdapter());

                        %Analyse each segment with the lifting transform
                        experiment.add(LiftingAnalysis(lifter,conf.level));


                end

                function [experiment]=setUpResults(~,conf,experiment)
                        %Gather the results to process them together
                        gather=GatherProcessor();
                
                        gather.add(experiment.root);
                        %clear experiment
                        experiment=Experiment();
                        %Gather is the root processor
                        experiment.add(gather);
                       %do nothing 
                        experiment.add(DataWriterProcessor(conf));
                        
                end
        end


end
