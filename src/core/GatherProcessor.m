classdef GatherProcessor < PatternProcessor &  Experiment
        %allows to reconduct the execution flow, gathering the results from a processor and the executing next

        methods

                function [train,test]=doProcess(self,train,test)
                        [train,test]=self.root.process(train,test);
                        
                end
        end
        
end
