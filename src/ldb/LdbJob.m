classdef LdbJob < Job
	properties(SetAccess=private)
                cnf
	end

	methods
		function self=LdbJob(cnf,desc)
			self=self@Job(desc);
                        self.cnf=cnf;
		end

		function self=run(self)
			Logger.info(sprintf('Running %s',self.desc));
                        ldbConf=LdbConf(self.cnf.folds);
			%[cnf,p]=self.ldbConf.toStruct();
			opath=self.cnf.outputPath;
			ipath=self.cnf.inputPath;
                        p=ldbConf.toStruct();
                        %set the remaining stuff
                        p.featureExtractor=self.cnf.featureExtractor;
                        p.discriminantCalculator=self.cnf.discriminantCalculator;
                        p.seg=self.cnf.segmentLenght;
                        
			%no more oo under this call
			ldbCsp(opath,ipath,p,1);
		end
	end
end
