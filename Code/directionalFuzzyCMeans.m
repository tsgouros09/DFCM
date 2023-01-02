function [c w]=directionalFuzzyCMeans(th,N,m)
% CIRCULARFUZZYCMEANS clustering algorithm for Directional and 
% Non-Directional data.
% 
% CirularFuzzyCMeans clusters Directional and Non-Directional data into N 
% clusters.
% 
% [C] = circFuzzyCMeans(x,N) clusters data x into N clusters and returns the 
% clusters' centres C.
%
% [C] = circFuzzyCMeans(x,N,m) gives value to fuzzifier m. Default value is 
% m=2
% 
% [C, W] = circFuzzyCMeans(...) also returns each data point's membership 
% value W.
% 
% by Thomas Sgouros & Nikolaos Mitianoudis

if nargin<2
    m = 2;
end
c = ones(N);
% while abs(c(1)-c(2))<abs(1e-1)
th=atan(tan(th));
if size(th,1)==2
    x=[cos(th(2,:)).*cos(th(1,:));cos(th(2,:)).*sin(th(1,:));sin(th(2,:))];
elseif size(th,1)==3
    x=[cos(th(3,:)).*cos(th(2,:)).*cos(th(1,:));cos(th(3,:)).*cos(th(2,:)).*sin(th(1,:));cos(th(3,:)).*sin(th(2,:));sin(th(3,:))];
else
    x=[cos(th);sin(th)];
end
[n M]=size(x);
c=randn(n,N);
c=c./norm(c);
h=0.1;
m=2;
K=0;
err=[];
while K<100
    K=K+1;
    for i=1:N
        sum1=abs(1-abs(c(:,i)'*x));
        sum2=0;
        for j=1:N
            tmp=abs(1-abs(c(:,j)'*x));
            sum2=sum2+(sum1./(tmp+eps)).^(1/(m-1));
        end
        w(i,:)=1./(sum2+eps);
    end
    for i=1:N
        tmp1=w(i,:).^m.*(1-abs(c(:,i)'*x))./(abs((1-abs(c(:,i)'*x)))+eps)./(abs(c(:,i)'*x));
        tmp1=repmat(tmp1,n,1).*x;
        sumWX=sum(tmp1,2);
        sumW=sum(w(i,:).^m,2);
        cNew(:,i)=c(:,i)-h*sumWX;
        cNew(:,i)=cNew(:,i)./norm(cNew(:,i));
    end
    cNew = atan(tan(cNew));
    err=[err sum(sum((cNew-c).^2))];
    if norm(cNew-c)<=1e-8
        c=cNew;
        break;
    end
    c=cNew;
end
if size(th,1)==2
    c(1,:)=atan(c(2,:)./c(1,:)); 
    c(2,:)=atan(c(3,:).*sin(c(1,:))./(c(2,:)+eps));
    c(3,:)=[];
elseif size(th,1)==3
    c(1,:)=atan(c(2,:)./c(1,:)); 
    c(2,:)=atan(c(3,:).*sin(c(1,:))./(c(2,:)+eps));
    c(3,:)=atan(c(4,:).*sin(c(2,:))./(c(3,:)+eps));
    c(4,:)=[];
else
    c = atan(c(2,:)./c(1,:));
end
% end
%  plot(err);