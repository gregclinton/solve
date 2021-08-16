wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.0-linux-x86_64.tar.gz
tar -x -f julia-1.6.0-linux-x86_64.tar.gz -C /usr/local --strip-components 1
julia -e 'using Pkg; Pkg.add(["IJulia", "Plots", "JuMP", "GLPK", "SCS"])'