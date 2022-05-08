#include <iostream>
using namespace std;
struct NODE
{
    int key;
    NODE *p_next;
};
struct List
{
    NODE *p_head;
    NODE *p_tail;
};
NODE *createNode(int data)
{
    NODE *head = new NODE();
    head->key = data;
    head->p_next = NULL;
    return head;
}

List *createList(NODE *p_node)
{
    List *L = new List();
    L->p_head = p_node;
    L->p_tail = p_node;
    return L;
}

bool addHead(List *&L, int data)
{
    NODE *p = createNode(data);
    if (p == NULL)
        return false;
    if (L->p_head == NULL)
    {
        L = createList(p);
        return true;
    }
    p->p_next = L->p_head;
    L->p_head = p;
    return true;
}

bool addTail(List *&L, int data)
{
    NODE *p = createNode(data);
    if (p == NULL)
        return false;
    if (L->p_head == NULL)
    {
        L = createList(p);
        return true;
    }
    L->p_tail->p_next = p;
    L->p_tail = p;
    return true;
}

bool removeTail(List *&lst)
{
    if (lst->p_head == NULL)
        return 0;

    if (lst->p_head->p_next == NULL)
    {
        delete lst->p_head;
        lst->p_head = NULL;
        lst->p_tail = NULL;
        return 1;
    }
    NODE *temp = lst->p_head;
    while (temp->p_next != lst->p_tail)
    {
        temp = temp->p_next;
    }
    temp->p_next = NULL;
    delete temp->p_next;
    lst->p_tail = temp;
    return 1;
}

bool removeHead(List *&lst)
{
    if (lst->p_head == NULL)
        return 0;
    NODE *pCur = lst->p_head;
    if (pCur->p_next == NULL)
    {
        delete pCur;
        lst->p_head = NULL;
        lst->p_tail = NULL;
        return 1;
    }
    lst->p_head = pCur->p_next;
    delete pCur;
    pCur = NULL;
    return 1;
}

void removeAll(List *&L)
{
    if (L->p_head == NULL)
    {
        return;
    }
    while (L->p_head)
    {
        removeHead(L);
    }
    delete L->p_head;
}

bool removeBefore(List *&lst, int val)
{
    NODE *temp = lst->p_head;
    if (temp->key == val || temp == NULL || temp->p_next == NULL)
    {
        return 0;
    }
    if (temp->p_next->key == val)
    {
        removeHead(lst);
        return 1;
    }
    NODE *pCur = NULL;
    while (temp->p_next->key != val)
    {
        pCur = temp;
        temp = temp->p_next;
        if (temp->p_next == NULL)
        {
            cout << "can't find val!" << endl;
            return 0;
        }
    }
    pCur->p_next = temp->p_next;
    delete temp;
    temp = NULL;
    return 1;
}

void removeAfter(List *&lst, int val)
{
    NODE *temp = lst->p_head;
    if (temp == NULL || temp->p_next == NULL)
    {
        return;
    }

    while (temp->key != val)
    {
        temp = temp->p_next;
        if (temp->p_next == NULL)
        {
            cout << "can't delete.\n";
            return;
        }
    }

    NODE *pCur = temp->p_next;
    if (pCur->p_next == NULL && temp->key == val)
    {
        removeTail(lst);
        return;
    }

    temp->p_next = pCur->p_next;
    delete pCur;
    pCur = NULL;
}

bool addPos(List *&L, int data, int pos)
{
    if ((L->p_head == NULL && pos != 0) || (pos < 0))
        return false;
    if (pos == 0)
    {
        addHead(L, data);
        return 1;
    }
    NODE *newNode = createNode(data);
    NODE *temp = L->p_head;

    for (int i = 0; i < pos - 1; i++)
    {
        temp = temp->p_next;
        if (temp == NULL)
            return 0;
    }
    NODE *pCur = temp->p_next;
    temp->p_next = newNode;
    newNode->p_next = pCur;
    return 1;
}

void RemovePos(List *&L, int pos)
{
    if (L->p_head == NULL || pos < 0 || (!L->p_head->p_next && pos > 0))
        return;
    if (pos == 0)
    {
        removeHead(L);
        return;
    }
    NODE *pCur = L->p_head;
    for (int i = 0; i < pos - 1; i++)
    {
        pCur = pCur->p_next;
        if (pCur->p_next == NULL)
        {
            cout << "cant remove\n";
            return;
        }
    }
    pCur->p_next = pCur->p_next->p_next;
}

bool addBefore(List *&lst, int data, int val)
{
    NODE *temp = lst->p_head;
    NODE *newNode = createNode(data);
    if (lst->p_head->key == val)
    {
        addHead(lst, data);
        return 1;
    }
    NODE *pCur = NULL;
    while (temp->key != val)
    {
        pCur = temp;
        temp = temp->p_next;
        if (temp == NULL)
            return 0;
    }
    pCur->p_next = newNode;
    newNode->p_next = temp;
    return 1;
}

bool addAfter(List *&lst, int data, int val)
{
    NODE *pCur = lst->p_head;
    NODE *newNode = createNode(data);
    if (pCur->key == val && pCur->p_next == NULL)
    {
        addTail(lst, data);
        return 1;
    }
    while (pCur->key != val)
    {
        pCur = pCur->p_next;
        if (pCur == nullptr)
            return 0;
    }
    NODE *temp = pCur->p_next;
    pCur->p_next = newNode;
    newNode->p_next = temp;
    return 1;
}

