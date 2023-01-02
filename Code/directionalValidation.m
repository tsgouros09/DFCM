function [clusters clusterCenters]=directionalValidation(th,m)
%CIRCULARVALIDATION Cluster Validation for Directional and Non-Directional
% Data
%
% CIRCULARVALIDATION counts the possible number of clusters for directional
% and non-directional data.
%
% [N] = circularValidation(x) clusters the data x and returns the possible 
% number of clusters N that are formed. 
%
% [N] = circularValidation(x,m) gives value to fuzzifier m. Default value 
% is m=2 
%
% [N, C] = circularValidation(...) also returns cluster centres C
%
% by Thomas Sgouros & Nikolaos Mitianoudis

if nargin<2
  m = 2;
end
if size(th,1)==2
    x=[cos(th(2,:)).*cos(th(1,:));cos(th(2,:)).*sin(th(1,:));sin(th(2,:))];
elseif size(th,1)==3
    x=[cos(th(3,:)).*cos(th(2,:)).*cos(th(1,:));cos(th(3,:)).*cos(th(2,:)).*sin(th(1,:));cos(th(3,:)).*sin(th(2,:));sin(th(3,:))];
else
    x=[cos(th);sin(th)];
end
xMean=sum(x,2)/size(x,2);
Rx=sqrt(sum(xMean.^2));
sigmaX=1-Rx;
rep=8;
K=0;
if size(th,1)==1
    c=zeros(rep-1,rep);
else
    c=zeros(size(th,1),rep-1,rep);
end
for i=2:rep
    [centers w]=directionalFuzzyCMeans(th,i);
    if size(th,1)==1
        c(i-1,1:i)=atan(tan(centers));
    else
        c(:,i-1,1:i)=atan(tan(centers));
    end
    xMean=sum(x,2)/size(x,2);
    Rx=sqrt(sum(xMean.^2));
    sigmaX=1-Rx;
    if size(th,1)==2
    	cCircl =[cos(centers(2,:)).*cos(centers(1,:));cos(centers(2,:)).*sin(centers(1,:));sin(centers(2,:))];
    elseif size(th,1)==3
        cCircl=[cos(centers(3,:)).*cos(centers(2,:)).*cos(centers(1,:));cos(centers(3,:)).*cos(centers(2,:)).*sin(centers(1,:));cos(centers(3,:)).*sin(centers(2,:));sin(centers(3,:))];
    else
        cCircl = [cos(c(i-1,:));sin(c(i-1,:))];
    end
    for j=1:i
        tmp=abs(1-(cCircl(:,j)'*x).^2);
        tmp=tmp.*w(j,:);
        sigmaC(j)=mean(tmp);
    end
    scat(i-1)=(sum(sigmaC)/i)/(sigmaX+eps);
    uUnder(i-1) = sum(sigmaC)/i;
    l=1;
    for j=1:i
        for k=1:i
            if j~=k
                centerDiff(l)=sqrt(abs(1- (cCircl(:,j)'*cCircl(:,k)).^2));
                l=l+1;
            end
        end
    end
    minCenterDiff=min(centerDiff);
    maxCenterDiff=max(centerDiff);
    uOver(i-1) = i/(minCenterDiff+eps);
    tmp2=0;
    for j=1:i
     squareSum=0;
        for k=1:i
            squareSum=squareSum+sqrt(abs(1- (cCircl(:,j)'*cCircl(:,k)).^2));
        end
        tmp2= tmp2+ (squareSum+eps)^(-1);
    end
    sep(i-1)=(maxCenterDiff.^2+eps)/(minCenterDiff.^2+eps)*tmp2;
    
end
for i=1:k-1
    V(i)=scat(i)+sep(i)/(sep(end)+eps);
end
uUnderMax = max(uUnder);
uUnderMin = min(uUnder);
uOverMax = max(uOver);
uOverMin = min(uOver);
uUnderN = (uUnder - uUnderMin)./(uUnderMax-uUnderMin+eps);
uOverN = (uOver - uOverMin)./(uOverMax-uOverMin+eps);
uSN = uUnderN+uOverN;
V = V + uSN;
[Y clusters]=min(V);
if size(th,1)==1
    clusterCenters=c(clusters,1:clusters+1);
else
    clusterCenters=c(:,clusters,1:clusters+1);
end
clusters=clusters+1;