function dist=trialsDiscriminantAdapter(p,X,Y,featureExtractor,discriminantCalculator,seg)

	if nargin==0
		allTests();
		return;
	end
	patterns=featureExtractor(p,X,Y,seg);
	dist=discriminantCalculator(patterns,Y);
end

%%% TESTS %%%%

function allTests()
	tests={};
	testSuite(tests);
end



