// g++ -std=c++20 -o solve mosek.cpp -lmosek64
// export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"

#include <iostream>
#include <mosek/mosek.h>

using namespace std;

int main()
{
    MSKrescodee trmcode;
    MSKtask_t task = NULL;
    double xx = 0.0;

    MSK_maketask(NULL, 0, 1, &task);
    MSK_appendvars(task, 1);
    MSK_putcj(task, 0, 1.0);
    MSK_putvarbound(task, 0, MSK_BK_RA, 2.0, 3.0);
    MSK_putobjsense(task, MSK_OBJECTIVE_SENSE_MINIMIZE);
    MSK_optimizetrm(task, &trmcode);
    MSK_getxx(task, MSK_SOL_ITR, &xx);
    MSK_deletetask(&task);

    cout << xx << endl;
    return 0;
}