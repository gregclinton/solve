using JuMP, SCS

c = [59, 39, 38, 85]
G =
[
    -1 -1 -3 -4
    -4 -2 -2 -9
    -8 -2  0 -5
     0 -6 -7 -4
]
h = [-8, -17, -15, -17]
b = [58]
A =
[
    13 11 12 22
]

model = Model(SCS.Optimizer)
@variable(model, x[1 : length(c)])
@objective(model, Min, c' * x)
@constraint(model, G * x .≤ h)
@constraint(model, A * x .== b)
optimize!(model)
println(objective_value(model))