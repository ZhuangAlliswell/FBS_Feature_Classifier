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
%初始化存放各种变换矩阵
[m,n]=size(ComplexSine);
FFTdata = zeros(m,1024); %采用1024个点的FFT
Amp = zeros(m,n);        %每一个FCCH的幅值曲线
%% FCCH信道 快速傅里叶变换
FFTdata = FFTdata'; %方便做fft的按列赋值
for ii = 1:m
FFTdata(1+(ii-1)*1024:ii*1024) = fft(ComplexSine(ii,:),1024);
end
FFTdata = FFTdata';

    AbsSumFFT = zeros(1,1024);
for ii = 1:m
    AbsSumFFT = mapminmax(abs(FFTdata(ii,:)),0,1)+ AbsSumFFT;
end
    plot(AbsSumFFT);
% 观察结果
% subplot(211);
% plot(abs(mapFFTdata(2,:)));
% subplot(212);
% plot(angle(FFTdata(2,:)));
%% FCCH 信道busrt幅值曲线
for ii = 1:m
    for j = 1:n
    Amp(ii,j)= abs(ComplexSine(ii,j));
    end
end
mapAmp = mapminmax(Amp,0,1); %对采集到的所有burst按照行做归一化。
 
% plot(angle(ComplexSine(35,:)),'.');
%% 标准正弦波
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
%% 时域burst的均值、标准差、方差、偏斜度指标、峭度指标、峰峰值、峰值、均方幅值、平均值、方根幅值、波形指标、峰值指标

Avg = mean(mapAmp,2); %时域burst的平均值，后面加2 可以按照行计算均值，若不加是按照列来计算
plot(Avg);
%% 标准差
X= mapAmp'; 
Stdburst = std(X)';%标准差是按列计算
plot(Stdburst);
%% 方差
Varburst = Stdburst.^2;
plot(Varburst);
%% 偏斜度 skewness
X= mapAmp'; 
Skwburst = skewness(X);
plot(Skwburst);
%% 复信号的短时傅里叶变换(类似于每一段的fft)
fs =2e6;
nfft =256;
x= ComplexSine(1,:);
%  noverlap = 120;
window = kaiser(128,18);
[S,F,T,P]=spectrogram(x,window,noverlap,nfft,fs);
% S 为8*256的短时傅里叶变换，P为功率谱密度
%% Burst峭度kurtosis
 x = mapAmp'; 
 KuBurst = kurtosis(x);
 plot(KuBurst);
%% 波形因子SBurst  rm/av  均方根除以平均值
 x = mapAmp'; 
 rmBurst = rms(x);
 avBurst = mean(x);
 SBurst = rmBurst./avBurst;
 plot(SBurst);
%%  峰值因子    CBurst = pk/rm
x = mapAmp'; 
maxBurst = max(x);
minBurst = min(x);
pkBurst = max(x)-min(x);
rmBurst = rms(x);
CBurst = pkBurst./rmBurst;
 plot(CBurst);
%% 峭度因子   KrBurst = sum(y.^4)/sqrt(sum(y.^2))
x = mapAmp'; 
KrBurst = sum(x.^4)./sqrt(sum(x.^2));
plot(KrBurst);

%% 脉冲因子  IBurst = pk/av
x = mapAmp';
pkBurst = max(x)-min(x);
 avBurst = mean(x);
IBurst = pkBurst./avBurst;
plot(IBurst)

%% 裕度因子 LBurst = pk/Xr
x = mapAmp';
pkBurst = max(x)-min(x);
XrBurst = (mean(sqrt(abs(x)))).^2;
LBurst =pkBurst./XrBurst ;
plot(LBurst)


