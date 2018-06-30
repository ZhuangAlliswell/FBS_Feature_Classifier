#part1-------------
#handle cmd parameter
import sys
try:
	inputfile=sys.argv[1]
except IndexError:
	print ('Reference input format : python model_comparison.py [inputfile]')
	exit()
print ('inputfile is:', inputfile)

#part2-------------
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

#part3-------------
#preprocess data to [-1,1]
from sklearn import preprocessing
scaler=preprocessing.StandardScaler().fit(X)
X=scaler.transform(X)


#part4-------------
#train model
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier,ExtraTreesClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import ShuffleSplit,cross_val_score

classifiers=[
LogisticRegression(),
SVC(),
RandomForestClassifier(),
GradientBoostingClassifier(),
GaussianNB(),
AdaBoostClassifier(),
DecisionTreeClassifier(),
ExtraTreesClassifier(),
LinearDiscriminantAnalysis(),
QuadraticDiscriminantAnalysis(),
KNeighborsClassifier()
]

log_cols = ["Classifier", "Accuracy"]
log = pd.DataFrame(columns=log_cols)
for clf in classifiers:
    clf.fit(X,y)  
    name=clf.__class__.__name__
    mean=np.mean(cross_val_score(clf,X,y,cv=10))
    log_entry = pd.DataFrame([[name,mean]], columns=log_cols)
    log=log.append(log_entry)
    print (name,end=':')
    print (mean)

print ('--------------------------')
print ('Best Classifier : ',end='')
print (log[log['Accuracy']==log['Accuracy'].max()]['Classifier'].values[0])

#part5--------------
#plot 
import matplotlib
matplotlib.use('TKAgg') 
import matplotlib.pyplot as plt
import seaborn as sns
plt.figure(figsize=(16,8)) 
plt.xlabel('Accuracy')
plt.title('Classifier Accuracy')
sns.set_color_codes("muted")
sns.barplot(x='Accuracy', y='Classifier', data=log, color="b")
plt.show()
