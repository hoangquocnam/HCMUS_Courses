#include <iostream>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
using namespace std;

int MOVE_OF_KNIGHT[8][2] = {{2, 1},
                            {1, 2},
                            {-1, 2},
                            {2, -1},
                            {-2, 1},
                            {-2, -1},
                            {-1, -2},
                            {1, -2}};

void printBoard(int size, int **board)
{
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            if (board[i][j] < 10)
            {
                cout << " ";
            }
            cout << abs(board[i][j]) << " ";
        }
        cout << endl;
    }
}

bool isSafe(int size, int **board, int posX, int posY)
{
    if (posX >= 0 && posY >= 0 && posX < size && posY < size && board[posY][posX] == -1)
    {
        return true;
    }
    return false;
}

bool check_BT(int size, int **board, int current_pos_x, int current_pos_y, int step, long long &moves)
{
    if (step > size * size)
    {
        return true;
    }

    for (int i = 0; i < 8; i++)
    {
        int next_x = current_pos_x + MOVE_OF_KNIGHT[i][0];

        int next_y = current_pos_y + MOVE_OF_KNIGHT[i][1];
        moves++;

        if (isSafe(size, board, next_x, next_y))
        {
            board[next_y][next_x] = step;
            board[next_y][next_x];
            if (check_BT(size, board, next_x, next_y, step + 1, moves))
            {
                return true;
            }
            board[next_y][next_x] = -1;
        }
    }
    return false;
}

void solve_BT(int size, int current_pos_x, int current_pos_y, long long &moves)
{
    int **board = new int *[size];
    for (int i = 0; i < size; i++)
    {
        board[i] = new int[size];
        for (int j = 0; j < size; j++)
        {
            board[i][j] = -1;
        }
    }
    board[current_pos_y][current_pos_x] = 1;
    if (check_BT(size, board, current_pos_x, current_pos_y, 2, moves))
    {
        printBoard(size, board);
    }
    else
    {
        cout << "There is no solution";
    }
    for (int i = 0; i < size; i++)
    {
        delete board[i];
        board[i] = nullptr;
    }

    delete board;
}

int main(int argc, char *argv[])
{
    clock_t start, end;
    int x = atoi(argv[2]);
    int y = atoi(argv[4]);
    int size = atoi(argv[6]);
    long long moves = 0;
    
    cout << "SIZE -> " << size << "x" << size << endl;
    cout << "START AT -> [X]:" << x << " - " << "[Y]:" << y << endl;
    start = clock();
    solve_BT(size, x - 1, y - 1, moves);
    end = clock();
    cout << "TIME -> " << end - start << "ms" << endl;
    cout << "MOVES -> " << moves << endl;

    return EXIT_SUCCESS;
}
