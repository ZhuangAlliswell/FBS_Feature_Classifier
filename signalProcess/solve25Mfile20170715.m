clear;
clc;
fid1=fopen('/media/root/alliwell/0723jing/RBS4_heise/RBS4_945_25_cable','r');
[A,COUNT]=fread(fid1,'float');
fclose(fid1);
%%
Real=A(1:2:end);
Image=A(2:2:end);
COUNT1=length(Real);
COUNT2=length(Image);

%%
UsedReal = Real;
UsedImage = Image;
%%
ComplexBurst = complex(UsedReal,UsedImage);
%plot(UsedReal);
%%
plot(UsedReal(619800:619800+14422));
exampleBurstReal = UsedReal(619800:619800+14422);
exampleBurstImage = UsedImage(619800:619800+14422);
%%
exampleBurstReal = UsedReal;
exampleBurstImage = UsedImage;
exampleBurst= complex(exampleBurstReal,exampleBurstImage);
%%
epBurst = resample(exampleBurst,26e6,25e6);
plot(angle(epBurst));
%%
num = length(epBurst);
t1 =0:1/26 *1e-6:(1/26 *1e-6)*(num-1);
t1 = t1';
burst = epBurst;
%%
%�˲�
Hlp = design(fdesign.nyquist(8)); 
burst =  filter(Hlp,burst);
%%
realvalue = real(burst);
imagevalue = imag(burst);

%% fft ����
Fs= 25e6;
n = 8192*128;
f =0: Fs/n:Fs-Fs/n;
%%
f = f-Fs/2;
%%

%%
subplot(311);
plot(f,log10(abs(fftshift(fft(RBS1(1:n))))),'b');
title('RBS1 FFT');
xlabel('Hz');
subplot(312);
plot(f,log10(abs(fftshift(fft(RBS2(1:n))))),'r');
title('RBS2 FFT');
xlabel('Hz');
subplot(313);
plot(f,log10(abs(fftshift(fft(RBS3(1:n))))),'g');
title('RBS3 FFT')
xlabel('Hz');
%%
RBS3=ComplexBurst;
Fs= 25e6;
n = 8192*16;
f =0: Fs/n:Fs-Fs/n;
f = f-Fs/2;
plot(f,log10(abs(fftshift(fft(RBS3(35*n:36*n-1))))),'b');
title('RBS3 FFT')
xlabel('Hz');



