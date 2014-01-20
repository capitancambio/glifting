classdef Experiment < handle
        %Experiment 

        properties
                root
                last
                desc
        end
        methods(Access=public)

                function self=add(self,processor)
                        %Adds a processor to the chain
                        if isempty(self.root)
                                self.root=processor;
                                self.last=self.root;
                        else
                                self.last=self.last.setNext(processor);
                        end
                end
                
                function [self]=setDesc(self,desc)
                        % setDesc 
                        % inputs: vargsin
                        % outputs: self
                        self.desc=desc; 
                end

                function job=build(self)
                        job=GenericJob(self.desc,self.root);

                end

        end

end
