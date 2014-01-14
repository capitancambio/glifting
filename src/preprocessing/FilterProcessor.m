classdef FilterProcessor < PreProcessor

	properties
		A
		B
	end
	methods

		function self=FilterProcessor(Fs,lFreq,hFreq)
			Wp=[lFreq/(Fs/2),hFreq/(Fs/2)];
			Ws=[(lFreq-0.5)/(Fs/2),(hFreq+0.5)/(Fs/2)];
			Rs=30;
			Rp=3;
			[N,Wp]=ellipord(Wp,Ws,Rp,Rs);
			[B,A]=ellip(N,Rp,Rs,Wp);
			self.A=A;
			self.B=B;
		end
		function trD=doProcess(self,trD)
			Logger.debug('filtering');
			trD=self.filter(trD);
		end
		function data=filter(self,data)
			for i=1:size(data.X,2)
				for j=1:size(data.X,3)
					data.X(:,i,j)=filtfilt(self.B,self.A,data.X(:,i,j));
				end
			end
		end
	end

end
