%���ڽ����Ϻõ������ļ���ֳ�ѵ�������Ͳ�������
%���룺���Ϻõ������ļ���label�ڵ�һ�У��б�ͷ��
%��������Ϻõ������ļ�
%----------------------------------------------
%%
%�����ļ�
alldata=csvread('mergeddata.csv');
%������ȡ
len=length(alldata(1,:));
rbs1=alldata(alldata(:,1)==1,:);
% rbs2=alldata(alldata(:,1)==2,:);
rbs3=alldata(alldata(:,1)==3,:);
rbs5=alldata(alldata(:,1)==5,:);
rbs6=alldata(alldata(:,1)==6,:);
%%
TrainingSampleNumber=1000;
TestingSampleNumber=100;
%%
%����ѵ�������İ��Ʒ
writedata=[];
writedata=[writedata;rbs1(1:TrainingSampleNumber,:)];
%     writedata=[writedata;rbs2(1:TrainingSampleNumber,:)];
writedata=[writedata;rbs3(1:TrainingSampleNumber,:)];
writedata=[writedata;rbs5(1:TrainingSampleNumber,:)];
writedata=[writedata;rbs6(1:TrainingSampleNumber,:)];
writedata=[0:(len-1);writedata];%��ӱ�ͷ
csvwrite(['trainingDataOrigin.csv'],writedata);
%%
%���ɲ��������ĳ�Ʒ
writedata=[];
Index=TrainingSampleNumber+1;
writedata=[writedata;rbs1(Index:(Index+TestingSampleNumber-1),:)];
% writedata=[writedata;rbs2(Index:(Index+TestingSampleNumber-1),:)];
writedata=[writedata;rbs3(Index:(Index+TestingSampleNumber-1),:)];
writedata=[writedata;rbs5(Index:(Index+TestingSampleNumber-1),:)];
writedata=[writedata;rbs6(Index:(Index+TestingSampleNumber-1),:)];
writedata=[0:(len-1);writedata];%��ӱ�ͷ
csvwrite(['testingdata\testingdata.csv'],writedata);

