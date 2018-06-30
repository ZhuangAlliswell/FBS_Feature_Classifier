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

for i in range(len(importances)):
	print (predictors[i],end=':')
	print (importances[i])

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
