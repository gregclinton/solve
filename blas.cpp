/*
sudo apt-get install libopenblas-dev

g++ -std=c++20 -o test blas.cpp
*/

#include <iostream>
#include <random>
#include <algorithm>
#include <vector>
#include <cblas.h>

using namespace std;

int main()
{
    cout << "blas" << endl;

    mt19937 rng(1234);
    uniform_real_distribution<double> dist;

    vector<double> a(10);
    generate(begin(a), end(a), [&rng, &dist] () { return dist(rng); });

    cout << a[0] << endl;

    return 0;
}