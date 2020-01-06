close all;
clear all;

x_1=audioread('dev3_female4_inst_src_1.wav')';
x_2=audioread('dev3_female4_inst_src_2.wav')';
x_3=audioread('dev3_female4_inst_src_3.wav')';
x_4=audioread('dev3_female4_inst_src_4.wav')';
x=audioread('dev3_female4_inst_mix.wav')';
X_all=[x_1;x_2;x_3;x_4];src=4;
frame=1024;ovrlp=0.2;Eig_Thres=600;width=2;

[nx mx]=size(x);

X=stft(x,frame,ovrlp);
[nX mX kX]=size(X);
mX=mX/nx;
X=reshape(X,nX,mX,nx);
[nX mX kX]=size(X);

for i=1:kX
    XframeTmp=squeeze(X(:,:,i));
    Xframe(:,:,i)=im2col(XframeTmp,[width width],'distinct');
end

[nf mf kf]=size(Xframe);
z1=[];
z_all=[];
for i=1:mf
    z=[];
    for j=1:nx
        tmp=[real(Xframe(:,i,j));imag(Xframe(:,i,j))];
        z=[z tmp];
    end
    z=z';
    ztmp=z-mean(z,2)*ones(1,2*width^2);
    Cz=ztmp*ztmp'/size(z,2);
    [V,D] = eig(Cz);
    if abs(D(nx,nx)/D(nx-1,nx-1))>Eig_Thres
        z1=[z1 z];
    end
    z_all=[z_all z];
end
Xframe=[];
[nz mz]=size(z_all);

%%%%%%%%%% Constrain dataset %%%%%%%%%%%%

th(1,:)=atan(z1(2,:)./(z1(1,:)+eps)); 
if nx>=3
    th(2,:)=atan(z1(3,:).*sin(th(1,:))./(z1(2,:)+eps));
end
if nx==4
    th(3,:)=atan(z1(4,:).*sin(th(2,:))./(z1(3,:)+eps));
end
if nx==3
    hist2d(th(1,:),th(2,:),100);
end

% Cluster Validation
[N m]=directionalValidation(th);
m = squeeze(m);
fprintf('\nThere are %d clusters',N);
fprintf('\n\nThe centres are: \n\n');
disp(m)

% Directional Clustering
[K,L] = size(X_all);
[c,w]=directionalFuzzyCMeans(th,K);
fprintf('\nThe centres are: \n\n');
disp(c)
% fprintf('The membership values are: \n');
% disp(w)

% Source Separation
src = 4;
u = dfcmSeparationND(z_all,th,src,nf,mf,width,ovrlp,frame,nX,nx,mX,mx)
answer = questdlg('Would you like to listen to the separated sources?','Result','Yes','No','No');
if answer == 'Yes'
    soundsc(u(1,:),16000)
    pause(12)
    soundsc(u(2,:),16000)
    pause(12)
    soundsc(u(3,:),16000)
    pause(12)
    soundsc(u(4,:),16000)
end