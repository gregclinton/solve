/*
sudo apt-get install libopenblas-dev

g++ -std=c++20 -o test blas.cpp -lopenblas
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

    auto m = 2;
    auto n = 2;
    vector<double> A(m * n);
    vector<double> B(m * n);
    vector<double> C(m * n);

    generate(begin(A), end(A), [&rng, &dist] () { return dist(rng); });
    generate(begin(B), end(B), [&rng, &dist] () { return dist(rng); });

    cblas_dgemm(CblasRowMajor, CblasTrans, CblasNoTrans, m, n, n, 1, &A[0], n, &B[0], n, 0, &C[0], n);

    cout << C[0] << endl;
    return 0;
}