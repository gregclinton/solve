module solve

using Random

Random.seed!(1234)
n = 50
m = 100
A = randn(Float32, (m, n))
b = rand(Float32, m)

function f(x)
    sum(A * x)
end

function test()
    x0 = rand(Float32, n)
    println(f(x0))
end

test()
end