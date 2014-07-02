function [S,D]=ldb(start,stop,seglen,discFunc)
% returns the best segments and their discriminant criteria result for the separability of different classes.
% start first index of signal(s) to start
% stop last index to consider while calculating ldb (no calculations will be performed further that index)
% seglen min segment size to take into account during the merge/divide procedure
% discFunction discriminant funciton, this function only accepts the segment [start stop] as argument, data fixing MUST be done
%		before calling this function using currying. The smallest the value returned by this function the better is the 
%		discrimination of the segment
%		EG:
%               trials=loadData
%		f= @(seg)myDiscFunctionBasedOnLocalCosine(trials,seg)
%               ldb(1,2500,500,f)

	if nargin==0
		allTests();
		return;
	end
%	S=[[start stop]];
%	D=[[0]]
%	disp('WWWAAARRRRNIIINNNNNGG DOGGY CODE IN USE!!!!!!');
%	return;
	cache=java.util.HashMap;
	%init first mother and offsping
	l=[start start+seglen-1];
	m=merge(l,seglen);
	r=shift(l,seglen,1);
	rightMost=m(2);
	S=[];
	D=[];
	while rightMost <= stop
		dm=computeDiscrimant(m,cache,discFunc);
		dl=computeDiscrimant(l,cache,discFunc);
		dr=computeDiscrimant(r,cache,discFunc);
		state=computeState(dm,dl,dr);
		if state==C_STATE
			[S,D]=insert(l,dl,S,D);
		else
			[S,D]=insert(m,dm,S,D);
		end
		[m,l,r]=updateSegments(m,l,r,state,seglen);
		rightMost=m(2);
		
	end
	%get rid of repeated rows
	[S,idx]=unique(S,'rows');
	D=D(idx);
	%sort based on dist;
	[D,idx]=sort(D);
	S=S(idx,:);
	%first small segment usually is not that good, algorithm design flaw!!!
	toDel=[];
	for dIdx=2:length(D)
		if D(dIdx)/D(1) < 0.3
			toDel=[toDel dIdx];
		end
	end
	D(toDel)=[];
	S(toDel,:)=[];
end




function [S,D]=insert(newSeg,newDist,S,D)
	if size(S,1)~=0 && S(size(S,1),1)==newSeg(1)
		S(size(S,1),:)=newSeg;
		D(size(D,2))=newDist;
	else
		S=[S; newSeg];
		D=[D newDist];
	end

end

function disc=computeDiscrimant(seg,cache,distFunc)

%calls the given function to compute the discriminance value for this segment, manages the cache to avoid recomputing vals
%seg segment to compute
%cache cache to store the computed data
%distFunc function to call, this function has only one argument which is the segment to take from the signals
%	  everything else must be curryfied
	segStr=sprintf('%i,%i',seg(1),seg(2));
	if containsKey(cache,segStr)==0
		disc=distFunc(seg);
		put(cache,segStr,disc);
	else
		disc=get(cache,segStr);
	end
end

function nsegment=shift(segment,seglen,minSize)
% shifts and divides the segment
% segment: vector with two indeces which define a segment
% seglen:  segment min segment
	nsegment=[segment(1)+seglen segment(2)+seglen];
	if nsegment(2)-nsegment(1) > seglen*minSize
		nsegment(1)=nsegment(1)+seglen;
	end

end


function state=computeState(dM,dL,dR)
	[temp,minInd]=min([dM,dL]);

	if minInd == 1
		state=M_STATE;
	else
		state=C_STATE;
	end
end
function nsegment=merge(segment,seglen)
% merges the segment with a new portion
% segment: orig segment 
% seglen: seglen to add
	nsegment=[segment(1) segment(2)+seglen];
end

function [nm,nl,nr]=updateSegments(m,l,r,state,seglen)
% updates the mother and left-right children segments 
% m: mother segment
% l: left child segment
% r: right child segment 
% current state after discrimimance evaluation

	if state==M_STATE
		nl=m;
		nr=shift(r,seglen,1);
		nm=merge(m,seglen);
	elseif state==C_STATE
		nm=shift(m,seglen,2);
		nl=r;
		nr=shift(r,seglen,1);
	end

end


%%CONST%%%
function v=M_STATE(); v=0; end
function v=C_STATE(); v=1; end

%%%%% TESTS %%%%%%%%

function allTests()
	tests={};
	tests{end+1}=@testShift;
	tests{end+1}=@testMerge;
	tests{end+1}=@testUpdateSegmentsMother;
	tests{end+1}=@testUpdateSegmentsChildren;
	tests{end+1}=@testCalculateState;
	tests{end+1}=@testCachedDiscriminant;
	tests{end+1}=@testNonCachedDiscriminant;
	tests{end+1}=@testLdb;
	testSuite(tests);
end

function disc=auxDisc(seg)
	data=[0 0 1 1 -1 -1 1 1 -1 -1];
	disc=sum(data(seg(1):seg(2)));
	disc=abs(disc);
end

function testLdb()
	f=@auxDisc;
	[s,d] = ldb(1,10,2,f);
	assertAll([0 0 0]==d);
	[1 2;3 6;7 10]==s;
	assertAll([1 2;3 6;7 10]==s);
end


function testNonCachedDiscriminant()
	cache=java.util.HashMap;
	seg=[1,10];
	distFunc=@(seg) 90;
	disc=computeDiscrimant(seg,cache,distFunc);
	assert(disc==90);
	
end

function testCachedDiscriminant()
	cache=java.util.HashMap;
	seg=[1,10];
	strSeg=sprintf('%i,%i',seg(1),seg(2));
	put(cache,strSeg,10);
	disc=computeDiscrimant(seg,cache,0);
	assert(disc==10);
	
end

function testCalculateState()
	dM1=5;
	dM2=20;
	dL=10;
	dR=15;
	dR2=7;
	assert(M_STATE==computeState(dM1,dL,dR));
	assert(C_STATE==computeState(dM2,dL,dR));
	assert(C_STATE==computeState(dM2,dL,dR2));

end

function testUpdateSegmentsChildren()
	m=[1 15];
	l=[1 10];
	r=[11 15];
	[nm,nl,nr]=updateSegments(m,l,r,C_STATE,5);
	assertAll([11 20]==nm);
	assertAll([11 15]==nl);
	assertAll([16 20]==nr);
end
function testUpdateSegmentsMother()
	m=[1 10];
	l=[1 5];
	r=[6 10];
	[nm,nl,nr]=updateSegments(m,l,r,M_STATE,5);
	assertAll([1 15]==nm);
	assertAll([1 10]==nl);
	assertAll([11 15]==nr);

end


function testShift()

	seg=[1,10];
	seglen=5;
	seglen2=10;

	nsegA=shift(seg,seglen,1);
	nsegB=shift(seg,seglen2,1);

	assertAll([11,15]==nsegA);
	assertAll([11,20]==nsegB);
	
end

function testMerge()

	seg=[1,10];
	seglen=5;
	nseg=merge(seg,seglen);
	assertAll([1,15]==nseg);
	
end
