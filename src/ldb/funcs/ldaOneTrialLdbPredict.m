function [yPredictVoting, yPredict]=ldaOneTrialLdbPredict(ldaRes, projM, x, p,segs,acc)
acc=1;
classNo=length(ldaRes{1});
for s=1:size(segs,1)
    	
    seg=segs(s,:);
    %fprintf('lda one trial predict seg %i,%i\n',seg(1),seg(2))
    feature=cspFeature(projM{s}, x(seg(1)-p.over:seg(2)+p.over,:), p.m);
    linears=[];
    constants=[];
    for i =1:length(ldaRes{s})
            lr=ldaRes{s}(i);
            linears(i,:)=lr{1}.linear;
            constants(i)=lr{1}.constant;
            
    end
    %feature=[feature; seg(1); seg(2)-seg(1)];
    yPredict(s,:)=ldaClassifier(linears, constants,feature'); %scores returned by ldaClassifier
    %yPredict(s,:)=ldaClassifier(ldaRes, feature); %scores returned by ldaClassifier
    %The above 2 lines implement one point prediction.
    for k=1:classNo
%%%	   if acc == 0
%%%	           counter(k)=sum(yPredict(s,k));
%%%	   else
	           counter(k)=sum(yPredict(1:s,k));
%	   end
	
    end
    %[temp,yPredictVoting(s)]=max(counter); %class label returned by lda Classifier
    [temp,yPredictVoting(s)]=max(-counter); %scores returned by ldaClassifier
     	
end
