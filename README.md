glifting
========
Modular BCI expermiental framework including the matlab implementation of the graph lifting transform as in [Multiresolution analysis over simple graphs for brain computer interfaces](http://iopscience.iop.org/1741-2552/10/4/046014) _note that the code is not the same as in those experiments and therefore some changes in the results are expected_.


Intallation
-----------

 Inside matlab go to the ``src`` folder and run:

 ```matlab
 install_glifting
 ```

Examples of usage
-----------------

In ```src/temp.m``` you have an example of how to invoke a set of experiments. The proper way to create your own experiments would be overwritting the methods of ``src/experiments/JobFactory.m``` in a subclass and redefine the used processors, etc...



In ``src/example.m`` there is an usage example for the lifting transfrom.


```matlab

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

```


In order to change the  electrode layout modify topology.m, remember to leave a padding of zeros around the electrodes
