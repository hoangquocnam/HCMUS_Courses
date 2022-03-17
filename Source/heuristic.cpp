#include <iostream>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include<fstream>
#include <cstring>
using namespace std;

int MOVE_OF_KNIGHT[8][2] = {{2, 1},
                            {1, 2},
                            {-1, 2},
                            {2, -1},
                            {-2, 1},
                            {-2, -1},
                            {-1, -2},
                            {1, -2}};

bool writeFile(string path, int size, int *board, int posX, int posY, double time, long long moves)
{
    ofstream fo(path, ios::out);
    if (fo.fail())
    {
        return false;
    }
    fo << "[X]: " << posX << " - [Y]: " << posY << " - SIZE: " << size << endl;
    fo << "MOVES: " << moves << endl;
    fo << "TIME: " << time << "ms" << endl;
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            if (board[i * size + j] < 10)
            {
                fo << " ";
            }
            fo << board[i * size + j] << " ";
        }
        fo << endl;
    }
    fo.close();
    return true;
}

bool isSafe(int size, int *board, int posX, int posY)
{
    return (posX >= 0 && posY >= 0 && posY < size && posX < size && board[posY * size + posX] == -1);
}

int heuristic(int size, int *board, int pos_x, int pos_y)
{
    int count = 0;
    for (int i = 0; i < 8; i++)
    {
        int next_x = pos_x + MOVE_OF_KNIGHT[i][0];
        int next_y = pos_y + MOVE_OF_KNIGHT[i][1];
        if (isSafe(size, board, next_x, next_y))
        {
            count++;
        }
    }
    return count;
}

bool checkNextMove(int size, int *board, int &pos_x, int &pos_y)
{
    int min_index = -1;
    int min_heuristic = size + 1;
    for (int i = 0; i < size; i++)
    {
        int next_x = pos_x + MOVE_OF_KNIGHT[i][0];
        int next_y = pos_y + MOVE_OF_KNIGHT[i][1];
        int next_heuristic = heuristic(size, board, next_x, next_y);
        if (isSafe(size, board, next_x, next_y) && next_heuristic < min_heuristic)
        {
            min_index = i;
            min_heuristic = next_heuristic;
        }
    }

    if (min_index == -1)
    {
        return false;
    }

    board[(pos_y + MOVE_OF_KNIGHT[min_index][1]) * size + (pos_x + MOVE_OF_KNIGHT[min_index][0])] = board[pos_y * size + pos_x] + 1;

    pos_x += MOVE_OF_KNIGHT[min_index][0];
    pos_y += MOVE_OF_KNIGHT[min_index][1];

    return true;
}

bool solve(int size, int *board, int x, int y, long long moves)
{
    board[y * size + x] = 1;
    for (int i = 0; i < size * size - 1; i++)
    {
        if (!checkNextMove(size, board, x, y))
        {
            return false;
        }
    }

    return true;
}

void measure(int size, int *board, int posX, int posY)
{
    clock_t start, end;
    long long moves = 0;

    start = clock();
    solve(size, board, posX - 1, posY - 1, moves);
    end = clock();
    if (!writeFile("./20127566_heuristic.txt", size, board, posX, posY, double(end - start), moves))
    {
        writeFile("./Output/20127566_heuristic.txt", size, board, posX, posY, double(end - start), moves);
    }
}

int main(int argc, char *argv[])
{
    clock_t start, end;
    int x = atoi(argv[2]);
    int y = atoi(argv[4]);
    int size = atoi(argv[6]);
    int *board = new int[size * size];
    for (int  i = 0; i < size * size;i++){
        board[i] = -1;
    }
    
    measure(size, board, x, y);
    delete board;
    board = nullptr;

    return EXIT_SUCCESS;
}