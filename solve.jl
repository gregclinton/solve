module solve
using Random

function test()
    n = 100

    Random.seed!(1234)
    A = randn(Float32, (200, n))
    x = zeros(Float32, n)

    for _ in 1 : 1000 
        val = -sum(log.(1 .- A * x)) - sum(log.(1 .- x .* x))
        grad = 1 ./ (1 .- A * x)
    end
end

test()
end