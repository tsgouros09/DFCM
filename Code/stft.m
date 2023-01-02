function X=frame_wind(x,frame, ovrlp)

[nx mx]=size(x);
wind=hamming(frame)';
X=[];
for i= 1:nx
    k=1;
    while k < mx-frame
        X=[X (x(i,k:k+frame-1).*wind)'];    
        k=k+floor(ovrlp*frame);
    end
end
X=fft(X,frame);
X(frame/2+2:frame,:)=[]; 