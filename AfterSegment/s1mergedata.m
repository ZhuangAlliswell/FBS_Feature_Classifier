%�����ں�����
%���룺Tsfresh��ȡ��ԭʼ�����ļ�
%��������ϵ������ļ���label�ڵ�һ�У��б�ͷ��
%---------------------------------------------------
%���ԭʼ���ݵ��ļ�����
fileList=dir('rawdata');
%%
%�����ļ����������ļ�
alldata=[];
for ii=3:length(fileList)
    fileName=fileList(ii).name;
    readdata=csvread(['rawdata\',fileName],1,0); %������һ�еı�ͷ
    alldata=[alldata;readdata];
    fprintf('file %d is completed\n',ii);
end
%%
%ɾȥ��һ�У�ID��,�������һ�У�label���Ƶ���һ��
len=length(alldata(1,:));
alldata=[alldata(:,len),alldata(:,2:len-1)];
alldata=[0:len-2;alldata];
%%
%����ļ�
csvwrite('mergeddata.csv',alldata);