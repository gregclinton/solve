module solve
using Random, LinearAlgebra

function test()
    Random.seed!(1234)
    x = zeros(Float32, 100)
    A = randn(Float32, (200, length(x)))

    α = 0.01
    β = 0.5
    for _ in 1 : 1000 
        print('.')
        val = -sum(log.(1 .- A * x)) - sum(log.(1 .- x .* x))
        grad = A' * (1 ./ (1 .- A * x)) - 1 ./ (1 .+ x) + 1 ./ (1 .- x)
        if norm(grad) < 1e-3
            print('!')
            break
        end
        v = -grad
        fprime = grad' * v
        t = 1
        while maximum(A * (x + t * v)) ≥ 1 || maximum(abs.(x + t * v)) ≥ 1
            t *= β
        end
        while -sum(log.(1 .- A * (x + t * v))) - sum(log.(1 .- (x + t * v) .* (x + t * v))) > val + α * t * fprime
            t *= β
        end
        x += t * v
    end
end

test()
end