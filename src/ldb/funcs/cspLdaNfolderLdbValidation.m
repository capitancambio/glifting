function [ldaRes, projM, preds,confusion2, fsegs,fd]=cspLdaNfoldLdbValidation(x, y, p)

ldaRes=[];
projM=[];
preds=[];
confusion2=[];
trialNo=length(y);
classNo=max(y);
testingTrialNo=floor(trialNo/p.foldNo);
ypreds=[];
for n=1:p.foldNo
%    fprintf('Folder %i\n',n)
    st=(n-1)*testingTrialNo+1;
    en=n*testingTrialNo;
    newX=x(:,:,[1:st-1 en+1:trialNo]); 
    newY=y([1:st-1 en+1:trialNo]);
    featureExtractor=p.featureExtractor;
    discriminantCalculator=p.discriminantCalculator;
    tdp=curriedTDA(p,newX,newY,featureExtractor,discriminantCalculator);
    [segs,d]=ldb(p.st,p.en,p.seg,tdp);
    fprintf('orig size %i',size(segs,1))  
    szSegs=ceil(size(segs,1)*p.percSegs);
    segs=segs(1:szSegs,:) ;
    %segs=[];
    %d=[];
    %for msg=p.st:p.sover:p.en
	%segs=[segs; [msg,msg+p.seg]];
	%d=[d 1]	;
    %end
    fprintf('number of segs %i\n',size(segs,1))
    confusion2{n}={};	
    for s=1:size(segs,1)
       confusion2{n}{s}=zeros(classNo,classNo);
    end
    p.dist=d;
    [ldaRes, projM]=ldaCspLdbTrain(newX,newY,p,segs);
    %performance on validation data
    [confusion2,preds]=ldaMultiTrialLdbTest(ldaRes, projM, x(:,:,st:en), y(st:en), p, n, confusion2,segs,1);
    fsegs{n}=segs;
    fd{n}=d;
    ypreds=[ypreds;preds];
end
preds=ypreds;
