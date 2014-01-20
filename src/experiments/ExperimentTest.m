classdef ExperimentTest < TestCase
	properties
                experiment
	end

	methods
        	function self = ExperimentTest(name)
                	self = self@TestCase(name);
	        end

		function setUp(self)
                        self.experiment=Experiment();
		end

                function self=testAddPreprocessor(self)
                       assertTrue(isempty(self.experiment.processor));
                       self.experiment.add(Desnaniser());
                       assertFalse(isempty(self.experiment.processor));
                       self.experiment.add(Desnaniser());
                       assertFalse(isempty(self.experiment.processor.next));

                end

                function self=testAddAdapter(self)
                       assertTrue(isempty(self.experiment.processor));

                end
	end

end
