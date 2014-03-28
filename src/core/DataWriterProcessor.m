classdef DataWriterProcessor < PatternProcessor 
        %DataWriterProcessor 
        properties
                conf
        end
        methods(Access=public)
                function self=DataWriterProcessor(conf)
                        self.conf=conf;
                        	 
                end


                function [trainData,testData]=doProcess(self,trainData,testData)
			Logger.debug('Saving data');
                        path=FSUtils.checkPath(self.conf.outputPath);
                        FSUtils.mkdir(path);
                        save(sprintf('%s/x%i.mat',path,self.conf.user),'trainData');
                        save(sprintf('%s/xe%i.mat',path,self.conf.user),'testData');
                        % doProcess 
                        % inputs: tr,ts
                        % outputs: tr,ts
                        
                end
        end

end
