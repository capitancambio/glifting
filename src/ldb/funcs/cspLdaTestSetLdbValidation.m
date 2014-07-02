function [ldaRes, projM, preds,confusion2, fsegs,fd]=cspLdaTestSetLdbValidation(x, y,xe,ye, p)
%  validation for EEG data classification based on CSP and LDA (off-line) against a test set
% Input:
%       x: 3D EEG data, 1st Dim - sampling points, 2nd Dim - channels, 
%          3 Dim - trials.
%       y: a column vector of class labels ranging from 1 to the number of classes, 
%          whose length equals the 3rd Dim of x.
%       xe: idem as x but with the validation data
%       ye: idem as y but with the validation data
%       p: parameters
%       performanceOnTrainData: a flag
% Output: 
%       ldaRes: LDA model
%       projM:  CSP projection matrix
%       confusion2, confusion1: confusion matrixes 
% By John Q. Gan, 09-11-2004
%TODO uncomment everything
ldaRes=[];
projM=[];
preds=[];
confusion2=[];
trialNo=length(y);
classNo=max(y);
testingTrialNo=floor(trialNo/p.foldNo);
featureExtractor=p.featureExtractor;
discriminantCalculator=p.discriminantCalculator;
tdp=curriedTDA(p,x,y,featureExtractor,discriminantCalculator);
[segs,d]=ldb(p.st,p.en,p.seg,tdp);
%    segs=[]
    %d=[]
    %for msg=p.st:p.sover:(p.en-p.seg)
	%segs=[segs; [msg,msg+p.seg]];
	%d=[d 1]	;
    %end
fprintf('orig size %i',size(segs,1)); 
%    for msg=p.st:p.sover:p.en
%	segs=[segs; [msg,msg+p.seg]];
%	d=[d 1]	;
%    end
fprintf('number of segs %i\n',size(segs,1))
    for s=1:size(segs,1)
       confusion2{1}{s}=zeros(classNo,classNo);
    end
    ypreds=[];
    fsegs=[];
    p.dist=d;
    [ldaRes, projM]=ldaCspLdbTrain(x,y,p,segs);
%    [confusion2,preds]=ldaMultiTrialLdbTest(ldaRes, projM, x, y, p, 1, confusion2,segs,0);
%    nsegs=[];
%    maxKappa=0;
%    kapps=[]
%    for ks=1:length(confusion2{1});
%	tKappa=kappa1(confusion2{1}{ks});
%%	if kappa1(confusion2{1}{ks})>=maxKappa
%%		nsegs=[nsegs; segs(ks,:)];
%%		maxKappa=tKappa;
%%		kapps=[kapps maxKappa];
%%	end
%	kapps=[kapps tKappa];
%    end
%    kapps
%    [vals,idxs]=sort(kapps);
%    idxs=fliplr(idxs)
%    vals=fliplr(vals)
%    otherLdaRes={};
%    otherProjMat={};
%    cnt=1;
%    for idx=1:ceil(length(idxs)*1)
%	otherProjMat{cnt}=projM{idxs(idx)};
%	otherLdaRes{cnt}=ldaRes{idxs(idx)};
%	nsegs=[nsegs; segs(idxs(idx),:)];
%        cnt=cnt+1;
%    end
%    fprintf('Diff segs %i nsegs %i\n',size(segs,1),size(nsegs,1)) 	
%    confusion2{1}={}	
%    for s=1:size(nsegs,1)
%       confusion2{1}{s}=zeros(classNo,classNo);
%    end
    preds=[];	
    %performance on validation data
    [confusion2,preds]=ldaMultiTrialLdbTest(ldaRes, projM, xe, ye, p, 1, confusion2,segs,1);

    
    ypreds=[ypreds;preds];
fsegs{1}=segs;  
fd{1}=d;
preds=ypreds;
end
