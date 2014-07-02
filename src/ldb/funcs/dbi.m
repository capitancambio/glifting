function dbi=DBIFunc(X,y)
%Davies Bouldin Index (DBI) Calculation
%John Q. Gan 02-03-2007
%X is a matrix with each row being a feature vector
%y is a vector of class labels: 1,2,...,classNo

[sampleNo, featureDim]=size(X);
classNo=max(y);

for k=1:classNo
    ind(:,k)=(y==k);
    N(k)=sum(y==k);
end

for k=1:classNo
    F=X(ind(:,k),:);
    M(k,:)=mean(F,1); %a row vector
    S(k)=sqrt(sum(sum((F-ones(N(k),1)*M(k,:)).^2))/N(k)); 
end
dbi=0;
for k=1:classNo
   	Rmax=0;
    for l=1:classNo
        if l~=k
            R=(S(k)+S(l))/sqrt(sum((M(k,:)-M(l,:)).^2));
            if R>Rmax
                Rmax=R;
            end
        end
    end
    dbi=dbi+Rmax;
end
dbi=dbi/classNo;
