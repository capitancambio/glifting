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
                        
                        %levels of decomposition
			conf.level=6; %max level
			conf.levels=2:conf.level;%convinience iterator

                        %where to store the results (csv format)
			conf.resAggPathEval=Conf.basify(sprintf('/bci/online/outs/eval_results_%s.csv',conf.prefix));
                
                end

        end

end
