classdef LdaClassifier < handle
	properties
		ldaRes
		classNo
		trialNo
		model=[];
	end

	methods
		function self=LdaClassifier()
			self.ldaRes={};
			self.classNo=-1;
			self.trialNo=-1;
		end	
		
		function [self]=setModel(self,model)
			% setModel 
			% inputs: model
			% outputs: self
		
			self.model=model;
		end


		function self=train(self,data)
			%Logger.debug('LdaTrain');
			self.trialNo=size(data.X,2);
			self.classNo=max(data.Y);
			labels=getSimplfiedLabels(self,data);
			for k=1:self.classNo
			    self.ldaRes{k}=ldaMine([data.X' labels(:,k)]); % different from the lda in stprtool
			end
			if~isempty(self.model)
				self.model.addLda(data.meta.segment,data.meta.level,self.ldaRes);
			end
			
		end
		function result=test(self,data)
			testTrials=size(data.Y);
			%x=data.X';	
                        linears=[];
                        constants=[];
                        for i =1:length(self.ldaRes)
                                linears(i,:)=self.ldaRes{i}.linear;
                                constants(i)=self.ldaRes{i}.constant;
                        end
			for t=1:testTrials
                                                
				ypredicts(t,:)=ldaClassifier(linears,constants,data.X(:,t));
			end
			result=Result(data.Y,ypredicts);
			%KappaHelper.processVotes(result);
				
		end
                function labels=getSimplfiedLabels(self,data)
                        labels=ones(self.trialNo,self.classNo);
                        for i=1:self.trialNo;
                            labels(i,data.Y(i))=2;
                        end
                end
	end

end
