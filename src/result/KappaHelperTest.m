classdef KappaHelperTest < TestCase
	
	properties 
		result
	end
	methods 
        	function self = KappaHelperTest(name)
                	self = self@TestCase(name);
	        end

		function setUp(self)
			self.result=MRAResult([1 2 3]);
			self.result.addResultAnalysis(Result([1,2],[[1,0.5];[0.5,0.5]]),1)
			self.result.addResultAnalysis(Result([1,2],[[4,4];[4,4]]),2)
			self.result.addResultAnalysis(Result([1,2],[[2,2];[0.3,0.3]]),3)
			self.result.addResultDetail(Result([1,2],[[-1,2];[2,2]]),2)
			self.result.addResultDetail(Result([1,2],[[-4,3];[0.3,0.3]]),3)
			
		end
		function testGetAccumulatedVotes(self)
			accRes=KappaHelper.getAccumulatedVotes([2],[3],self.result);
			assertEqual(accRes.expected,[1,2])
			assertEqual(accRes.predicted,[[0,7];[4.3,4.3]])
			accRes=KappaHelper.getAccumulatedVotes([1,2,3],[2,3],self.result);
			assertEqual(accRes.predicted,[[2,11.5];[7.1,7.1]])
		end
		function testGetWeigthedVotes(self)
			accRes=KappaHelper.getWeightedVotes([1 1 1],[1 1],self.result);
			assertEqual(accRes.expected,[1,2])
			assertEqual(accRes.predicted,[[2,11.5];[7.1,7.1]])
			accRes=KappaHelper.getWeightedVotes([1 0.5 1],[-1 1],self.result);
			assertEqual(accRes.expected,[1,2]);
			assertEqual(accRes.predicted,[[2,5.50000];[1.1000,1.10000]]);
		end
	end
end
