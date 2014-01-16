classdef SegmentAdapterTest < TestCase
	properties
               segmentedData 
               adapter
	end

	methods
        	function self = SegmentAdapterTest(name)
                	self = self@TestCase(name);
	        end

		function setUp(self)
                        %test data
                        self.segmentedData=SegmentedData();
                        self.segmentedData.addSegment(1,Data(1,1));
                        self.segmentedData.addSegment(2,Data(2,1));

                        self.adapter=SegmentAdapter();


		end

                function self=testDoProcess(self)
                        adder=AdderProcessor();
                        self.adapter.setNext(adder);
                        [rTrain,rTest]=self.adapter.process(self.segmentedData,[]);
                        assertTrue(isempty(rTest));
                        assertEqual(rTrain.getResult(1).expected,2);
                        assertEqual(rTrain.getResult(2).expected,3);

                        

                end
                

	end

end
