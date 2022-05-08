#include <iostream>
#include <queue>
#include <sstream>
#include <fstream>
#include <ctime>
#include <vector>
using namespace std;

struct NODE {
	int key;
	NODE* left;
	NODE* right;
	//int height;
};

NODE* createNode(int data) {
	NODE* pNode = new NODE;
	pNode->key = data;
	pNode->left = NULL;
	pNode->right = NULL;
	//pNode->height = 1;
	return pNode;
}

int Height(NODE* node){
	if (node == NULL)
		return 0;
	else{
		int lDepth = Height(node->left);
		int rDepth = Height(node->right);

		if (lDepth > rDepth)
			return(lDepth + 1);
		else return(rDepth + 1);
	}
}

int getBalance(NODE* pRoot) {
	if (pRoot == NULL)
		return 0;
	return Height(pRoot->left) - Height(pRoot->right);
}

int* readFile(string fileName, int& n) {
	int* a = nullptr;
	ifstream fi(fileName);
	if (!fi.is_open()) return nullptr;

	fi >> n;
	a = new int[n];

	for (int i = 0; i < n; i++) {
		fi >> a[i];
	}

	fi.close();
	return a;
}

void removeTree(NODE*& pRoot) {
	if (pRoot == NULL)
		return;
	removeTree(pRoot->left);

	removeTree(pRoot->right);
	delete pRoot;
	pRoot = NULL;
}

NODE* LeftRotate(NODE*& pRoot) {
	if (pRoot == NULL)
		return NULL;
	NODE* b = pRoot->right;
	NODE* c = b ->left;

	b->left = pRoot;
	pRoot->right = c;

	/*pRoot->height = max(Height(pRoot->left),
		Height(pRoot->right)) + 1;
	b->height = max(Height(b->left),
		Height(b->right)) + 1;*/

	return b;
}

NODE* RightRotate(NODE*& pRoot) {
	if (pRoot == NULL)
		return NULL;
	NODE* b = pRoot->left;
	NODE* c = b->right;
	
	b->right = pRoot;
	pRoot->left = c;

	/*pRoot->height = max(Height(pRoot->left),
		Height(pRoot->right)) + 1;
	b->height = max(Height(b->left),
		Height(b->right)) + 1;*/

	return b;
}

void getBalancee(NODE* &pRoot) {
	if (abs(getBalance(pRoot)) > 1) {
		if (getBalance(pRoot) > 0) {
			NODE* p = pRoot->left;
			if (getBalance(p) >= 0) {
				pRoot = RightRotate(pRoot);
			}
			else {
				pRoot->left = LeftRotate(pRoot->left);
				pRoot = RightRotate(pRoot);
			}
		}
		else {
			NODE* p = pRoot->right;
			if (getBalance(p) <= 0) {
				pRoot = LeftRotate(pRoot);
			}
			else {
				pRoot->right = RightRotate(pRoot->right);
				pRoot = LeftRotate(pRoot);

			}
		}
	}
}

void Insert(NODE*& pRoot, int x) {
	if (pRoot == NULL) {
		pRoot = createNode(x);
		return;
	}
	if (pRoot->key == x) {
		return;
	}
	if (pRoot->key > x) {
		Insert(pRoot->left, x);
	}
	if (pRoot->key < x) {
		Insert(pRoot->right, x);
	}
	getBalancee(pRoot);
}

NODE* createTree(int a[], int n) {  
	NODE* pRoot = NULL;
	for (int i = 0;i < n;i++) {
		Insert(pRoot, a[i]);
	}
	return pRoot;
}

void NLR(NODE* pRoot) {           //post
	if (pRoot == NULL)
		return;
	else {
		cout << pRoot->key << " ";
		NLR(pRoot->left);
		NLR(pRoot->right);
	}
}

NODE* findMin(NODE* pRoot) {
	if (pRoot == NULL)
		return NULL;
	else {
		if (pRoot->left) {
			if (pRoot->key > pRoot->left->key) {
				return findMin(pRoot->left);
			}
		}
		else return pRoot;
	}
}

void Remove(NODE*& pRoot, int x) {
	if (pRoot == NULL)
		return;
	else if (x < pRoot->key)
		Remove(pRoot->left, x);
	else if (x > pRoot->key)
		Remove(pRoot->right, x);
	else {
		if (pRoot->left == NULL && pRoot->right == NULL) {
			delete pRoot;
			pRoot = NULL;
		}
		else if (pRoot->left == NULL) {
			NODE* temp = pRoot;
			pRoot = pRoot->right;
			delete temp;
		}
		else if (pRoot->right == NULL) {
			NODE* temp = pRoot;
			pRoot = pRoot->left;
			delete temp;
		}
		else {
			NODE* p = findMin(pRoot->right);
			pRoot->key = p->key;
			Remove(pRoot->right, p->key);
		}

	}

	if (pRoot == NULL)
		return;

	//pRoot->height = 1 + max(Height(pRoot->left), Height(pRoot->right));

	getBalancee(pRoot);
	
}

bool isAVL(NODE* pRoot) {
	if (pRoot == NULL)
		return true;

	int left = Height(pRoot->left);
	int right = Height(pRoot->right);

	if (abs(left-right) <=1 && isAVL(pRoot->left) && isAVL(pRoot->right))
		return true;
	
	return false;
}

void LevelOrder(NODE* pRoot) {
	if (pRoot == NULL)return;
	queue<NODE*> Q;
	Q.push(pRoot);
	while (!Q.empty()) {
		NODE* temp = Q.front();
		cout << temp->key << " ";

		if (temp->left)
			Q.push(temp->left);
		if (temp->right)
			Q.push(temp->right);
		Q.pop();
	}
}

int countLeaf(NODE* pRoot) {
	if (pRoot == NULL)
		return 0;
	if (pRoot->left == NULL && pRoot->right == NULL) return 1;
	else return countLeaf(pRoot->left) + countLeaf(pRoot->right);
}

void generateArr(int*& a, int n) {
	a = new int[n];
	srand((unsigned int)time(NULL));

	for (int i = 0;i < n;i++) {
		a[i] = rand() % 50;
	}
}

bool isPrime(int n) {
	if (n < 2)return false;
	for (int i = 2;i < n;i++) {
		if (n % i == 0)
			return false;
	}
	return true;
}

//void generateArrPrime(int*& a, int n) {
//	a = new int[n];
//	srand((unsigned int)time(NULL));
//
//	for (int i = 0;i < n;i++) {
//		int temp = rand() % 20;
//		if (isPrime(temp)) {
//			a[i] = temp;
//		}
//	}
//}

int main() {
	
	int a[10] = { 6,3,16,8,32,7,31,8,10,1 };
	
	NODE* pRoot = createTree(a, 10);
	LevelOrder(pRoot);
	Remove(pRoot, 16);
	cout << endl;
	LevelOrder(pRoot);
	cout << endl;
	system("pause");
	return 0;
}