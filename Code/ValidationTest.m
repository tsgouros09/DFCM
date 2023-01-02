close all;
clear all;

x_1=audioread('dev1_wdrums_inst_src_1.wav')';
x_2=audioread('dev1_wdrums_inst_src_2.wav')';
x_3=audioread('dev1_wdrums_inst_src_3.wav')';

X_all=[x_1;x_2;x_3];
x=audioread('dev1_wdrums_inst_mix.wav')';
frame=1024;ovrlp=0.2;src=3;Eig_Thres=700;width=2;

%stft
tic;
[nx mx]=size(x);
X=[];
X=stft(x,frame,ovrlp);
[nX mX]=size(X(:,:,1));
mX=mX/nx;
X=reshape(X,nX,mX,nx);
X1frame=[];X2frame=[];
X1frame=squeeze(X(:,:,1));
X2frame=squeeze(X(:,:,2));
X1frame=im2col(X1frame,[width width],'distinct');
X2frame=im2col(X2frame,[width width],'distinct');
[nf mf]=size(X1frame);
thHigh=[];
thAll=[];
zn=[];
zAll=[];
z=[];

%%% Reduced Dataset %%%
for i=1:mf
        z=[real(X1frame(:,i)); imag(X1frame(:,i))];
        z=[z [real(X2frame(:,i)); imag(X2frame(:,i))]];
        z=z';
        ztmp=z-mean(z,2)*ones(1,2*width^2);
        Cz=ztmp*ztmp'/size(z,2);
        [V,D] = eig(Cz);
        if abs(D(2,2)/D(1,1))>Eig_Thres
            thHigh=[thHigh atan(V(2,2)/V(2,1))];
            zn=[zn z]; 
        end
        thAll=[thAll atan(V(2,2)/V(2,1))];
%         zAll=[zAll z];
end

%%% Plots %%%
% figure; hist(thAll,180);
figure; hist(thHigh,180);
figure; plot(zn(1,:),zn(2,:),'.');

% Cluster Validation
[N m]=directionalValidation(thHigh);
fprintf('\nThere are %d clusters',N);
fprintf('\n\nThe centres are: \n\n');
disp(m)

% Directional Clustering
[K,L] = size(X_all);
[c,w]=directionalFuzzyCMeans(thHigh,K);
fprintf('The centres are: \n');
disp(c)
% fprintf('The membership values are: \n');
% disp(w)

% Source Separation
src = 3;
u = dfcmSeparation(X1frame,X2frame,thAll,thHigh,src,width,ovrlp,frame,nX,mx,mX);
answer = questdlg('Would you like to listen to the separated sources?','Result','Yes','No','No');
if answer == 'Yes'
    soundsc(u(1,:),16000)
    pause(12)
    soundsc(u(2,:),16000)
    pause(12)
    soundsc(u(3,:),16000)
end