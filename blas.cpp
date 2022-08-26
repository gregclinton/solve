/*
sudo apt-get install libopenblas-dev

g++ -std=c++20 -o test blas.cpp
*/

#include <iostream>
#include <cblas.h>

using namespace std;

int main()
{
    cout << "blas" << endl;
    return 0;
}