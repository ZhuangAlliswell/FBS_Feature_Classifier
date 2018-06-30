%用于将整合好的特征文件拆分出训练样本和测试样本
%输入：整合好的特征文件（label在第一列，有表头）
%输出：整合好的特征文件
%----------------------------------------------
%%
%读入文件
alldata=csvread('mergeddata.csv');
%按类提取
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
%生成训练样本的半成品
writedata=[];
writedata=[writedata;rbs1(1:TrainingSampleNumber,:)];
%     writedata=[writedata;rbs2(1:TrainingSampleNumber,:)];
writedata=[writedata;rbs3(1:TrainingSampleNumber,:)];
writedata=[writedata;rbs5(1:TrainingSampleNumber,:)];
writedata=[writedata;rbs6(1:TrainingSampleNumber,:)];
writedata=[0:(len-1);writedata];%添加表头
csvwrite(['trainingDataOrigin.csv'],writedata);
%%
%生成测试样本的成品
writedata=[];
Index=TrainingSampleNumber+1;
writedata=[writedata;rbs1(Index:(Index+TestingSampleNumber-1),:)];
% writedata=[writedata;rbs2(Index:(Index+TestingSampleNumber-1),:)];
writedata=[writedata;rbs3(Index:(Index+TestingSampleNumber-1),:)];
writedata=[writedata;rbs5(Index:(Index+TestingSampleNumber-1),:)];
writedata=[writedata;rbs6(Index:(Index+TestingSampleNumber-1),:)];
writedata=[0:(len-1);writedata];%添加表头
csvwrite(['testingdata\testingdata.csv'],writedata);

