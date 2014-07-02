function LdbRun(outputPath,inputPath)
        %create the basic configuration
        cnf=Configuration();
        cnf.outputPath=outputPath;
        cnf.inputPath=inputPath;
        cnf.folds=10;
        extractors={@lctFeatureExtractor,@cspFeatureExtractor};
        costFuncs={@dist,@DBIFunc};
        %range for different segment lengths, they differ from the paper as you need to add the overlapping to the final len
        for cnfSeg=Configuration.range(cnf,'segmentLenght',[25,50,100,150])
                %range over the cost functions fisher and dbi 
                for cnfCostFun=Configuration.range(cnfSeg,'discriminantCalculatorIdx',[1 2])
                        cnfCostFun.discriminantCalculator=costFuncs{cnfCostFun.discriminantCalculatorIdx};
                        %range over the feature extractors
                        for ldbCnf=Configuration.range(cnfCostFun,'featureExtractorIdx',[1 2])
                                ldbCnf.featureExtractor=extractors{ldbCnf.featureExtractorIdx};
                                ldbj=LdbJob(ldbCnf,'ldb_exp');
                                ldbj.run()

                        end
                end
        end
end





