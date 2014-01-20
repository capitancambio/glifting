classdef ConfigurationUtils

        methods(Static=true)

                function conf=EssexElectrodes(conf)
                       Logger.debug('Filtering Essex electrodes');
                       conf.electrodes=[5:9,12:16,19:23];

                end

                function conf=BasicConfiguration(conf)
                        assert(~isempty(conf.user),'conf.user must be set!')
			Logger.info('Loading basic conf')
                        
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
			%conf.prefix=sprintf('experiment_%i',user);		
                end


        end
end
