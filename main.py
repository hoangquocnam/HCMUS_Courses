from helpers import readDatabaseToDataFrame, createTree, drawTree, splitData, drawConfusionMatrix, calculateAccuracy, getAccuracies
import sys


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
    if testSizeInput != "":
        testSize = float(testSizeInput)

    print("Max depth: ", end="")
    maxDepthInput = input()
    maxDepth = None
    if maxDepthInput != "":
        maxDepth = int(maxDepthInput)

    featrue_train, feature_test, label_train, label_test = splitData(
        df, testSize)
    drawTree(featrue_train, label_train, maxDepth, testSize)


def handleTrees(df):
    print(">>> Drawing all decision trees")
    testSizes = [0.6, 0.4, 0.2, 0.1]
    maxDepths = [None, 2, 3, 4, 5, 6, 7]
    for testSize in testSizes:
        featrue_train, feature_test, label_train, label_test = splitData(
            df, testSize)
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
    drawConfusionMatrix(clf, feature_test,  label_test, testSize)


def handleAccuracies(df):
    print(">>> Calculate accuracies for different max depths : None, 2, 3, 4, 5, 6, 7")
    maxDepths = [None, 2, 3, 4, 5, 6, 7]
    print("Test size: ", end="")
    testSizeInput = input()
    testSize = 0.2
    if testSizeInput != "":
        testSize = float(testSizeInput)
    featrue_train, feature_test, label_train, label_test = splitData(
        df, testSize)
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

        if (agrs[1] == "--help"):
            handleHelp()

        if (agrs[1] == "--tree"):
            handleTree(df)

        if (agrs[1] == "--trees"):
            handleTrees(df)

        if (agrs[1] == "--accuracies"):
            handleAccuracies(df)

        if (agrs[1] == "--confusion"):
            handleConfusion(df)


if (__name__ == "__main__"):
    main()
