classdef LdaClassifierProvider < Provider
	properties
		model=[]
	end
	methods

		function [self]=setModel(self,model)
			% name 
			% inputs: vargsin
			% outputs: self
		
			self.model=model;
		end

		function classifier=new(self)
			classifier=LdaClassifier();
			classifier.setModel(self.model);
		end 
	end

end
