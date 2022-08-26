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

    mt19937 rng(1234);
    uniform_real_distribution<double> dist;
    cout << dist(rng) << endl;

    return 0;
}