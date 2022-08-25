module solve
using Random, LinearAlgebra

function test()
    n = 100

    Random.seed!(1234)
    A = randn(Float32, (200, n))
    x = zeros(Float32, n)

    for _ in 1 : 1000 
        val = -sum(log.(1 .- A * x)) - sum(log.(1 .- x .* x))
        grad = A' * (1 ./ (1 .- A * x)) - 1 ./ (1 .+ x) + 1 ./ (1 .- x)
        if norm(grad) < 1e-3
            break
        end
        v = -grad
    end
end

test()
end