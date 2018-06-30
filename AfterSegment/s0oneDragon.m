%输入：1秒钟的时间序列样本
%输出：用于TSfresh的数据
%%
% SNR=53;
%prepare for file reading
Threshold=2e5;%thFCCH阈值
indir='E:\weijizhan\10samples\RBS6';
outdir='E:\weijizhan\10samples\output';
fileList=dir(indir);
for SNR=[53] %信噪比，53代表不加白噪声
    for fileNumber=3:length(fileList)
        load([indir, '\', fileList(fileNumber).name])
        %%
        if(SNR~=53)
            a=awgn(a,SNR);
        end
        %%
        Hlp = design(fdesign.nyquist(16)); %to 32
        test =  filter(Hlp,a); % 经过滤波的25M个采样点
        RBS13 = resample(test,13e6,25e6); % 经过滤波下变频的13M个采样点
        y = RBS13;
        Fs = 13e6;
        Burstdot = 7500;
        FCCHDomain = Burstdot*80;
        %
        % 构造37个周期的正弦波，频率为67.708kHz，那么一共148bit共占有7104个点,一个burst一共占7500个点
        % 一个含有FCCH的区域一共有80或88个burst。
        relt = real(y);  %用信号的实部
        t = 0:1/13e6:1/13e6*7104;
        sinwave = 0.4313*sin(2*pi*67.708e3*t); % 构造好的正弦函数
        correlation= xcorr(sinwave,relt);
        
        cor2 = correlation(1:Fs).^2;
        %%
%         figure;
%         plot(cor2);
        %%
        FCCHHead = zeros(1,22); % 所有FCCH帧的初始位置
        FCCHHeadValue = zeros(1,22);
        %% 为了防止 将非FCCH帧判断为FCCH ，增加阈值
        thFCCH = Threshold;
        for ii =1:21
            [val,pos]=max(cor2((ii-1)*FCCHDomain+1:ii*FCCHDomain));
            if (val>thFCCH)
                FCCHHead(ii) = Fs - (pos+(ii-1)*FCCHDomain)+1;
            else
                FCCHHead(ii) = -1;
            end
            FCCHHeadValue(ii) = val;
        end
        ii =22;
        [val,pos]=max(cor2((ii-1)*FCCHDomain+1:end));
        if (val>thFCCH)
            FCCHHead(ii) = Fs - (pos+(ii-1)*FCCHDomain)+1;
        else
            FCCHHead(ii) = -1;
        end
        FCCHHeadValue(ii) = val;
        %% 删除 FCCHHead中误判断的
        delete = 0;
        for ii =1:22
            if(FCCHHead(ii) == -1)
                delete = ii;
            end
        end
        if (delete~=0)
            FCCHHead(delete) = [];
        end
        %  FCCHHead(12) = [];
        %
        FCCHHead = fliplr(FCCHHead);
        
        %%
        %  plot(abs(y(FCCHHead(8)+2*7500:FCCHHead(8)+7500+2*7500))); hold on;
        
        
        
        %%
        BuLen = length(FCCHHead)-1;
        TOTSCHead = zeros(BuLen,8);
        Gdwin=100;
        GuardLen = 396; % 对于13MHz是396个点
        testAmp = abs(y);
        for ii = 1 : BuLen
            for j = 1:8
                start = FCCHHead(ii)+((j+1)*8)*Burstdot-GuardLen-Gdwin-2000;
                fin   = FCCHHead(ii)+((j+1)*8)*Burstdot-GuardLen+Gdwin;
                SumGuard = sum(testAmp(start:start+GuardLen-1));
                BeginFlag = start+GuardLen-1;
                for index = start:fin
                    if ((sum(testAmp(index:index+GuardLen-1))-SumGuard)<0)
                        SumGuard = (sum(testAmp(index:index+GuardLen-1)));
                        BeginFlag = index+GuardLen-1;
                    end
                end
                TOTSCHead(ii,j)=BeginFlag;
            end
        end
        %%
        ii =9;
        %  for   j =1:8
        %     plot(unwrap(angle(y(TOTSCHead(ii,j)+2970:(TOTSCHead(ii,j)+4121))))); hold on;
        %
        %  end
        
        %%
        % TOTSCHead(9,:)=[];
        %%
        fs = 13e6;
        for ii = 1:19
            for j =1:8
                initial = TOTSCHead(ii,j)+2970; %帧开始
                finish = TOTSCHead(ii,j)+4121; %帧结束
                input1 = y(initial:finish); % 整个帧，13M采样y
                amp_input1 = abs(input1); % 幅值
                phi_input1 = unwrap(angle(input1)); %相位
                f_input1   = diff(phi_input1)*fs/(2*pi); % 频率
                %  subplot(311);plot(amp_input1);hold on; subplot(312);plot(phi_input1);hold on; subplot(313);plot(f_input1); hold on;
            end
        end
        %%
        T0TSC = zeros(20,1152) ;
        for ii = 1:20
            for j =1:8
                initial = TOTSCHead(ii,j)+2970; %帧开始
                finish = TOTSCHead(ii,j)+4121; %帧结束
                T0TSC((ii-1)*8+j,:) = y(initial:finish);
            end
        end
        %
        %     for ii =1:8*20
        %         plot(abs(T0TSC(ii,:))); hold on;
        %     end
        
        %% 存储获取的T0tsc序列
        c = T0TSC;
        % matname = '069430108.ma
        
        
        % t';
        % matname = '049570101.mat';
        % filefolder = fullfile('E:\weijizhan\new\T0TSC\');
        % path = [filefolder,matname];
        % save(path,'c')
        % clear;
        % clc;
        
        b =c;
        [row, col] = size(b);
        
        AmpSeg = abs(b);
        
        PhiSeg = angle(b);
        for ii = 1:row
            PhiSeg(ii,:) = unwrap(PhiSeg(ii,:));
        end
        
        %相位比频率少一个数
        fs = 25e6;
        freqSeg =zeros(row, col-1);
        for ii = 1:row
            freqSeg(ii,:) = diff(PhiSeg(ii,:))*fs/(2*pi);
        end
        
        meanAmpSeg = mean(AmpSeg,2);  % 每一行的均值
        meanPhiSeg = mean(PhiSeg,2);
        meanfreqSeg = mean(freqSeg,2);
        
        % 减去每行的均值centering
        for ii =1: row
            %AmpSeg(ii,:) = AmpSeg(ii,:)-meanAmpSeg(ii);
            PhiSeg(ii,:) = PhiSeg(ii,:)-meanPhiSeg(ii);
            %freqSeg(ii,:) = freqSeg(ii,:)-meanfreqSeg(ii);
        end
        % 归一化normalize
        [maxAmpSeg, maxAmpindex] = max(AmpSeg,[],2);  % 每一行的最大值
        [maxPhiSeg, maxPhiindex] = max(PhiSeg,[],2);  % 每一行的最大值
        [maxfreqSeg, maxfreqindex] = max(freqSeg,[],2); % 每一行的最大值
        %
        for ii =1: row
            AmpSeg(ii,:) = AmpSeg(ii,:)/maxAmpSeg(ii);
            PhiSeg(ii,:) = PhiSeg(ii,:)/maxPhiSeg(ii);
            freqSeg(ii,:) = freqSeg(ii,:)/maxfreqSeg(ii);
        end
        % Amp与Phi 删除最后一列
        AmpSeg(:,1152)=[];
        PhiSeg(:,1152)=[];
        %
        col = col -1;
        Amp = reshape(AmpSeg.',row*col,1);
        Phi = reshape(PhiSeg.',row*col,1);
        freq = reshape(freqSeg.',row*col,1);
        %
        sequence = 1:row*col; sequence = sequence';
        id = zeros(row,col); % 初始化
        for ii =1:row
            id(ii,:) = ii;
        end
        id = reshape(id.',row*col,1);
        time = zeros(row,col); % 初始化
        for ii =1:row
            time(ii,:) = 1:col;
        end
        time = reshape(time.',row*col,1);
        label = 6*ones(row*col,1);
        %
        columns = {'sequence','id','time','Amp','Phi','freq','label'};
        data = table(sequence,id,time,Amp,Phi,freq,label,'VariableNames', columns);
        fileName=fileList(fileNumber).name;
        fileName=fileName(1:(length(fileName)-4));
        fileName=[fileName,'SNR',num2str(SNR),'.csv'];
        writetable(data, [outdir, '\', fileName])
        fprintf('file %d-%d is completed\n',SNR,fileNumber-2)
    end
end


