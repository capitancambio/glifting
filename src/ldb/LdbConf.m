classdef LdbConf < handle 
	properties
		featureExtractor
		discriminantCalculator
		segmentLenght
		start=500;
		stop=1750;
		overlap=50;
		percSegs=1;
                foldNo;
	end

	methods
		function self=LdbConf(foldNo)
                        self.foldNo=foldNo;
		end

		function p=toStruct(self)
			p=struct;
                        p.foldNo=self.foldNo;
			p.featureExtractor=self.featureExtractor;
			p.discriminantCalculator=self.discriminantCalculator;
			p.st=self.start;
			p.en=self.stop;
			p.seg=self.segmentLenght;
			p.over=self.overlap;
			p.sover=self.overlap;
			p.percSegs=self.percSegs;
		end

		

	end
end
