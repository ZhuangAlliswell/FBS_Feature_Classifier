%用于融合数据
%输入：Tsfresh提取的原始特征文件
%输出：整合的特征文件（label在第一列，有表头）
%---------------------------------------------------
%存放原始数据的文件夹名
fileList=dir('rawdata');
%%
%读入文件夹内所有文件
alldata=[];
for ii=3:length(fileList)
    fileName=fileList(ii).name;
    readdata=csvread(['rawdata\',fileName],1,0); %不读第一行的表头
    alldata=[alldata;readdata];
    fprintf('file %d is completed\n',ii);
end
%%
%删去第一列（ID）,并把最后一列（label）移到第一列
len=length(alldata(1,:));
alldata=[alldata(:,len),alldata(:,2:len-1)];
alldata=[0:len-2;alldata];
%%
%输出文件
csvwrite('mergeddata.csv',alldata);