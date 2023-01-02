function [Us]=clusterSourceSegmenting(X1frame,X2frame,th,index,src)

[nf mf]=size(X1frame);
Us=zeros(nf,mf,src);
for i = 1:src
    t = find(index == i);
    tmp1=[reshape(X1frame(:,t),1,nf*numel(t));reshape(X2frame(:,t),...
    1,nf*numel(t))];
    Us(:,t,i)=reshape([cos(th(i+1)) sin(th(i+1)) ]*tmp1,nf,numel(t));
end
