function ldbCsp(outputPath,inputPath,p,set)
% Load EEG signals and class labels
for cross=0:1
	for user=[1:9 11:13 101:114]
		clearvars data 
		data.user=user;
		disp('Loading data ...');
		xfile=sprintf( '%s/x%d.mat', inputPath,user);
		yfile=sprintf( '%s/y%d.mat', inputPath,user);
		xefile=sprintf('%s/xe%d.mat',inputPath,user);
		yefile=sprintf('%s/ye%d.mat',inputPath,user);
		load(xfile);
		load(yfile);
		load(xefile);
		load(yefile);
		res=[];
		maxFeat=4;
		for featNum=1:maxFeat
			p.m=featNum
			% Obtain confusion matrixes at every time point in each fold
			if cross==1
				    [ldaRes, projM, preds,confusion2,segs,dists]=cspLdaNfolderLdbValidation(x, y, p);
			else

				    [ldaRes, projM, preds,confusion2,segs,dists]=cspLdaTestSetLdbValidation(x, y, xe, ye,p);

			end
			data.feat{featNum}=struct;
			data.feat{featNum}.preds=preds;
			data.feat{featNum}.projM=projM;
			data.feat{featNum}.p=p;
			data.feat{featNum}.segs=segs;
			data.feat{featNum}.dists=dists;
			nFolds=length(confusion2);

			classNo=length(ldaRes{1});

			for f=1:nFolds
				kappa{f}=[];
				acc{f}=[];
				for s=1:size(confusion2{f},2)
					[kappa{f}(s),acc{f}(s)]=kappa1(confusion2{f}{s});
				end
				kappa{f}
			end
			a=[]; for i=1:nFolds; a=[a kappa{i}(1,size(kappa{i},2))]; end; 
			meanKappa=mean(a)
			a=[]; for i=1:nFolds; a=[a acc{i}(1,size(acc{i},2))]; end; 
			meanAcc=mean(a);
			segm=0;
%			for s=1:size(segs,1)
%				segm=segm+(segs(s,2)-segs(s,1));	
%			end
%			segm=segm/size(segs,1)
			res=[res;featNum, meanKappa,meanAcc ];

		end
		disp('writing results to file');
		disp('writing sdfsdadsf to file');
		if cross==1
			dir='x';
		else
			dir='e';
		end
		setStr=sprintf('/set_%d/',set);
		disp('seriously');
		dir=strcat(dir,'_',func2str(p.featureExtractor));
		dir=strcat(dir,'_',func2str(p.discriminantCalculator));
		dir=sprintf('%s_%i/',dir,p.seg);
                FSUtils.mkdir(FSUtils.checkPath(outputPath));
		setPath=strcat(outputPath,setStr);
                FSUtils.mkdir(FSUtils.checkPath(setPath));
		dir=strcat(setPath,dir);
                FSUtils.mkdir(FSUtils.checkPath(dir));
		save(sprintf('%s/data_user%d.mat',dir,user),'data');
		fd=fopen(sprintf('%s/user%d.txt',dir,user),'w');
		fprintf(fd,'iter\tKappa\tAccuracy\n');
		for fn=1:maxFeat
			fprintf(fd,'%f\t%f\t%f\n',res(fn,:));
		end
		fclose(fd)
	end
end
