all=TestSuite();

%names={ 'DataTestCase','KappaHelper', 'LiftingTest', 'LazyLiftingSetCalculatorTest', 'MRAResultTest', 'MRWaveletAnalysisTest', 'WaveletDataTest', 'WaveletPathHelperTest', , 'ConfigurationTest','FitnessEvaluatorTest','MagicClassTest','CmaExperimentTest' };
names={ 
'KappaHelper'
'DataTestCase'
'ExperimentTest'
'SegmentAdapterTest'
'MRAAdapterTest'
'MulticlassTest'
};
for name=1:length(names)
	all.add(TestSuite.fromName(names{name}));
end
level=Logger.level;
Logger.clear(Logger.ERROR);
all.run
Logger.clear(level);

