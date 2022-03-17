#include <iostream>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <fstream>

using namespace std;

int MOVE_OF_KNIGHT[8][2] = {{2, 1},
                            {1, 2},
                            {-1, 2},
                            {2, -1},
                            {-2, 1},
                            {-2, -1},
                            {-1, -2},
                            {1, -2}};

bool writeFile(string path, int size, int **board, int posX, int posY, double time, long long moves)
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
            fo << abs(board[i][j]) << " ";
        }
        fo << endl;
    }

    fo.close();
    return true;
}

bool isSafe(int size, int **board, int posX, int posY)
{
    if (posX < 0 || posY < 0 || posX >= size || posY >= size || board[posY][posX] != -1)
    {
        return false;
    }
    return true;
}

bool checkNextMove(int size, int **board, int current_pos_x, int current_pos_y, int step, long long &moves)
{
    if (step > size * size)
    {
        return true;
    }

    for (int i = 0; i < 8; i++)
    {
        int next_x = current_pos_x + MOVE_OF_KNIGHT[i][0];

        int next_y = current_pos_y + MOVE_OF_KNIGHT[i][1];

        if (isSafe(size, board, next_x, next_y))
        {
            board[next_y][next_x] = step;
            moves++;

            if (checkNextMove(size, board, next_x, next_y, step + 1, moves))
            {
                return true;
            }
            board[next_y][next_x] = -1;
            moves--;
        }
    }
    return false;
}

bool solve(int size, int **board, int current_pos_x, int current_pos_y, long long &moves)
{
    board[current_pos_y][current_pos_x] = 1;
    if (checkNextMove(size, board, current_pos_x, current_pos_y, 2, moves))
    {
        return true;
    }
    return false;
}

void measure(int size, int **board, int posX, int posY)
{
    clock_t start, end;
    long long moves = 0;

    start = clock();
    solve(size, board, posX - 1, posY - 1, moves);
    end = clock();
    if (!writeFile("./20127566_backtrack.txt", size, board, posX, posY, double(end - start), moves))
    {
        writeFile("./Output/20127566_backtrack.txt", size, board, posX, posY, double(end - start), moves);
    }
}

int main(int argc, char *argv[])
{
    int x = atoi(argv[2]);
    int y = atoi(argv[4]);
    int size = atoi(argv[6]);
    int **board = new int *[size];
    for (int i = 0; i < size; i++)
    {
        board[i] = new int[size];
        for (int j = 0; j < size; j++)
        {
            board[i][j] = -1;
        }
    }

    measure(size, board, x, y);

    for (int i = 0; i < size; i++)
    {
        delete board[i];
        board[i] = nullptr;
    }

    delete board;

    return EXIT_SUCCESS;
}
