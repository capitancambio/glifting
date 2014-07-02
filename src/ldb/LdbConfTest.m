classdef LdbConfTest < TestCase
	properties
		cnf
	end

	methods
        	function self = LdbConfTest(name)
                	self = self@TestCase(name);
	        end
		function setUp(self)
			self.cnf=LdbConf('test',10);
				
		end
		function testDefault(self)
			assertEqual(self.cnf.start,500)	
			assertEqual(self.cnf.stop,1750)	
			assertEqual(self.cnf.overlap,50)
			assertEqual(self.cnf.percSegs,1)
		end
		function testToStruct(self)
			cnf=LdbConf('paco',2);
			cnf.featureExtractor=1;
			cnf.discriminantCalculator=2;
			cnf.start=3;
			cnf.stop=4;
			cnf.segmentLenght=5;
			cnf.overlap=6;
			cnf.percSegs=7;
			[cnf,p]	=cnf.toStruct();
			assertEqual(p.foldNo,2)
			assertEqual(p.featureExtractor,1)
			assertEqual(p.discriminantCalculator,2)
			assertEqual(p.st,3)
			assertEqual(p.en,4)
			assertEqual(p.seg,5)
			assertEqual(p.over,6)
			assertEqual(p.percSegs,7)
			
		end
	end

end
