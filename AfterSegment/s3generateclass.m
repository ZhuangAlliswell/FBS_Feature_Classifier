%生成用于多个二分类器的训练样本
%输入：训练样本的半成品（label在左侧，有表头）
%输出：用于多个二分类器的训练样本（正样本label=1，副样本label=0）
%---------------------------------------------
%%
clc;
clear;
%%
rawdata=csvread('trainingDataOrigin.csv');

%%
mkdir('trainingData');

for positive=[1 2 3 5 6] %选取一个label的样本作为正样本
    %%   
        trainingDataInd=find(rawdata(:,1)==positive);
        trainingData=rawdata();
        trainingDataLabel=trainingData(:,1);
        trainingData(:,1)=0;
        trainingData(trainingDataInd,1)=1;
        trainingData=[0:1:(length(trainingData(1,:))-1);trainingData];
        csvwrite(['trainingData\trainingData',num2str(positive),'.csv'],trainingData);
    
end