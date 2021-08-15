using Convex, SCS

c = [59, 39, 38, 85]
G =
[
    -1 -1 -3 -4
    -4 -2 -2 -9
    -8 -2  0 -5
     0 -6 -7 -4
]
h = [-8, -17, -15, -17]
A =
[
    13 11 12 22
]
b = 58

x = Variable(length(c))
problem = minimize(c' * x, [G * x ≤ h, A * x == b])
solve!(problem, () -> SCS.Optimizer(verbose = true))
println(problem.optval)