# https://jump.dev/MathOptInterface.jl/dev/

using MathOptInterface
const MOI = MathOptInterface

using GLPK
optimizer = GLPK.Optimizer()

c = [1.0, 2.0, 3.0]
x = MOI.add_variables(optimizer, length(c))