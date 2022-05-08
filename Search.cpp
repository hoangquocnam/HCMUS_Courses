#include <iostream>
using namespace std;
int LinearSearch(int *a, int n, int key)
{
    for (int i = 0; i < n; i++)
    {
        if (a[i] == key)
        {
            return i;
        }
    }
    return -1;
}

void inputArray(int *&a, int &n)
{
    cout << "Input the number of elements of array : ";
    cin >> n;
    a = new int[n];
    for (int i = 0; i < n; i++)
    {
        cout << "Input a[" << i << "]:";
        cin >> a[i];
    }
}

int SentinelLinearSearch(int *a, int n, int key)
{
    int last = a[n - 1];
    int i = 0;
    a[n - 1] = key;
    while (a[i] != key)
    {
        i++;
    }
    a[n - 1] = last;
    if (i < n - 1 || a[n - 1] == key)
    {
        return i;
    }
    else
        return -1;
}

int BinarySearch(int *a, int n, int key)
{
    int mid = n / 2;
    if (a[mid] == key)
        return mid;
    else if (a[mid] > key)
    {
        for (int i = 0; i < mid; i++)
        {
            if (a[i] == key)
                return i;
        }
    }
    else
    {
        for (int i = mid; i < n; i++)
        {
            if (a[i] == key)
                return i;
        }
    }
    return -1;
}

int RecursiveBinarySearch(int *a, int left, int right, int key)
{
    if (right >= left)
    {
        int mid = left + (right - left) / 2;
        if (a[mid] == key)
            return mid;
        if (a[mid] < key)
        {
            return RecursiveBinarySearch(a, mid + 1, right, key);
        }
        else
            return RecursiveBinarySearch(a, left, mid - 1, key);
    }
    return -1;
}

int main()
{
    int *a;
    int n;
    inputArray(a, n);
    int key;
    cin >> key;
    cout << RecursiveBinarySearch(a, 0, n - 1, key);
    return 0;
}