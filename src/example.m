
%weighting strategy
weightCalculator=LinearWeightCalculator();
%builds the graph given the electrode layout
sampleLen=256;
setCalculator=GraphLiftingSetCalculator(TopologyDefinition(topology(),sampleLen),weightCalculator);
lifter=Lifting(weightCalculator,setCalculator);
%init lifting strcuture to the 6th level
lifter.init(6);
%random signals samples,channel,trials
X=rand(256,15,100);
%wrap the signals in a Data object
data=Data(X,[]);
wdata=lifter.transform(data,6,[]); %Object of type WaveletData
%access to the levels
dataDetail3=wdata.getLevelDetail(3); %object of type Data
xd2=wdata.getLevelDetail(2).X;
xa5=wdata.getLevelAnalysis(5).X;


