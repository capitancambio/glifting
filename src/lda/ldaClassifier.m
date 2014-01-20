function yPredict=ldaClassifier(linears,constants, x)
% Classification at a time point
% Input:
%       ldaRes: lda models for multiple classes: ldaRes{k}.linear and ldaRes{k}.constant.
%       x:      1D input, e.g., a column feature vector at a time point.
% Output:
%       yPredict: predicted output, ranging from 1 to the number of classes.
% By John Q. Gan, 09-11-2004

classNo=size(linears,1);
yPredict=zeros(1,classNo);
for k=1:classNo
    yPredict(k)=linears(k,:)*x-constants(k);
end
%[temp, yPredict]=max(-score); %return a class label
