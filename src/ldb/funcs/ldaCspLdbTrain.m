function [ldaRes, projM]=ldaCspLdbTrain(xTrain, yTrain, p,segs)
% One-against-the-rest LDA classification over multiple trials
% Input:
%       xTrain: 3D EEG data from multiple trials: 
%               1st Dim - sampling points, 2nd Dim - channels, 3rd Dim - trials.
%       yTrain: a column vector of true class labels, ranging from 1 to the number of classes.
%       p:      parameters.
% Output:
%       ldaRes: lda models for multiple classes: ldaRes{k}.linear and ldaRes{k}.constant.
%       projM:  projection matrixes for feature extraction, one for each time point.
% By John Q. Gan, 09-11-2004

disp('Producing projection matrixes and LDA ...');
trialNo=length(yTrain);
classNo=max(yTrain);
yLabel=ones(trialNo,classNo);
for i=1:trialNo;
    yLabel(i,yTrain(i))=2;
end
trainData=[];
trainLabel=[];
for s=1:size(segs,1)
	trainData{s}=[];
	trainLabel{s}=[];	 
	seg=segs(s,:);
	fprintf('using seg %i,%i\n',seg(1),seg(2))
	projM{s}=cspProjMatrix(xTrain(seg(1)-p.over:seg(2)+p.over,:,:), yTrain);
	for i=1:trialNo
	    feature=cspFeature(projM{s}, xTrain(seg(1)-p.over:seg(2)+p.over,:,i), p.m);
	    %feature=[feature ;seg(1); seg(2)-seg(1)];
	    trainData{s}=[trainData{s}; feature];
	    %trainData=[trainData; feature'];
	end
	trainLabel{s}= yLabel;
	%trainLabel=[ trainLabel ; yLabel];
end
trainLabel
for s=1:size(segs,1)
	for k=1:classNo
	    ldaRes{s}{k}=ldaMine([trainData{s} trainLabel{s}(:,k)]); % different from the lda in stprtool
	    %ldaRes{k}=ldaMine([trainData trainLabel(:,k)]); % different from the lda in stprtool
	end
end
