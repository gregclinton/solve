module solve
using Random, LinearAlgebra

function newton(f, ∇f, ∇²f, x₀)
    for iters in 1 : 10000
        x = x₀
        val = f(x)
        g = ∇f(x);
        Δxₙₜ = -(∇²f(x) \ g)
        f′ = g'Δxₙₜ

        if abs(f′) < 1e-8
            println(iters)
            break
        end

        t = 1.0
        α = 0.01
        β = 0.5

        while f(x + t * Δxₙₜ) > val + α * t * f′
            t *= β
        end

        x += t * Δxₙₜ
    end
end

function test()
    Random.seed!(1234)
    A = randn(Float32, (200, 100))
    f(x) = (maximum(A * (x)) < 1 && maximum(abs.(x)) < 1) ? -sum(log.(1 .- A * x)) - sum(log.(1 .+ x)) - sum(log.(1 .- x)) : Inf
    d(x) = 1 ./ (1 .- A * x)
    ∇f(x) = A' * d(x) - 1 ./ (1 .+ x) + 1 ./ (1 .- x)
    ∇²f(x) = A' * Diagonal(d(x) .^ 2) * A + Diagonal(1 ./ (1 .+ x) .^ 2 + 1 ./ (1 .- x) .^ 2)
    newton(f, ∇f, ∇²f, zeros(Float32, size(A)[2]))
end

test()
end