void printList(List *L)
{
    if (L->p_head == NULL)
    {
        cout << "Empty.\n";
        return;
    }
    for (NODE *current = L->p_head; current != NULL; current = current->p_next)
    {
        cout << current->key << " ";
    }
    cout << endl;
}

int countElements(List *lst)
{
    int count = 0;
    if (lst->p_head == NULL)
        return 0;
    NODE *p = lst->p_head;
    while (p)
    {
        count++;
        p = p->p_next;
    }
    return count;
}

void reverseList(List *&lst)
{
    if (lst->p_head == NULL)
    {
        return;
    }
    NODE *prev = NULL, *current = lst->p_head, *next;
    while (current != NULL)
    {
        next = current->p_next;
        current->p_next = prev;
        prev = current;
        current = next;
    }
    lst->p_head = prev;
}

void removeDuplicates(List *&lst)
{
    if (lst->p_head == NULL)
        return;
    NODE *ptr1, *ptr2, *dup;
    ptr1 = lst->p_head;

    while (ptr1 != NULL && ptr1->p_next != NULL)
    {
        ptr2 = ptr1;
        while (ptr2->p_next != NULL)
        {
            if (ptr1->key == ptr2->p_next->key)
            {
                dup = ptr2->p_next;
                ptr2->p_next = ptr2->p_next->p_next;
                delete dup;
            }
            else
                ptr2 = ptr2->p_next;
        }
        ptr1 = ptr1->p_next;
    }
}

bool removeElement(List *&lst, int key)
{
    NODE *temp = lst->p_head, *del;
    if (!temp)
        return 0;
    while (temp->p_next)
    {
        if (temp->p_next->key == key)
        {
            del = temp->p_next;
            if (del->p_next == NULL)
            {
                temp->p_next = NULL;
                return 1;
            }
            temp->p_next = del->p_next;
            delete del;
        }
        else
        {
            temp = temp->p_next;
        }
    }

    if (lst->p_head->key == key)
    {
        removeHead(lst);
    }
    return 1;
}

void removeN(List *&lst, int n)
{
    NODE *p = lst->p_head;
    while (p)
    {
        NODE *temp = p;
        if (temp->key % n == 0)
        {
            p = p->p_next;
            removeElement(lst, temp->key);
            temp = NULL;
        }
        else
            p = p->p_next;
    }
}

int sortList(List *&l)
{
    int count = 0;
    for (NODE *temp = l->p_head; temp != NULL; temp = temp->p_next)
    {
        for (NODE *temp2 = temp->p_next; temp2 != NULL; temp2 = temp2->p_next)
        {
            if (temp->key >= temp2->key)
            {
                swap(temp->key, temp2->key);
            }
        }
        count++;
    }
    return count;
}

bool isSameList(List *l1, List *l2)
{
    int a = sortList(l1);
    int b = sortList(l2);
    NODE *temp = l1->p_head;
    NODE *temp2 = l2->p_head;
    if (l1->p_head == NULL || l2->p_head == NULL || a != b)
    {
        return false;
    }
    else
    {
        for (int i = 0; i < a; i++)
        {
            if (temp->key != temp2->key)
            {
                return false;
            }
            temp2 = temp2->p_next;
            temp = temp->p_next;
        }
    }
    return true;
}

List *merge2List(List *l1, List *l2)
{
    NODE *t1 = l1->p_head;
    NODE *t2 = l2->p_head;
    List *L;
    if (t1 == NULL && t2 == NULL)
        return nullptr;
    while (t1 == NULL)
    {
        L = createList(createNode(t2->key));
        t2 = t2->p_next;
    }
    while (t2 == NULL)
    {
        L = createList(createNode(t1->key));
        t1 = t1->p_next;
    }
    if (t1->key < t2->key)
    {
        L = createList(createNode(t1->key));
        t1 = t1->p_next;
    }
    else
    {
        L = createList(createNode(t2->key));
        t2 = t2->p_next;
    }
    while (t1 != NULL && t2 != NULL)
    {
        if (t1->key < t2->key)
        {
            addTail(L, t1->key);
            t1 = t1->p_next;
        }
        else
        {
            addTail(L, t1->key);
            t2 = t2->p_next;
        }
    }
    while (t1)
    {
        addTail(L, t1->key);
        t1 = t1->p_next;
    }
    while (t1)
    {
        addTail(L, t1->key);
        t2 = t2->p_next;
    }
    return L;
}

int main()
{
    List *lst = createList(createNode(2));
    int a[6] = {3, 6, 7, 9, 10, 31};
    int b[7] = {1, 2, 4, 5, 9, 17, 40};

    for (int i = 0; i < sizeof(a) / 4; i++)
    {
        addTail(lst, a[i]);
    }
    printList(lst);
    List *l1 = NULL;
    l1->p_head = NULL;
    l1->p_head = NULL;
    /*for (int i = 0;i < sizeof(b) / 4;i++) {
        addTail(l1, b[i]);
    }*/
    printList(l1);
    List *r = merge2List(lst, l1);

    printList(r);

    return 0;
}