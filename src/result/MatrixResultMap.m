classdef MatrixResultMap < handle

	properties
		result
		trainMap
		testMap
		trainKappas
		testKappas
		segLen
		segments
		levels
		mr
                folds
	
	end
	methods(Access=public)
		function self=MatrixResultMap(results,segments,levels)
                        if ~isempty(results)
                                self.init(segments,levels,results)
                        end
		end

                function [ ]=init(self,segments,levels,results)
                        % init 
                        % inputs: folds,segments,levels,classes,result
                        % outputs:  
			self.result=results;		 
			ml=max(levels)-min(levels)+1;
                        classes=size(self.result(1).train.getResult(1).getResultDetails(2).predicted,2);
			self.segLen=ml*2;
                        self.folds=length(results);
                        self.trainMap=cell(1,self.folds);
                        self.testMap=cell(1,self.folds);
                        for i=1:self.folds
                                trialsTrain=size(self.result(i).train.getResult(1).getResultDetails(2).predicted,1);
                                %fprintf('Trials train %i\n',trialsTrain)
                                self.trainMap{i}=zeros(segments,ml,2,trialsTrain,classes);
                                if ~isempty(self.result(i).test.results)
                                        trialsTest=size(self.result(i).test.getResult(1).getResultDetails(2).predicted,1);
                                        self.testMap{i}=zeros(segments,ml,2,trialsTest,classes);
                                end
                        end
			self.mr=MRAResultProcessor([]);
			self.levels=levels;
			self.segments=segments;
                        self.folds=self.folds;
                        
                end
                
                function self=populate(self)
                        for f=1:self.folds
                                for s=1:self.segments
                                        absLevel=1;
                                        for l=self.levels
                                                self.trainMap{f}(s,absLevel,1,:,:)=squeeze(self.result(f).train.getResult(s).getResultDetails(l).predicted);
                                                self.trainMap{f}(s,absLevel,2,:,:)=squeeze(self.result(f).train.getResult(s).getResultAnalysis(l).predicted);
                                                if ~isempty(self.result(f).test.results)
                                                        self.testMap{f}(s,absLevel,1,:,:)=squeeze(self.result(f).test.getResult(s).getResultDetails(l).predicted);
                                                        self.testMap{f}(s,absLevel,2,:,:)=squeeze(self.result(f).test.getResult(s).getResultAnalysis(l).predicted);
                                                end
                                                absLevel=absLevel+1;
                                        end

                                end	
                        end
                end

		function [kappas,accs]=voteTrain(self,idxs)
			[kappas,accs]=vote(self,idxs,[self.result.train],self.trainMap);
		end

		function [kappas,accs]=voteTest(self,idxs)
			[kappas,accs]=vote(self,idxs,[self.result.test],self.testMap);
		end

		function [kappas,accs]=vote(self,idxs,res,map)
			kappas=zeros(self.folds,1);
			accs=zeros(self.folds,1);
                        [ss,ls,sets]=self.map(idxs);
                        for f=1:self.folds
                                nTrials=size(map{f},4);
                                nClasses=size(map{f},5);
			        mayority=zeros(1,1,1,nTrials,nClasses);
                                data=map{f};
                                for i=1:length(idxs)
                                        mayority=mayority+data(ss(i),ls(i),sets(i),:,:);%max(abs(map{s,l,set}.predicted(:)));
                                end
                                aux=KappaHelper.processVotesArray(reshape(mayority,[nTrials,nClasses]));
                                [kappas(f),accs(f)]=get_kappa(res(f).expected,aux);

                        end


		end

		function [clazz,multiple]=voteEval(self,idxs)
			map=self.trainMap;
                        nTrials=size(map{1},4);
                        nClasses=size(map{1},5);
			%res=self.result.train;
			mayority=zeros(size(map,5),size(map,6));
                        [ss,ls,sets]=self.map(idxs);
			for i=1:length(idxs)
                                mayority=mayority+map{1}(ss(i),ls(i),sets(i),:,:);%max(abs(map{s,l,set}.predicted(:)));
				%mayority=mayority+map{s,l,set}.predicted;%max(abs(map{s,l,set}.predicted(:)));
				
			end
                        multiple=KappaHelper.processVotesArray(reshape(mayority,[nTrials,nClasses]));
			clazz=multiple(1);


		end

		function [segment,level,set]=map(self,idx)

			segment=floor((idx-1)./(self.segLen))+1;                                                    
			level=mod(floor((idx-1)/2),floor(self.segLen/2))+1;
			set=mod(mod((idx-1),self.segLen),2)+1;

			
		end

		function [idx]=unmap(self,segment,level,set)

			idx=(segment-1)*self.segLen;
			idx=idx+(level-1)*2+(set-1);
			idx=idx+1;
			%level=mod(floor((idx-1)/2),self.segLen/2)+1;
			%set=mod(mod((idx-1),self.segLen),2)+1;

			
		end

                function [fit]=getFitness(self,idx)
                        % getFitness 
                        % inputs: idx
                        % outputs: fit
                        [kappas]=self.voteTest(idx);
                        fit=median(kappas);
                end
	end
end

function [kappa,acc] = get_kappa(expected,predicted)

        classCnt=max(3);
        confusion=accumarray([expected,predicted],ones(length(predicted),1),[classCnt,classCnt]);
        [kappa,acc]=kappa1(confusion);


end
