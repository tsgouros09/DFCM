function y=iStft(Us,width,src,ovrlp,frame,nX,mX,mx)

y=[];
for i=1:src;
%     for k2=1:Nco;   
    tmpF=squeeze(Us(:,:,i));
%        tmpF=Us(:,(i-1)*mf+1:i*mf);
   tmpFour=col2im(tmpF,[width width],[nX, mX],'distinct');
   tmpFour=[tmpFour; conj(flipud(tmpFour(2:frame/2,:)))];
   tmpTime=real(ifft(tmpFour)); 
       us=zeros(1,mx);
       
       pntr=1;
       for j=1:mX
          uxx=zeros(1,mx);
          uxx(1,pntr:pntr+frame-1)=ovrlp*tmpTime(:,j)';
          us=us+uxx;
          pntr=pntr+floor(ovrlp*frame);
      end
      y=[y; us];

%    end
end