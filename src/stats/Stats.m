classdef Stats
	properties

	end
	methods(Static)
		function [entropy]=entropy(X)
			entropy=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				trial=X(:,:,t);
				for c=1:size(X,2)
					trial(:,c)=(trial(:,c).^2)/sum(trial(:,c).^2);
				end
				%trial=trial.^2;
				ltrial=log(trial);
				entropy(:,t)=-1*sum(trial.*ltrial)/log(size(X,1));
				%entropy(:,t)=Stats.normalize(entropy(:,t));
			end
		end


		function [means]=means(X)
			means=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				m=mean(X(:,:,t));
				means(:,t)=Stats.normalize(m);
			end
		end

		function [n]=normalize(s)
			n=(s-min(s))/(max(s)-min(s));
			
			%n=log(n/sum(n));
		end
		

		function [avg]=averageSignal(S,winlen,over)
			nSample=size(S,1);
			nwin=floor((nSample-winlen)/over);
			pos=1:winlen-over:nSample-winlen+1;
			nwin=length(pos);
			avg=zeros(nwin,size(S,2));
			j=1;
			for i=pos
				avg(j,:)=mean(S(i:i+winlen-1,:));
				j=j+1;
			end
				
		end
		
		function [avg]=averageVar(S,winlen,over)
			nSample=size(S,1);
			nwin=floor((nSample-winlen)/over);
			pos=1:winlen-over:nSample-winlen+1;
			nwin=length(pos);
			avg=zeros(nwin,size(S,2));
			j=1;
			for i=pos
				avg(j,:)=var(S(i:i+winlen-1,:));
				j=j+1;
			end
				
		end

		function [avgPower]=samplePower(X)
				avgPower=zeros(size(X,1),size(X,2));
				for s=1:size(d,1)
					for c=1:size(d,2)
						avgPower(s,c)=sum(d(s,c,:).^2)/size(d,3);			
					end
				end
				
		end

		function [avgVar]=sampleVar(X)
				d=X.^2;
				avgVar=zeros(size(X,1),size(X,2));
				for s=1:size(d,1)
					for c=1:size(d,2)
						avgVar(s,c)=var(d(s,c,:));			
					end
				end
				
		end
		
		function [pxx]=getPSD(X)
			pxx=[];	
			for t=1:size(X,3)
				f=[];
				for c=1:size(X,2)
					[psd]=pwelch(X(:,c,t));	
					%psd
					%pause

					f=[f sum(psd.^2)];	
				end
				pxx(:,t)=f;
			end
		end

		function [medians]=medians(X)
			medians=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				m=median(X(:,:,t));
				medians(:,t)=m;
			end
		end


		function [stds]=avStds(X)
			%IN 
			%stds=zeros(size(X,2),size(X,3));
			stds=[];
			win=floor(size(X,2)/4);
			over=floor(win/3);
			for t=1:size(X,3)
				s=Stats.averageVar(X(:,:,t),win,over);
				s=bsxfun(@rdivide,s,var(s));	
				stds(:,t)=var(s);
			end
				
		end
		

		function [fff]=fft(X)
			fff=[];
			for t=1:size(X,3)
				fff(:,t)=sum(fft(X(:,:,t).^2));

			end
				
		end
		
		function [an]=anova(X)
			an=[];
			for t=1:size(X,3)
				[p,table]=anova1(X);
				an(:,t)=[p table(2,2) table(2,3)];
			end
			
		end
		function [x]=windowAverage(x,winsize,over)

		end

		function [kurtosisis]=kurtosisis(X)
			kurtosisis=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				m=kurtosis(X(:,:,t));
				m=Stats.normalize(m);
				kurtosisis(:,t)=m;
			end
		end

		function [skwenesses]=skwenesses(X)
			skwenesses=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				m=skewness(X(:,:,t));
				m=log(m/sum(m));
				skwenesses(:,t)=m;
			end
		end


		function [vars]=var(X)
			vars=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				vars(:,t)=var(X(:,:,t));
				%stds(:,t)=Stats.normalize(stds(:,t));
				%stds(:,t)=stds(:,t)/sum(stds(:,t));
			end
		end
		
		function [energy]=energy(X)
			energy=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				e=sum(X(:,:,t).^2);%/size(X,2);
				%e=Stats.normalize(e);
				energy(:,t)=log(e);
			end
			
		end

		function [d]=bipolarize(X)
			d=zeros(size(X,1),size(X,2)/2);
			d(:,1)=X(:,1)-X(:,6);	
			d(:,2)=X(:,2)-X(:,7);	
			d(:,3)=X(:,3)-X(:,8);	
			d(:,4)=X(:,4)-X(:,9);	
			d(:,5)=X(:,5)-X(:,10);	
			d(:,6)=X(:,6)-X(:,11);	
			d(:,7)=X(:,7)-X(:,12);	
			d(:,8)=X(:,8)-X(:,13);	
			d(:,9)=X(:,9)-X(:,14);	
			d(:,10)=X(:,10)-X(:,15);	
		end
		
		

		function [bps]=balancedPower(X)
			bps=[]; 
			for i=1:size(X,3)
				left=[ 1 2 6 7 11 12 ]; 
				right= [ 3 4 5 8 9 10 13 14 15];
				left2=[ 1 2 3 6 7 8 11 12 13 ]; 
				right2= [  4 5 9 10 14 15];
				lpowers= sum(X(:,left,i).^2)./length(X(:,1,i));
				rpowers= sum(X(:,right,i).^2)./length(X(:,1,i));
				feat= (sum(lpowers)-sum(rpowers))/(sum(lpowers)+sum(rpowers));
				bps(:,i)=feat;
			end
