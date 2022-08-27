module solve
using Random, LinearAlgebra

function newton(f, fable, grad, hess, x)
    α = 0.01
    β = 0.5

    for iters in 1 : 10000
        val = f(x)
        H = hess(x)
        g = grad(x);
        v = -(H \ g)
        fprime = g' * v

        if abs(fprime) < 1e-8
            println(iters)
            break
        end

        t = 1

        while !fable(x + t * v) || f(x + t * v) > val + α * t * fprime
            t *= β
        end

        x += t * v
    end
end

function test()
    Random.seed!(1234)
    x = zeros(Float32, 100)
    A = randn(Float32, (200, length(x)))
    f(x) = -sum(log.(1 .- A * x)) - sum(log.(1 .+ x)) - sum(log.(1 .- x))
    fable(x) = maximum(A * (x)) < 1 && maximum(abs.(x)) < 1
    d(x) = 1 ./ (1 .- A * x)
    grad(x) = A' * d(x) - 1 ./ (1 .+ x) + 1 ./ (1 .- x)
    hess(x) = A' * Diagonal(d(x) .^ 2) * A + Diagonal(1 ./ (1 .+ x) .^ 2 + 1 ./ (1 .- x) .^ 2)
newton(f, fable, grad, hess, x)
end

test()
end