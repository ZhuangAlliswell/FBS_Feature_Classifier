% 输入复信号
% Hlp = design(fdesign.nyquist(4)); 
% y =  filter(Hlp,ComplexBurst);
y =ComplexBurst;
Signal = abs(y);
plot(Signal);
%%
Fs = 25e6; %采样率
BurstTime = 6/1.625*156.25*1e-6;
windows = floor(BurstTime* Fs);
%%
th = 0.003;
th_dif = 0.0015;
len = length(Signal);
NumBurst = round(len/windows);
count = zeros(NumBurst,1);
ii =1;
j =1;
%%
while(ii<len)
    if(Signal(ii)<th)
        if (Signal(ii+20)-Signal(ii)>th_dif)
            count(j)=ii;
            j= j+1;
            ii = ii+windows-100;
        end
    end
     ii = ii+1;
end
%%
plot(Signal(count(99):count(99)+windows))
%%
%验证guard bit 位数
plot(Signal(count(99):count(99)+windows))


