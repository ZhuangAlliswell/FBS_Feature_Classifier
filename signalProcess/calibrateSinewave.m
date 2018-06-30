% exp(1i*2*pi*67.708e3)
t=0:0.5e-6:0.6e-3;
y =exp(1i*2*pi*67.708e3*t);
% plot(angle(y));
%%
Realy = real(y);
Imagey =    imag(y);
subplot(311);
plot(Realy(1:1000));
subplot(312);
plot(Imagey(1:1000));
%%
Newrel = Realy(1:1000)+0.0001
Newimg = Imagey(1:1000)-0.0001

Amp = Newrel.^2+Newimg.^2;
subplot(313);
plot(Amp);
%% ±ê×¼ÕýÏÒ²¨
clear;
clc;
fid1=fopen('E:\0706\sinewave_2','r');
[A,COUNT]=fread(fid1,'float');
fclose(fid1);
Real=A(1:2:end);
Image=A(2:2:end);
COUNT1=length(Real);
COUNT2=length(Image);
%%
ComplexrSine = Real(1001+900:2024+900)+1*complex(0,1)*Image(1001+900:2024+900);
%%
x =abs(ComplexrSine);
%%
x = x./mean(x)-1;
%%
f =linspace(0,2e6,1024); 
hold on; 
plot(f,abs(fft(x*35,1024)));
%%



t=0:0.5e-6:0.6e-3;
y =0.41*exp(1i*(2*pi*68.708e3*t-0.235*pi));
y1 =0.41*exp(1i*(2*pi*68.708e3*t-0.735*pi));
subplot(311);
A=Real(2000:2200);
D= real(y);
plot(A);
hold on;
plot(D(1:200));
hold off;
subplot(312);
B = Image(2000:2200);
E= real(y1);
plot(B);
hold on;
plot(E(1:200));
hold off;
subplot(313);
C = A.^2+B.^2;
plot(C);