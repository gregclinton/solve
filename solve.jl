module solve

using Random

Random.seed!(1234)
n = 100
m = 200
A = randn(Float32, (m, n))

function f(x)
    sum(ones(Float32, m) - A * x)
end

function test()
    x0 = zeros(Float32, n)
    println(f(x0))
end

test()
end