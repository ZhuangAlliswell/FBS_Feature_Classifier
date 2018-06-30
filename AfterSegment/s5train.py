#part1-------------
#set data direction
import sys
indir='trainingData\\'
outdir='result\\'

import pandas as pd
import numpy as np
from pandas import Series,DataFrame
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier,ExtraTreesClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import ShuffleSplit,cross_val_score
#part2-------------
#preprocess data 
datafit=pd.read_csv('fittingdata.csv') #PCA和Scaler的训练数据
datatest=pd.read_csv('testingData\\testingData.csv') #测试数据
dff=datafit.as_matrix()
dft=datatest.as_matrix()
Xf=dff[:,1:]
yf=dff[:,0]
Xt=dft[:,1:]
yt=dft[:,0]


from sklearn import preprocessing
scaler=preprocessing.StandardScaler().fit(Xf)
Xf=scaler.transform(Xf)
Xt=scaler.transform(Xt)

#part3--------PCA
from sklearn.decomposition import PCA
pca=PCA(n_components=25)
Xf=pca.fit_transform(Xf)
Xt=pca.transform(Xt)
scaler2=preprocessing.StandardScaler().fit(Xf)
Xf=scaler2.transform(Xf)
Xt=scaler2.transform(Xt)

#part4-----train
clf=SVC(probability=True)
for positive in [1,2,3,5,6]:
        #read training data
        datatrain=pd.read_csv(indir+'trainingData'+str(positive)+'.csv')
        df=datatrain.as_matrix()
        X=df[:,1:]
        y=df[:,0]         
        X=scaler.transform(X)
        X=pca.transform(X)
        X=scaler2.transform(X)
        clf.fit(X,y)        
        mean=np.mean(cross_val_score(clf,X,y,cv=10))
        print ('device'+str(positive),end=':')
        print (mean)	        
        probaMatrix=clf.predict_proba(Xt)       
        np.savetxt(outdir+'probaMatrix'+str(positive)+'.csv',probaMatrix,fmt='%.5f',delimiter = ',')       
    
