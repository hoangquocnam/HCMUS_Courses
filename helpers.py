from tokenize import Number
import numpy as NP
import pandas as PD
import matplotlib.pyplot as PLT
import seaborn as SNS
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.utils import shuffle
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.tree import DecisionTreeClassifier, export_graphviz
import graphviz


def getColumnsAttribute():
    columnsData = []
    for columns in range(0, 6):
        for row in range(65, 65+7):
            columnsData.append(chr(row) + str(columns+1))

    columnsData.append("Result")
    return columnsData


def convertLabelEncoder(data: PD.DataFrame):
    labelencoder = LabelEncoder()
    for column in data.columns:
        data[column] = labelencoder.fit_transform(data[column])
    return data


def readDatabaseToDataFrame(databasePath):
    columnsAttribute = getColumnsAttribute()
    df = PD.read_csv(databasePath, names=columnsAttribute, sep=",")
    # Shuffle data
    df = shuffle(df)

    # Covert label to number
    df = convertLabelEncoder(df)
    return df


def createTree(feature, label, maxDepth: Number = None):
    clf = DecisionTreeClassifier(max_depth=maxDepth)
    clf.fit(feature, label)
    return clf


def drawTree(featrue, label, maxDepth: Number = None, testSize: float = 0.2):
    clf = createTree(featrue, label, maxDepth)
    dot_data = export_graphviz(clf, feature_names=featrue.columns, filled=True, rounded=True, special_characters=True)
    graph = graphviz.Source(dot_data)
    graph.format = 'png'
    graph.render("./assets/trees/" + str(maxDepth) + "/tree" + "_" + str(maxDepth) + "_" + str(testSize))


def splitData(data: PD.DataFrame, testSize: float):
    featrue = data.drop(['Result'], axis=1)
    label = data['Result']
    featrue_train, feature_test, label_train, label_test = train_test_split(
        featrue, label, test_size=testSize)

    return featrue_train, feature_test, label_train, label_test


def predictTest(clf, feature, label, testSize: float):
    label_pred = clf.predict(feature)
    f = open('./output/prediction_' + str(testSize) + ".txt", 'w')
    f.write("Decision Tree Classifier report \n" + 
          classification_report(label, label_pred))
    return label_pred


def drawConfusionMatrix(clf, feature, label, testSize: float):
    label_pred = predictTest(clf, feature, label, testSize)
    cfm = confusion_matrix(label, label_pred)
    SNS.heatmap(cfm, annot=True, linewidths=.5, cmap="OrRd", fmt='g')
    PLT.title('Decision Tree Classifier confusion matrix')
    PLT.show()


def calculateAccuracy(featureTrain, labelTrain, featureTest, labelTest,  maxDepth: Number = None):
    clf: DecisionTreeClassifier = createTree(
        featureTrain, labelTrain, maxDepth)
    pred = clf.predict(featureTest)
    return accuracy_score(labelTest, pred)


def getAccuracies(maxDepths,  featureTrain, labelTrain, featureTest, labelTest):
    accuracies = []
    for maxDepth in maxDepths:
        accuracies.append(calculateAccuracy(
            featureTrain, labelTrain, featureTest, labelTest, maxDepth))
    return accuracies

