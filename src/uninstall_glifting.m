disp('Uninstalling glifting');
%find the dir location
path=mfilename('fullpath');
t=findstr(path,mfilename());
path=path(1:t(1)-1);
%rmdirs
dirs=genpath(path);
[curr,dirs]=strtok(dirs,':');
while length(curr)>0
	if strcmp(curr,path)==0
		fprintf('Leaving out of path : %s \n',curr);
		rmpath(curr);
	end
	[curr,dirs]=strtok(dirs,':');
end
savepath

