function [confusion,predData]=ldaMultiTrialLdbTest(ldaRes, projM, xTest, yTest, p, fold, confusion,segs,acc)
% One-against-the-rest LDA classification over multiple trials
% Input:
%       ldaRes:     lda models for multiple classes: ldaRes{k}.linear and ldaRes{k}.constant.
%       projM:      projection matrixes for feature extraction, one for each time point.
%       xTest:      3D EEG data from multiple trials: 
%                   1st Dim - sampling points, 2nd Dim - channels, 3rd Dim - trials.
%       yTest:      a column vector of true class labels, ranging from 1 to the number of classes.
%       p:          parameters.
%       fold:       fold index.
%       confusion:  cells of 3D confusion matrixes.
% Output:
%       confusion:  
%       predData.pred -> prediction by trial,sample
%	predData.expected -> expected trial output trial,sample
% By John Q. Gan, 09-11-2004

disp('Multiple trial testing ...');
trialNo=length(yTest);
classNo=length(ldaRes);
for i=1:trialNo
    [yPredictVoting(i,:),ypreds(i,:,:)]=ldaOneTrialLdbPredict(ldaRes, projM, xTest(:,:,i), p,segs,acc);
end
sampleNo=size(yPredictVoting,2);
for s=1:sampleNo
    for i=1:trialNo
        confusion{fold}{s}(yTest(i),yPredictVoting(i,s))=confusion{fold}{s}(yTest(i),yPredictVoting(i,s))+1;
    	yexpected(i,s,:)=yTest(i);
    end
end

predData.pred=ypreds;
predData.expected =yexpected;
