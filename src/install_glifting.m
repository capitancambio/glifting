disp('Installing  glifiting');
%find the dir location
path=mfilename('fullpath');
t=strfind(path,mfilename());
path=path(1:t(1)-1);
%rmdirs
dirs=genpath(path);
[curr,dirs]=strtok(dirs,':');
while ~isempty(curr)
	if strcmp(curr,path)==0 && isempty(regexp(curr,'\.git','ONCE'))
		fprintf('Adding to path : %s \n',curr);
		addpath(curr);
	end
	[curr,dirs]=strtok(dirs,':');
end
savepath
