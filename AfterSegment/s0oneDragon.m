%���룺1���ӵ�ʱ����������
%���������TSfresh������
%%
% SNR=53;
%prepare for file reading
Threshold=2e5;%thFCCH��ֵ
indir='E:\weijizhan\10samples\RBS6';
outdir='E:\weijizhan\10samples\output';
fileList=dir(indir);
for SNR=[53] %����ȣ�53�����Ӱ�����
    for fileNumber=3:length(fileList)
        load([indir, '\', fileList(fileNumber).name])
        %%
        if(SNR~=53)
            a=awgn(a,SNR);
        end
        %%
        Hlp = design(fdesign.nyquist(16)); %to 32
        test =  filter(Hlp,a); % �����˲���25M��������
        RBS13 = resample(test,13e6,25e6); % �����˲��±�Ƶ��13M��������
        y = RBS13;
        Fs = 13e6;
        Burstdot = 7500;
        FCCHDomain = Burstdot*80;
        %
        % ����37�����ڵ����Ҳ���Ƶ��Ϊ67.708kHz����ôһ��148bit��ռ��7104����,һ��burstһ��ռ7500����
        % һ������FCCH������һ����80��88��burst��
        relt = real(y);  %���źŵ�ʵ��
        t = 0:1/13e6:1/13e6*7104;
        sinwave = 0.4313*sin(2*pi*67.708e3*t); % ����õ����Һ���
        correlation= xcorr(sinwave,relt);
        
        cor2 = correlation(1:Fs).^2;
        %%
%         figure;
%         plot(cor2);
        %%
        FCCHHead = zeros(1,22); % ����FCCH֡�ĳ�ʼλ��
        FCCHHeadValue = zeros(1,22);
        %% Ϊ�˷�ֹ ����FCCH֡�ж�ΪFCCH ��������ֵ
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
        %% ɾ�� FCCHHead�����жϵ�
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
        GuardLen = 396; % ����13MHz��396����
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
                initial = TOTSCHead(ii,j)+2970; %֡��ʼ
                finish = TOTSCHead(ii,j)+4121; %֡����
                input1 = y(initial:finish); % ����֡��13M����y
                amp_input1 = abs(input1); % ��ֵ
                phi_input1 = unwrap(angle(input1)); %��λ
                f_input1   = diff(phi_input1)*fs/(2*pi); % Ƶ��
                %  subplot(311);plot(amp_input1);hold on; subplot(312);plot(phi_input1);hold on; subplot(313);plot(f_input1); hold on;
            end
        end
        %%
        T0TSC = zeros(20,1152) ;
        for ii = 1:20
            for j =1:8
                initial = TOTSCHead(ii,j)+2970; %֡��ʼ
                finish = TOTSCHead(ii,j)+4121; %֡����
                T0TSC((ii-1)*8+j,:) = y(initial:finish);
            end
        end
        %
        %     for ii =1:8*20
        %         plot(abs(T0TSC(ii,:))); hold on;
        %     end
        
        %% �洢��ȡ��T0tsc����
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
        
        %��λ��Ƶ����һ����
        fs = 25e6;
        freqSeg =zeros(row, col-1);
        for ii = 1:row
            freqSeg(ii,:) = diff(PhiSeg(ii,:))*fs/(2*pi);
        end
        
        meanAmpSeg = mean(AmpSeg,2);  % ÿһ�еľ�ֵ
        meanPhiSeg = mean(PhiSeg,2);
        meanfreqSeg = mean(freqSeg,2);
        
        % ��ȥÿ�еľ�ֵcentering
        for ii =1: row
            %AmpSeg(ii,:) = AmpSeg(ii,:)-meanAmpSeg(ii);
            PhiSeg(ii,:) = PhiSeg(ii,:)-meanPhiSeg(ii);
            %freqSeg(ii,:) = freqSeg(ii,:)-meanfreqSeg(ii);
        end
        % ��һ��normalize
        [maxAmpSeg, maxAmpindex] = max(AmpSeg,[],2);  % ÿһ�е����ֵ
        [maxPhiSeg, maxPhiindex] = max(PhiSeg,[],2);  % ÿһ�е����ֵ
        [maxfreqSeg, maxfreqindex] = max(freqSeg,[],2); % ÿһ�е����ֵ
        %
        for ii =1: row
            AmpSeg(ii,:) = AmpSeg(ii,:)/maxAmpSeg(ii);
            PhiSeg(ii,:) = PhiSeg(ii,:)/maxPhiSeg(ii);
            freqSeg(ii,:) = freqSeg(ii,:)/maxfreqSeg(ii);
        end
        % Amp��Phi ɾ�����һ��
        AmpSeg(:,1152)=[];
        PhiSeg(:,1152)=[];
        %
        col = col -1;
        Amp = reshape(AmpSeg.',row*col,1);
        Phi = reshape(PhiSeg.',row*col,1);
        freq = reshape(freqSeg.',row*col,1);
        %
        sequence = 1:row*col; sequence = sequence';
        id = zeros(row,col); % ��ʼ��
        for ii =1:row
            id(ii,:) = ii;
        end
        id = reshape(id.',row*col,1);
        time = zeros(row,col); % ��ʼ��
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


