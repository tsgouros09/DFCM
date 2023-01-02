function u = dfcmSeparationND(z_all,th,src,nf,mf,width,ovrlp,frame,nX,nx,mX,mx)
[nz mz]=size(z_all);
thAll(1,:) = atan(z_all(2,:)./(z_all(1,:)+eps));
if nx>=3
    thAll(2,:)=atan(z_all(3,:).*sin(thAll(1,:))./(z_all(2,:)+eps));
end
if nx==4
    thAll(3,:)=atan(z_all(4,:).*sin(thAll(2,:))./(z_all(3,:)+eps));
end
[c]=directionalFuzzyCMeans(th,src,2);
[w]=directionalFuzzyCMeansMembership(thAll,c);
[maximum index] = max(w);
if nx==3
    c=[cos(c(2,:)).*cos(c(1,:));cos(c(2,:)).*sin(c(1,:));sin(c(2,:))];
elseif nx==4
    c=[cos(c(3,:)).*cos(c(2,:)).*cos(c(1,:));cos(c(3,:)).*cos(c(2,:)).*sin(c(1,:));cos(c(3,:)).*sin(c(2,:));sin(c(3,:))];
end
% us = zeros(src,mz);
for j=1:src
    t=find(index==j);
    us(j,t)=c(:,j)'*z_all(:,t);
end
[nu mu]=size(us);
Xframe_rev=zeros(nf,mf,src);
l=1;
for j=1:src
    tmp=[];
    tmpIm=[];
    tmp2=zeros(1,mu/2);
    for i=1:2*nf:mz
        tmp=[tmp complex(us(j,i:i+nf-1),us(j,i+nf:i+2*nf-1))];
    end
    l=l+3;
    tmp2(1,1:size(tmp,2))=tmp;
    Xframe_rev(:,:,j)=reshape(tmp2,nf,mf); 
end
u=iStft(Xframe_rev,width,src,ovrlp,frame,nX,mX,mx);