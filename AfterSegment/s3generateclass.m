%�������ڶ������������ѵ������
%���룺ѵ�������İ��Ʒ��label����࣬�б�ͷ��
%��������ڶ������������ѵ��������������label=1��������label=0��
%---------------------------------------------
%%
clc;
clear;
%%
rawdata=csvread('trainingDataOrigin.csv');

%%
mkdir('trainingData');

for positive=[1 2 3 5 6] %ѡȡһ��label��������Ϊ������
    %%   
        trainingDataInd=find(rawdata(:,1)==positive);
        trainingData=rawdata();
        trainingDataLabel=trainingData(:,1);
        trainingData(:,1)=0;
        trainingData(trainingDataInd,1)=1;
        trainingData=[0:1:(length(trainingData(1,:))-1);trainingData];
        csvwrite(['trainingData\trainingData',num2str(positive),'.csv'],trainingData);
    
end