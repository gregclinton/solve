# https://libraries.io/julia/SCS
# https://github.com/jump-dev/SCS.jl/blob/master/test/test_problems.jl

using SCS

A =
[
    #----A-----
    13 11 12 22

    #----G-----
    -1 -1 -3 -4
    -4 -2 -2 -9
    -8 -2  0 -5
     0 -6 -7 -4
]

  # -b-  -------h---------
b = [58, -8, -17, -15, -17]
c = [59, 39, 38, 85]

#   minimize   c'x
# subject to   Gx ≤ h
#              Ax = b

b *= 1.0
c *= 1.0
m, n = size(A)
f = 1
l = 4
ep = 0
ed = 0
q = Int[]
s = Int[]
p = Float64[]

sol = SCS_solve(SCS.DirectSolver, m, n, A, b, c, f, l, q, s, ep, ed, p)
println(SCS.raw_status(sol.info))