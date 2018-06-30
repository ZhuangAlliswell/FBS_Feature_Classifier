%先给接收到的正常基站信号滤波
clear;
clc;
fid1=fopen('E:\0706\953.8_2','r');
[A,COUNT]=fread(fid1,'float');
fclose(fid1);
Real=A(1:2:end);
Image=A(2:2:end);
COUNT1=length(Real);
COUNT2=length(Image);
i = complex(0,1);
%%
complexSignal = Real+1*i*Image;
%%
Hlp = design(fdesign.nyquist(8)); 
y =  filter(Hlp,complexSignal);
%%  删除除了y以外的变量
clearvars -except y
%%
plot(real(y(1:1e6)))

%%
Real=real(y);
Image=imag(y);
COUNT1=length(Real);
COUNT2=length(Image);
RealRe=resample(Real,270.8e3,2e6);
ImageRe=resample(Image,270.8e3,2e6);
phiInit=atan(ImageRe./RealRe);
count=length(phiInit);
for ii=1:count-1
    DeltaPhi(ii)=abs(phiInit(ii+1)-phiInit(ii));
end
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
ComplexSine=zeros(length(SineBegin2M),1120);
for ii=1:length(SineBegin2M)
ComplexSine(ii,:)=Real(SineBegin2M(ii):SineBegin2M(ii)+1120-1)+Image(SineBegin2M(ii):SineBegin2M(ii)+1120-1)*1i;
end
% subplot(311);
% plot(real(y(1:1e6)));
% subplot(312);
% plot(imag(y(1:1e6)));
% subplot(313);
% plot(abs(y(1:1e6)));








