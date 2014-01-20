classdef DataTestCase < TestCase
	properties
		data
		data2
	end

	methods
        	function self = DataTestCase(name)
                	self = self@TestCase(name);
	        end
		function setUp(self)
			x=[];
			x(:,1,1)=[11];
			x(:,1,2)=[12];
			x(:,1,3)=[22];
			x(:,1,4)=[55];
			x(:,1,5)=[33];
			y=[1 1 2 2 3]';

			x2(:,1,1)=[1,11];
			x2(:,1,2)=[2,12];
			x2(:,1,3)=[3,22];
			x2(:,1,4)=[4,55];
			x2(:,1,5)=[5,33];
			x2(:,2,1)=[1,11];
			x2(:,2,2)=[2,12];
			x2(:,2,3)=[3,22];
			x2(:,2,4)=[4,55];
			x2(:,2,5)=[5,33];
			self.data=Data(x,y);
			self.data2=Data(x2,y);
		end

		function testGetRidOf(self)
			self.data=self.data.getRidOf([2,1]);
			Logger.debug(sprintf('size y test: %i',size(self.data.Y,2)))
			assertEqual(self.data.X,[[33]]);
			assertEqual(self.data.Y,[3]);
		end

		function testDelete(self)
			self.data=self.data.delete();
			assertEqual(self.data.X,[]);
			assertEqual(self.data.Y,[]);
		end
		function testFold(self)
			[t,ts]=self.data.getFold(1,5);
			assertEqual(ts.X(:),11);
			assertEqual(t.X(:),[12,22,55,33]');
			[t,ts]=self.data.getFold(2,5);
			assertEqual(ts.X(:),12);
			assertEqual(t.X(:),[11,22,55,33]');
			[t,ts]=self.data.getFold(2,2);
			assertEqual(ts.X(:),[22,55,33]');
			assertEqual(t.X(:),[11,12]');
		end
		function testMerge(self)
			merged=self.data2.merge(self.data2);
			assertEqual(size(self.data2.X),[2,2,10]);
			assertEqual(size(self.data2.Y),[10 1]);
		end

		function metaClassTest(self)
			metac=self.data.metaClass(1);	
			assertEqual(metac.Y,[1 1 2 2 2]');

			metac=self.data.metaClass(2);	
			assertEqual(metac.Y,[2 2 1 1 2]');

			metac=self.data.metaClass(3);	
			assertEqual(metac.Y,[2 2 2 2 1]');
		end

		function cloneTest(self)
			% cloneTest 
			% inputs: self
			% outputs: 

			d2=self.data.clone();
			d2.X(1,1,1)=11000;
			assertEqual(self.data.X(1,1,1),11);
			
		end

		
	end

end
