%%
clc;
clear;
%%
rawData=csvread('testingData\testingData.csv');
label=rawData(:,1);
len=length(label);
label=label(2:len);
csvwrite(['label\testingDataLabel.csv'],label); 