classdef MRAAdapterTest< TestCase
	properties
                mraData
                adapter
	end

	methods
        	function self = MRAAdapterTest(name)
                	self = self@TestCase(name);
	        end

		function setUp(self)
                        %test data
                        self.mraData=WaveletData(1);
                        self.mraData.addLevelDetail(Data(1,1),1);
                        self.mraData.addLevelAnalysis(Data(2,1),1);
                        self.mraData.addLevelDetail(Data(3,1),2);
                        self.mraData.addLevelAnalysis(Data(4,1),2);

                        self.adapter=MRAAdapter(1:2);


		end

                function self=testDoProcess(self)
                        adder=AdderProcessor();
                        self.adapter.setNext(adder);
                        [rTrain,rTest]=self.adapter.process(self.mraData,[]);
                        assertTrue(isempty(rTest));
                        assertEqual(rTrain.getResultAnalysis(1).expected,3);
                        assertEqual(rTrain.getResultDetails(2).expected,4);
                        assertEqual(rTrain.getResultAnalysis(2).expected,5);
                end
                
                function self=testDoProcessTestData(self)
                        adder=AdderProcessor();
                        self.adapter.setNext(adder);
                        [~,rTest]=self.adapter.process(self.mraData,self.mraData);
                        assertEqual(rTest.getResultAnalysis(1).expected,3);
                        assertEqual(rTest.getResultDetails(2).expected,4);
                        assertEqual(rTest.getResultAnalysis(2).expected,5);
                end
                

	end

end
