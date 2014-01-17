classdef MulticlassTest < TestCase
	properties
               data 
               adapter
	end

	methods
        	function self = MulticlassTest(name)
                	self = self@TestCase(name);
	        end

		function setUp(self)
                        %test data
                        self.data=Data(ones(2,2,4),[2,3,2,1]);
                        self.adapter=MulticlassAdapter();


		end

                function self=testDoProcess(self)
                        adder=AdderProcessor();
                        self.adapter.setNext(adder);
                        [rTrain,~]=self.adapter.process(self.data,[]);
                        %three classes 
                        assertEqual(size(rTrain.predicted,2),3);

                        

                end
                

	end

end
