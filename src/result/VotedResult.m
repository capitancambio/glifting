classdef VotedResult < handle
        properties
                kappa
                acc
        end
        %VotedResult 
        methods(Access=public)
                function self=VotedResult(kappa,acc)
                        self.kappa=kappa;       	 
                        self.acc=acc;
                end
        end

end
