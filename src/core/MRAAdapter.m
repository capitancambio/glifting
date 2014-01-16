classdef MRAAdapter < PatternProcessor 
        %Multiplexes the execution of the processing flow 
        %along different levels the mra
        properties
                levels
        end

        methods
                function self=MRAAdapter(levels)
                        self=self@PatternProcessor();
                        self.levels=levels;
                end


                function [rTrain,rTest]=process(self,train,test)
                        %Rewrite parent method in order to multiplex
                        rTrain=MRAResult(self.levels);
                        if ~isempty(test)
                                rTest=MRAResult(self.levels);
                        else
                                rTest=[];
                        end

                        for l=self.levels
                                
                                aTrain=train.getLevelAnalysis(l);
                                dTrain=train.getLevelDetail(l);
                                aTest=[];
                                dTest=[];
                                if ~isempty(test)
                                        aTest=test.getLevelAnalysis(l);
                                        dTest=test.getLevelDetail(l);
                                end

                                [aTrain,aTest]=self.doProcess(aTrain,aTest);
                                [dTrain,dTest]=self.doProcess(dTrain,dTest);
                                rTrain.addResultAnalysis(aTrain,l);
                                rTrain.addResultDetail(dTrain,l);

                                if ~isempty(test)
                                        rTest.addResultAnalysis(aTest,l);
                                        rTest.addResultDetail(dTest,l);
                                end
                        end
                end

                function [train,test]=doProcess(self,train,test)
                        [train,test]=self.next.process(train,test);
                end
        end

end
