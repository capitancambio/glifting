function res = ldaMine(data)

% Linear discriminant analysis for 2-class data
%
% Input:    data: training data matrix in which each row is a sample point 
%           with the last column being the class label (1 or 2)
%
% Output:
%
% res.constant  : constant term in the discriminant rule
% res.linear    : linear term in the discriminant rule (vector)
% res.scores    : the scores of the discriminant rule for all the 
%                 observations in the training sample
% res.group     : classifications for all the observations in the 
%                 training sample (1 or 2)
% res.miscl     : fraction of misclassified observations
%
% Modification of the da program by Christophe Croux. Modified by John Q. Gan 2004

[n,p] = size(data);

dim = p-1;
X1 = data(find(data(:,p)==1),1:dim);
X2 = data(find(data(:,p)==2),1:dim);
n1 = size(X1,1);
n2 = n-n1;
mu1  = mean(X1); mu2  = mean(X2);
cov1 = cov(X1);  cov2 = cov(X2); % use the cov.m in biosig_toolbox to cope with NaN
sigma  = (n1*cov1+n2*cov2)/n; %some elements are NaN 
linear   = (mu1-mu2)*pinv(sigma);
%res.linear   = (mu1-mu2)*inv(sigma);
% res.constant = 1/2*res.linear*(mu1+mu2)';
constant = linear*(n1*mu1+n2*mu2)'/n;
res=struct('linear',linear,'constant',constant);
%res.scores   = res.linear*data(1:n,1:dim)' - res.constant ;
%res.group  = (res.scores < 0) + 1; %score<0 for class 2, score>0 for class 1
%res.miscl = mean(res.group ~= data(:,p)');
