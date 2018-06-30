clear;
clc;
fid1=fopen('D:\0723\RBS3945_25cable','r');
[A,COUNT]=fread(fid1,'float');
fclose(fid1);
%%
Real=A(1:2:end);
Image=A(2:2:end);
COUNT1=length(Real);
COUNT2=length(Image);
%%
RealRe=resample(Real,270.8e3,2e6);
ImageRe=resample(Image,270.8e3,2e6);
%%
phiInit=atan(ImageRe./RealRe);
count=length(phiInit);
for ii=1:count-1
    DeltaPhi(ii)=abs(phiInit(ii+1)-phiInit(ii));
end
%%
window=144;
Sum=0;
SineBegin=[]; %
countSine=1;
j=0;
while(j<count-156)
    for k=1:window
        if(abs(DeltaPhi(j+k)-1.57)<0.7)
            Sum=Sum+1;
        elseif(abs(DeltaPhi(j+k)-1.57)>0.7)
            Sum=Sum-1;
        end
    end  
    if(Sum>140)
        SineBegin(countSine)=j;
        countSine=countSine+1; 
        j=j+144;
    else
        j=j+1;
    end
    Sum=0;
end
%%
SineBegin2M=floor(SineBegin./count.*COUNT1);
subplot(211);
plot(Real(SineBegin2M(20)-15:SineBegin2M(20)+1120));
subplot(212);
plot(Image(SineBegin2M(20)-15:SineBegin2M(20)+1120));
%%
ComplexSine=zeros(length(SineBegin2M),1120);
for ii=1:length(SineBegin2M)
ComplexSine(ii,:)=Real(SineBegin2M(ii):SineBegin2M(ii)+1120-1)+Image(SineBegin2M(ii):SineBegin2M(ii)+1120-1)*1i;
end

%%
%��ʼ����Ÿ��ֱ任����
[m,n]=size(ComplexSine);
FFTdata = zeros(m,1024); %����1024�����FFT
Amp = zeros(m,n);        %ÿһ��FCCH�ķ�ֵ����
%% FCCH�ŵ� ���ٸ���Ҷ�任
FFTdata = FFTdata'; %������fft�İ��и�ֵ
for ii = 1:m
FFTdata(1+(ii-1)*1024:ii*1024) = fft(ComplexSine(ii,:),1024);
end
FFTdata = FFTdata';

    AbsSumFFT = zeros(1,1024);
for ii = 1:m
    AbsSumFFT = mapminmax(abs(FFTdata(ii,:)),0,1)+ AbsSumFFT;
end
    plot(AbsSumFFT);
% �۲���
% subplot(211);
% plot(abs(mapFFTdata(2,:)));
% subplot(212);
% plot(angle(FFTdata(2,:)));
%% FCCH �ŵ�busrt��ֵ����
for ii = 1:m
    for j = 1:n
    Amp(ii,j)= abs(ComplexSine(ii,j));
    end
end
mapAmp = mapminmax(Amp,0,1); %�Բɼ���������burst����������һ����
 
% plot(angle(ComplexSine(35,:)),'.');
%% ��׼���Ҳ�
t=0:0.5e-6:0.6e-3;
y =0.132*exp(1i*(2*pi*67.708e3*t-0.46*pi));
y1 =0.132*exp(1i*(2*pi*67.708e3*t-0.96*pi));
subplot(311);
A= real(ComplexSine(22,:));
D= real(y);
plot(A(100:350));
hold on;
plot(D(100:350));
hold off;
subplot(312);
B = imag(ComplexSine(22,:));
E= real(y1);
plot(B(100:350));
hold on;
plot(E(100:350));
hold off;

subplot(313);
C = mapAmp(22,:);
plot(C(100:350));
%% ʱ��burst�ľ�ֵ����׼����ƫб��ָ�ꡢ�Ͷ�ָ�ꡢ���ֵ����ֵ��������ֵ��ƽ��ֵ��������ֵ������ָ�ꡢ��ֵָ��

Avg = mean(mapAmp,2); %ʱ��burst��ƽ��ֵ�������2 ���԰����м����ֵ���������ǰ�����������
plot(Avg);
%% ��׼��
X= mapAmp'; 
Stdburst = std(X)';%��׼���ǰ��м���
plot(Stdburst);
%% ����
Varburst = Stdburst.^2;
plot(Varburst);
%% ƫб�� skewness
X= mapAmp'; 
Skwburst = skewness(X);
plot(Skwburst);
%% ���źŵĶ�ʱ����Ҷ�任(������ÿһ�ε�fft)
fs =2e6;
nfft =256;
x= ComplexSine(1,:);
%  noverlap = 120;
window = kaiser(128,18);
[S,F,T,P]=spectrogram(x,window,noverlap,nfft,fs);
% S Ϊ8*256�Ķ�ʱ����Ҷ�任��PΪ�������ܶ�
%% Burst�Ͷ�kurtosis
 x = mapAmp'; 
 KuBurst = kurtosis(x);
 plot(KuBurst);
%% ��������SBurst  rm/av  ����������ƽ��ֵ
 x = mapAmp'; 
 rmBurst = rms(x);
 avBurst = mean(x);
 SBurst = rmBurst./avBurst;
 plot(SBurst);
%%  ��ֵ����    CBurst = pk/rm
x = mapAmp'; 
maxBurst = max(x);
minBurst = min(x);
pkBurst = max(x)-min(x);
rmBurst = rms(x);
CBurst = pkBurst./rmBurst;
 plot(CBurst);
%% �Ͷ�����   KrBurst = sum(y.^4)/sqrt(sum(y.^2))
x = mapAmp'; 
KrBurst = sum(x.^4)./sqrt(sum(x.^2));
plot(KrBurst);

%% ��������  IBurst = pk/av
x = mapAmp';
pkBurst = max(x)-min(x);
 avBurst = mean(x);
IBurst = pkBurst./avBurst;
plot(IBurst)

%% ԣ������ LBurst = pk/Xr
x = mapAmp';
pkBurst = max(x)-min(x);
XrBurst = (mean(sqrt(abs(x)))).^2;
LBurst =pkBurst./XrBurst ;
plot(LBurst)


