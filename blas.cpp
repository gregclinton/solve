/*
sudo apt-get install libopenblas-dev

g++ -std=c++20 -o test blas.cpp
*/

#include <iostream>
#include <random>
#include <cblas.h>

using namespace std;

int main()
{
    cout << "blas" << endl;

    random_device dev;
    mt19937 rng(dev());

    uniform_int_distribution<mt19937::result_type> dist6(1,6);
    cout << dist6(rng) << endl;

    return 0;
}