module solve
using Random, LinearAlgebra

function backtrack(f, f̃, f′, α = 0.01, β = 0.5)
    t = 1.0

    while f̃(t) > f + α * t * f′
        t *= β
    end

    t
end

Δxₙₜ(∇f, ∇²f) = -(∇²f \ ∇f)

function newton(gen, x₀, maxiters = 1000, ε = 1e-8)
    x = x₀

    for iters in 1 : maxiters
        f, ∇f, ∇²f, f̃, Δx = gen(x)
        f′ = ∇f'Δx

        if abs(f′) < ε
            break
        end

        x += backtrack(f, f̃, f′) * Δx
    end

    x
end

function test()
    Random.seed!(1234)
    A = randn(Float32, (200, 100))

    function gen(x)

        function f(x)
            Ax = A * x

            if maximum(abs.(x)) < 1
                return maximum(Ax) < 1 ? -sum(log.(1 .- Ax)) - sum(log.(1 .+ x)) - sum(log.(1 .- x)) : Inf
            end

            Inf
        end

        d = 1 ./ (1 .- A * x)
        ∇f = A'd - 1 ./ (1 .+ x) + 1 ./ (1 .- x) 
        ∇²f = A'Diagonal(d .^ 2)A + Diagonal(1 ./ (1 .+ x) .^ 2 + 1 ./ (1 .- x) .^ 2)
        Δx = Δxₙₜ(∇f, ∇²f) 
        f̃(t) = f(x + t * Δx)
        f(x), ∇f, ∇²f, f̃, Δx
    end

    println(newton(gen, zeros(Float32, size(A)[2]))[1])
end

test()
end