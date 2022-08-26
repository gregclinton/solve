/*
wget https://download.mosek.com/stable/10.0.18/mosektoolslinux64x86.tar.bz2
tar -xf mosektoolslinux64x86.tar.bz2
rm -f *.bz2
mkdir /usr/local/include/mosek
cp mosek/10.0/tools/platform/linux64x86/h/* /usr/local/include/mosek/.
cp mosek/10.0/tools/platform/linux64x86/bin/libmosek* /usr/local/lib/.
cp mosek/10.0/tools/platform/linux64x86/bin/libtbb* /usr/local/lib/.
rm -rf mosek
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"


g++ -std=c++20 -o test mosek.cpp -lmosek64
*/

#include <iostream>
#include <mosek/mosek.h>
#include <cblas.h>

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