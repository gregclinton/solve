wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz
tar -x -f julia-1.7.2-linux-x86_64.tar.gz -C /usr/local --strip-components 1
julia -e 'using Pkg; Pkg.add(["IJulia", "Plots", "JuMP", "GLPK", "SCS"])'

wget https://download.mosek.com/stable/10.0.18/mosektoolslinux64x86.tar.bz2
tar -xf mosektoolslinux64x86.tar.bz2
rm -f *.bz2
mkdir /usr/local/include/mosek
cp mosek/10.0/tools/platform/linux64x86/h/* /usr/local/include/mosek/.
cp mosek/10.0/tools/platform/linux64x86/bin/libmosek* /usr/local/lib/.
cp mosek/10.0/tools/platform/linux64x86/bin/libtbb* /usr/local/lib/.
rm -rf mosek