function [u] = dfcmSeparation(X1Frame,X2Frame,thAll,thHigh,src,width,ovrlp,frame,nX,mx,mX)

[c]=directionalFuzzyCMeans(thHigh,src);
[w]=directionalFuzzyCMeansMembership(thAll,c);
[maximum index] = max(w);
[Us]=clusterSourceSegmenting(X1Frame,X2Frame,thAll,index,src);
u=[];
u=iStft(Us,width,src,ovrlp,frame,nX,mX,mx);