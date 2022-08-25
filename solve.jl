module solve

using Random

Random.seed!(1234)
n = 100
m = 200
A = randn(Float32, (m, n))

function f(x)
    -sum(log.(ones(Float32, m) - A * x)) - sum(log.(ones(Float32, n) - x .* x))
end

function test()
    println(f(zeros(Float32, n)))
end

test()
end