#-------------
#handle cmd parameter
import sys
try:
	inputfile=sys.argv[1]
except IndexError:
	print ('Reference input format : python feature_selection.py [inputfile]')
	exit()
print ('inputfile is:', inputfile)

#-------------
#read data
import pandas as pd
import numpy as np
from pandas import Series,DataFrame
datatrain=pd.read_csv(inputfile)
print(datatrain.head(3))
print ('--------------------------')
df=datatrain.as_matrix()
X=df[:,1:]
y=df[:,0]

#-------------
#preprocess data to [-1,1]
from sklearn import preprocessing
scaler=preprocessing.StandardScaler().fit(X)
X=scaler.transform(X)


#-------------
#train model
from sklearn.ensemble import RandomForestClassifier
rf=RandomForestClassifier()
rf.fit(X,y)
importances=rf.feature_importances_
predictors=datatrain.columns[1:]
std = np.std([rf.feature_importances_ for tree in rf.estimators_], axis=0)
indices = np.argsort(importances)[::-1]
sorted_important_features=[]
for i in indices:
    sorted_important_features.append(predictors[i])
file_object = open('featurename100.txt','w')
count=0;
for i in indices:
#	print (predictors[i],end=':')
#	print (indices[i],end=':')
#	print (importances[i])
	print (i,end='\t')
	print (importances[i],end='\t')
	print (predictors[i])	
	if (count<99):
	    file_object.write('\''+predictors[i]+'\',\n')
	if (count==99):
	    file_object.write('\''+predictors[i]+'\'')
	count=count+1
file_object.close()
#print ('--------------------------')
#write indices-------------
dataindices=pd.DataFrame({'indices':indices})
dataindices.to_csv("indices.csv")
#csvfile=file('indices.csv','wb')

#--------------
#plot 
import matplotlib
matplotlib.use('TKAgg') 
import matplotlib.pyplot as plt
plt.figure(figsize=(16,8)) 
plt.title("Feature Importances")
plt.bar(range(np.size(predictors)), importances[indices],
       color="r", yerr=std[indices], align="center")
plt.xticks(range(np.size(predictors)), sorted_important_features)
plt.xlim([-1, np.size(predictors)])
plt.show()