%			lpowers= sum(X(:,left2).^2)./length(X(:,1));
%			rpowers= sum(X(:,right2).^2)./length(X(:,1));
%			feat= [feat (sum(lpowers)-sum(rpowers))/(sum(lpowers)+sum(rpowers))];
		end
		function [bps]=balancedStds(X)
			bps=[]; 
			for i=1:size(X,3)
				left=[ 1 2 6 7 11 12 ]; 
				right= [ 3 4 5 8 9 10 13 14 15];
				left2=[ 1 2 3 6 7 8 11 12 13 ]; 
				right2= [  4 5 9 10 14 15];
				lpowers= var(X(:,left,i));
				rpowers= var(X(:,right,i));
				feat= (sum(lpowers)-sum(rpowers))/(sum(lpowers)+sum(rpowers));
				bps(:,i)=feat;
			end
		end	
		function apen = approximateEntroopy( X )
			apen=zeros(size(X,2),size(X,3));
			for t=1:size(X,3)
				Logger.debug('trial %i',t);
				for c=1:size(X,2)
					apen(c,t)=Stats.ApEn(2,0.2*std(X(:,c,t)),X(:,c,t));	
				end
			end
			
		end	
		function apen = ApEn( dim, r, data, tau )
			%ApEn
			%   dim : embedded dimension
			%   r : tolerance (typically 0.2 * std)
			%   data : time-series data
			%   tau : delay time for downsampling

			%   Changes in version 1
			%       Ver 0 had a minor error in the final step of calculating ApEn
			%       because it took logarithm after summation of phi's.
			%       In Ver 1, I restored the definition according to original paper's
			%       definition, to be consistent with most of the work in the
			%       literature. Note that this definition won't work for Sample
			%       Entropy which doesn't count self-matching case, because the count 
			%       can be zero and logarithm can fail.
			%
			%       A new parameter tau is added in the input argument list, so the users
			%       can apply ApEn on downsampled data by skipping by tau. 
			%---------------------------------------------------------------------
			% coded by Kijoon Lee,  kjlee@ntu.edu.sg
			% Ver 0 : Aug 4th, 2011
			% Ver 1 : Mar 21st, 2012
			%---------------------------------------------------------------------
			if nargin < 4, tau = 1; end
			if tau > 1, data = downsample(data, tau); end

			N = length(data);
			result = zeros(1,2);

			for j = 1:2
				m = dim+j-1;
				phi = zeros(1,N-m+1);
				dataMat = zeros(m,N-m+1);

				% setting up data matrix
				for i = 1:m
					dataMat(i,:) = data(i:N-m+i);
				end
				% counting similar patterns using distance calculation
				for i = 1:N-m+1
					tempMat = abs(bsxfun(@minus,dataMat,dataMat(:,i)));
					boolMat = any( (tempMat <= r),1);
					phi(i) =sum(boolMat)/(N-m+1);
				end

				% summing over the counts
				result(j) = sum(log(phi))/(N-m+1);
			end

			apen = result(1)-result(2);

		end
		%2dim dist for apen
		function [d]=ApEnDist(X,i,j,m)
			dif=zeros(m-1,size(X,2));
			for k=1:m-1
				dif(k,:)=abs(X(i+k,:)-X(j+k,:));
			end
			d=max(dif,[],1);
			assert(size(d,1)==1);
			assert(size(d,2)==size(X,2));
		end
		
		
	end
end
