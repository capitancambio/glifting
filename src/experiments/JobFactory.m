classdef JobFactory < handle
        %The job defines the skeleton of an experiment, the different methods 
        %can be overriden by children classes to define specific parts (as the preprocessing or 
        %procesing)
        % For the sake of a example here it defines the simple graph experiments for the essex data
        properties
                inputPath
                outputFile
        end
        methods(Access=public)

                function self=JobFactory(inputPath,outputFile)
                        self.inputPath=inputPath;
                        self.outputFile=outputFile;
                        
                end

                function jobManager=forUsers(self,users)
                        jobManager=JobManager();
                        for user=users
                                Logger.debug('Jobs for user %i',user);
                                %configure experiment
                                conf=self.buildConf(user);
                                %set the processing parts (this can be overwritten in children classes)
                                experiment=Experiment();
                                experiment=self.setUpPreprocessing(conf,experiment);
                                experiment=self.setUpProcessing(conf,experiment);
                                experiment=self.setUpResults(conf,experiment);
                                jobManager.addJob(experiment.build());
                        end

                end


                function conf=buildConf(self,user)
                        conf=Configuration();
                        conf.user=user;
                        conf.prefix=sprintf('simple_experiment_%i',conf.user);
                        conf=ConfigurationUtils.BasicConfiguration(conf);
                        conf=ConfigurationUtils.EssexElectrodes(conf);
			conf.inputPath=self.inputPath;
			conf.resAggPath=self.outputFile;
                
                end

                function experiment=setUpPreprocessing(~,conf,experiment)
			Logger.info('setting up preprocessing')
                        %Read data files
			experiment.add(DataReaderProcessor(DataJoiner(sprintf('%i',conf.user),conf),[]));

                        %split the data into train and test sets 
                        experiment.add(SplitProcessor(0.5));

                        %Get rid of nans
			experiment.add(PreProcessorWrapper(Desnaniser()));

                        %Referencing
                        %ref=PreProcessorWrapper(ReferencingProcessor([33,34]));

                        %Select the set of electrodes to work with
			experiment.add(PreProcessorWrapper(ElectrodeSelectorProcessor(conf.electrodes)));
                        
                        %Filter the signals
			experiment.add(PreProcessorWrapper(FilterProcessor(conf.len,conf.lowFreq,conf.highFreq)));

                        %Crop the signals 
			experiment.add(PreProcessorWrapper(DataCropProcessor(conf.st,conf.en)));

                        %Zero-center the signals 
			experiment.add(ZeroCenterProcessor());

                        %Segment them using a sliding window
			experiment.add(PreProcessorWrapper(SegmentatorProcessor(conf.len,conf.over)));
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


			%for live tests, leave it empty
			experiment.add(SegmentFilterProcessor([]));

		        %Multiplex Segments	
                        experiment.add(SegmentAdapter());

                        %Analyse each segment with the lifting transform
                        experiment.add(LiftingAnalysis(lifter,conf.level));

                        %Multiplex levels
                        experiment.add(MRAAdapter(conf.levels));

		        %Calculate features	
			experiment.add(StatsPatternProcessor());

                        %Multiplex classes (for lda)
                        experiment.add(MulticlassAdapter());


                        %classify 
			classifier=LdaClassifierProvider(); %TODO: own function
                        experiment.add(EvaluationAdapter(classifier));

                        %This marks the end of processing part we gather here the 
                        %results for their processing
                        %Gather the results to process them together
                        gather=GatherProcessor();
                
                        gather.add(experiment.root);
                        %clear experiment
                        experiment=Experiment();
                        %Gather is the root processor
                        experiment.add(gather);




                end

                function [experiment]=setUpResults(~,cnf,experiment)

                        %compute majority voting of the gathered results
                        experiment.add(MajorityVotingResultProcessor(cnf));
                        
                        
                end

        end

end
