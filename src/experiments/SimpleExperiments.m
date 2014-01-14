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

        end

end
