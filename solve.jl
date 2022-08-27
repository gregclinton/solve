module solve
using Random, LinearAlgebra

function backtrack(f, f′, x, Δx, α = 0.01, β = 0.5)
    val = f(x)
    t = 1.0

    while f(x + t * Δx) > val + α * t * f′
        t *= β
    end

    t
end

function newton(f, ∇f, ∇²f, x₀, maxiters = 1000, ε = 1e-8)
    x = x₀

    for iters in 1 : maxiters
        g = ∇f(x);
        Δx = -(∇²f(x) \ g)
        f′ = g'Δx

        if abs(f′) < ε
            break
        end

        x += backtrack(f, f′, x, Δx) * Δx
    end

    x
end

function test()
    Random.seed!(1234)
    A = randn(Float32, (200, 100))

    function f(x)
        if maximum(abs.(x)) < 1
            Ax = A * x
            return maximum(Ax) < 1 ? -sum(log.(1 .- Ax)) - sum(log.(1 .+ x)) - sum(log.(1 .- x)) : Inf
        end
        Inf
    end

    d(x) = 1 ./ (1 .- A * x)
    ∇f(x) = A' * d(x) - 1 ./ (1 .+ x) + 1 ./ (1 .- x)
    ∇²f(x) = A' * Diagonal(d(x) .^ 2) * A + Diagonal(1 ./ (1 .+ x) .^ 2 + 1 ./ (1 .- x) .^ 2)
    println(newton(f, ∇f, ∇²f, zeros(Float32, size(A)[2]))[1])
end

test()
end