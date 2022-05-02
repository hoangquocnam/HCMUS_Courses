from tokenize import Number
from typing import Any
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
import sys


def getColumnsAttribute():
    columnsData = []
    for columns in range(0, 6):
        for row in range(65, 65+7):
            columnsData.append(chr(row) + str(columns+1))

    columnsData.append("Result")
    return columnsData


def readDatabaseToDataFrame(databasePath):
    columnsAttribute = getColumnsAttribute()
    df = PD.read_csv(databasePath, names=columnsAttribute, sep=",")
    return df


def convertLabelEncoder(data: PD.DataFrame):
    labelencoder = LabelEncoder()
    for column in data.columns:
        data[column] = labelencoder.fit_transform(data[column])
    return data


def createTree(feature, label, maxDepth: Number = None):
    clf = DecisionTreeClassifier(max_depth=maxDepth)
    clf.fit(feature, label)
    return clf


def drawTree(featrue, label, maxDepth: Number = None, testSize: float = 0.2):
    clf = createTree(featrue, label, maxDepth)
    dot_data = export_graphviz(clf, feature_names=featrue.columns, filled=True, rounded=True, special_characters=True)
    graph = graphviz.Source(dot_data)
    graph.format = 'png'
    graph.render("./assets/trees/tree" + "_" + str(maxDepth) + "_" + str(testSize))


def splitData(data: PD.DataFrame, testSize: float):
    featrue = data.drop(['Result'], axis=1)
    label = data['Result']
    featrue_train, feature_test, label_train, label_test = train_test_split(
        featrue, label, test_size=testSize)

    return featrue_train, feature_test, label_train, label_test


def predictTest(clf, feature, label):
    label_pred = clf.predict(feature)
    print("Decision Tree Classifier report \n",
          classification_report(label, label_pred))


def drawConfusionMatrix(clf, feature, label):
    label_pred = clf.predict(feature)
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


def handleHelp():
    print(">>> Options:")
    print("--help: Show this help")
    print("--tree: Draw decision tree with a test size input")
    print("--trees: Draw all decision trees")
    print("--confusion: Draw confusion matrix")
    print(
        "--accuracies: Calculate accuracies for different max depths : None, 2, 3, 4, 5, 6, 7")


def handleTree(df):
    print(">>> Drawing decision tree")
    print("Test size: ", end="")
    testSizeInput = input()
    testSize = 0.2
    if testSizeInput != "" :
        testSize = float(testSizeInput)

    print("Max depth: ", end="")
    maxDepthInput = input()
    maxDepth = None
    if maxDepthInput != "" :
        maxDepth = int(maxDepthInput)

    featrue_train, feature_test, label_train, label_test = splitData(
        df, testSize)
    drawTree(featrue_train, label_train, maxDepth, testSize)


def handleTrees(df):
    print(">>> Drawing all decision trees")
    testSizes = [0.6, 0.4, 0.2, 0.1]
    maxDepths = [None, 2, 3, 4, 5, 6, 7]
    for testSize in testSizes:
        featrue_train, feature_test, label_train, label_test = splitData(df, testSize)
        for maxDepth in maxDepths:
            drawTree(featrue_train, label_train, maxDepth, testSize)


def handleConfusion(df):
    print(">>> Drawing confusion matrix")
    print("Test size: ", end="")
    testSizeInput = input()
    testSize = 0.2
    if testSizeInput != "":
        testSize = float(testSizeInput)

    featrue_train, feature_test, label_train, label_test = splitData(
        df, testSize)
    clf = createTree(featrue_train, label_train)
    drawConfusionMatrix(clf, feature_test,  label_test)


def handleAccuracies(df):
    print(">>> Calculate accuracies for different max depths : None, 2, 3, 4, 5, 6, 7")
    maxDepths = [None, 2, 3, 4, 5, 6, 7]
    testSizeInput = input()
    testSize = 0.2
    if testSizeInput != "":
        testSize = float(testSizeInput)
    featrue_train, feature_test, label_train, label_test = splitData(df, testSize)
    accuracies = getAccuracies(
        maxDepths, featrue_train, label_train, feature_test, label_test)
    print("Accuracies: ", accuracies)


def main():

    agrs = sys.argv

    if len(agrs) == 1:
        print(">>> No argument given.")
        print("Use --help to see all available options")
    else:
        # Read database
        df = readDatabaseToDataFrame('./database/connect-4.data')

        # Shuffle data
        df = shuffle(df)

        # Covert label to number
        df = convertLabelEncoder(df)

        if (agrs[1] == "--help"):
            handleHelp()

        if (agrs[1] == "--tree"):
            handleTree(df)

        if (agrs[1] == "trees"):
            handleTrees(df)

        if (agrs[1] == "--accuracies"):
            handleAccuracies(df)

        if (agrs[1] == "--confusion"):
            handleConfusion(df)
            

if (__name__ == "__main__"):
    main()
