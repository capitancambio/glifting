classdef SimpleExperiments < handle
        properties
                getElectrodes
        end
        %SimpleExperiment 
        methods(Access=public)
                function self=SimpleExperiments()
                        %fake a method so it's easy to overwrite
                        %compose, not inherit!
                        self.getElectrodes=@(self) [5:9,12:16,19:23];
                                 
                end


                function conf=buildConf(self,user)
			Logger.info('Loading basic conf')
                        %builds a simple configuration
			conf=Configuration();
			conf.user=user;
                        %for result storing and stuff
			conf.prefix=sprintf('experiment_%i',user);		
                        %will this work in windows?
			conf.preprocessedDataPath=Conf.basify('/bci/pdata/');
			conf.rawDataPath=Conf.basify('/bci/brainz_data/');
			conf.electrodes=self.getElectrodes();
                        %signal preprocessing conf 
                        %trial start
			conf.st=500;
                        %trial end
			conf.en=1749;
                        %sliding window configuration
			conf.len=256;
			conf.over=50;

                        %filtering conf
                        conf.lowFreq=8;
                        conf.highFreq=30;
                        
                        %levels of decomposition
			conf.level=6; %max level
			conf.levels=2:conf.level;%convinience iterator

                        %where to store the results (csv format)
			conf.resAggPathEval=Conf.basify(sprintf('/bci/online/outs/eval_results_%s.csv',conf.prefix));
                
                end

                function proc=buildPreprocessor(~,conf)

			Logger.info('Loading preprocessor')

			conf.outputPath=conf.preprocessedDataPath;
			conf.inputPath=conf.rawDataPath;

                        %Read data files
			proc=DataReaderProcessor(DataJoiner(sprintf('%i',conf.user),conf),[]);

                        %Get rid of nans
			desnaniser=PreProcessorWrapper(Desnaniser());

                        %Referencing
                        %ref=PreProcessorWrapper(ReferencingProcessor([33,34]));

                        %Select the set of electrodes to work with
			electrodeSelector=PreProcessorWrapper(ElectrodeSelectorProcessor(conf.electrodes));
                        
                        %Filter the signals
			filterProcessor=PreProcessorWrapper(FilterProcessor(conf.len,conf.lowFreq,conf.highFreq));

                        %Crop the signals 
			crop=PreProcessorWrapper(DataCropProcessor(conf.st,conf.en));

                        %Zero-center the signals 
			zeroCenterProcessor=ZeroCenterProcessor();

                        %Segment them using a sliding window
			segmentator=PreProcessorWrapper(SegmentatorProcessor(conf.len,conf.over));
                        
                        %build the processor
			proc.setNext(desnaniser).setNext(electrodeSelector).setNext(filterProcessor)...
				.setNext(crop).setNext(zeroCenterProcessor).setNext(segmentator);

                end

                function proc=buildProcesssor(~,conf)
                        %weighting strategy
                        weightCalculator=LinearWeightCalculator();
                        %builds the graph given the electrode layout
                        sampleLen=256;
                        setCalculator=GraphLiftingSetCalculator(TopologyDefinition(topology(),sampleLen),weightCalculator);
                        lifter=Lifting(weightCalculator,setCalculator);
                        %init lifting strcuture to the 6th level
                        lifter.init(conf.levels);


			%for live tests leave the it empty
			segFil=SegmentFilterProcessor([]);
			%data readers
			trainDataReader=SegmentedDataReader(sprintf('%s/user_%i.mat',cnf.inputPath,cnf.user));
			testDataReader=SegmentedDataReader(sprintf('%s/user_%ie.mat',cnf.inputPath,cnf.user));
			dataTrain=trainDataReader.get();
			dataTest=testDataReader.get();
			dataTrain.merge(dataTest);
			reader.get=@()dataTrain;
			dataReader=DataReaderProcessor(reader,reader);
			dataReader.setNext(segFil);%.setNext(toTrials);%.setNext(flatProcessor).setNext(pcaDim);
			%dataHolder=DataHolder(dataReader);
			%processign train	
			%wAnal.setNext(pk).setNext(flatProcessor).setNext(pcaDim);
			
			%classifier
			rProcessor=SegmentResultWriter(cnf);
			rProcessor.setNext(NFolderResultProcessor(cnf));
			%rProcessor.setNext(SegmentResultWriter(cnf));
			
			%wAnal.setNext(pk);
			%evalAdater=MulticlassAdapter(EvaluationAdapter(classifier,[]),[]);
			classifier=LdaClassifierProvider();
			proc=CspPatternProcessor(cnf.feats);
			proc.setNext(NormaliserProcessor());
			evalAdater=MulticlassAdapter(EvaluationAdapter(classifier,[]),proc,cnf);
			%classifier=SVMProvider(cnf);
			%evalAdater=DummyAdapter(EvaluationAdapter(classifier,[]),proc);

			%segAdapter=DummyAdapter(NFoldAdapter(SegmentAdapter(DummyAdapter(MRAAdapter(evalAdater,levels),wAnal),[]),5),dataReader);
                        
                        segAdapter=SegmentAdapter();
                        wAnal=LiftingAnalysis(lifter,conf.levels);
                        mraAdapater=MRAAdapter(levels);
                        segAdapter.setNext(wAnal).setNext(mraAdapter).setNext(evalAdapter);
                        segAdapter.setNext()
			%job=ResultJob(sprintf('cma eval user %i',cnf.user),segAdapter,rProcessor);


                end


        end

end
