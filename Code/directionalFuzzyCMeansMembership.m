function [w]=directionalCMeansMembership(th,c)

th=atan(tan(th));
% 
    if size(th,1)==2
%         z1=[cos(y);sin(y)];
        x=[cos(th(2,:)).*cos(th(1,:));cos(th(2,:)).*sin(th(1,:));sin(th(2,:))];
        c=[cos(c(2,:)).*cos(c(1,:));cos(c(2,:)).*sin(c(1,:));sin(c(2,:))];
%         x=th;
    elseif size(th,1)==3
        x=[cos(th(3,:)).*cos(th(2,:)).*cos(th(1,:));cos(th(3,:)).*cos(th(2,:)).*sin(th(1,:));cos(th(3,:)).*sin(th(2,:));sin(th(3,:))];
        c=[cos(c(3,:)).*cos(c(2,:)).*cos(c(1,:));cos(c(3,:)).*cos(c(2,:)).*sin(c(1,:));cos(c(3,:)).*sin(c(2,:));sin(c(3,:))];
    else
        x=[cos(th);sin(th)];
        c=[cos(c);sin(c)];
    end
m = 2;
w = [];
for i=1:size(c,2)
    sum1=abs(1-abs(c(:,i)'*x));
    sum2=0;
    for j=1:size(c,2)
        tmp=abs(1-abs(c(:,j)'*x));
        sum2=sum2+(sum1./(tmp+eps)).^(1/(m-1));
    end
    w(i,:)=1./(sum2+eps);
end