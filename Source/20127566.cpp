#include <iostream>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <fstream>
#include <string>
using namespace std;

int MOVE_OF_KNIGHT[8][2] = {{2, 1},
                            {1, 2},
                            {-1, 2},
                            {2, -1},
                            {-2, 1},
                            {-2, -1},
                            {-1, -2},
                            {1, -2}};
const double TIME_LIMIT_MS = 60 * 60 * 1000;
// Heuristic
bool writeFile(string path, int size, int *board, int posX, int posY, double time, long long moves)
{
    ofstream fo(path, ios::out);
    if (fo.fail())
    {
        return false;
    }

    fo << posX << " " << posY << " " << size << endl;
    fo << moves << endl;
    fo << time << endl;
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

bool checkNextMove(int size, int *board, int &pos_x, int &pos_y, long long &moves, double timeStart)
{
    int min_index = -1;
    int min_heuristic = size * size;
    int start = rand() % 8;
    for (int i = 0; i < 8; i++)
    {
        int index = (start + i) % 8;
        int next_x = pos_x + MOVE_OF_KNIGHT[index][0];
        int next_y = pos_y + MOVE_OF_KNIGHT[index][1];
        int next_heuristic = heuristic(size, board, next_x, next_y);
        if (isSafe(size, board, next_x, next_y) && next_heuristic < min_heuristic)
        {
            min_index = index;
            min_heuristic = next_heuristic;
        }
    }

    if (min_index == -1)
    {
        return false;
    }

    board[(pos_y + MOVE_OF_KNIGHT[min_index][1]) * size + (pos_x + MOVE_OF_KNIGHT[min_index][0])] = board[pos_y * size + pos_x] + 1;
    moves++;

    pos_x += MOVE_OF_KNIGHT[min_index][0];
    pos_y += MOVE_OF_KNIGHT[min_index][1];

    return true;
}

bool isAllCheck(int size, int *board)
{
    for (int i = 0; i < size * size; i++)
    {
        if (board[i] == -1)
        {
            return false;
        }
    }
    return true;
}

bool solve(int size, int *board, int x, int y, long long &moves, double timeStart)
{
    while (!isAllCheck(size, board))
    {
        for (int i = 0; i < size * size; i++)
        {
            board[i] = -1;
        }
        moves = 0;
        board[y * size + x] = 1;
        for (int i = 0; i < size * size - 1; i++)
        {
            checkNextMove(size, board, x, y, moves, timeStart);
        }
    }

    return true;
}

void measure(int size, int *board, int posX, int posY)
{
    clock_t start, end;
    long long moves = 0;

    start = clock();
    solve(size, board, posX - 1, posY - 1, moves, start);
    end = clock();
    const string path = "./" + to_string(size) + "x" + to_string(size) + "/20127566_heuristic_[" + to_string(posX) + "," + to_string(posY) + "].txt";
    writeFile(path, size, board, posX, posY, double(end - start), moves);
}

// Backtracking
bool writeFile(string path, int size, int **board, int posX, int posY, double time, long long moves)
{
    ofstream fo(path, ios::out);
    if (fo.fail())
    {
        return false;
    }
    fo << posX << " " << posY << " " << size << endl;
    fo << moves << endl;
    fo << time << endl;
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

bool checkNextMove(int size, int **board, int current_pos_x, int current_pos_y, int step, long long &moves, double timeStart)
{
    if (step > size * size)
    {
        return true;
    }

    if (clock() - timeStart >= TIME_LIMIT_MS)
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

            if (checkNextMove(size, board, next_x, next_y, step + 1, moves, timeStart))
            {
                return true;
            }
            board[next_y][next_x] = -1;
        }
    }
    return false;
}

bool solve(int size, int **board, int current_pos_x, int current_pos_y, long long &moves, double timeStart)
{
    board[current_pos_y][current_pos_x] = 1;
    if (checkNextMove(size, board, current_pos_x, current_pos_y, 2, moves, timeStart))
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
    solve(size, board, posX - 1, posY - 1, moves, start);
    end = clock();
    const string path = "./" + to_string(size) + "x" + to_string(size) + "/20127566_backtrack_[" + to_string(posX) + "," + to_string(posY) + "].txt";
    writeFile(path, size, board, posX, posY, double(end - start), moves);
}

int main(int argc, char *argv[])
{
    srand(time(NULL));
    clock_t start, end;
    int x = atoi(argv[2]);
    int y = atoi(argv[4]);
    int size = atoi(argv[6]);
    int *board_h = new int[size * size];
    for (int i = 0; i < size * size; i++)
    {
        board_h[i] = -1;
    }

    measure(size, board_h, x, y);
    delete board_h;
    board_h = nullptr;

    int **board_b = new int *[size];
    for (int i = 0; i < size; i++)
    {
        board_b[i] = new int[size];
        for (int j = 0; j < size; j++)
        {
            board_b[i][j] = -1;
        }
    }

    measure(size, board_b, x, y);

    for (int i = 0; i < size; i++)
    {
        delete board_b[i];
        board_b[i] = nullptr;
    }

    delete board_b;

    return EXIT_SUCCESS;
}