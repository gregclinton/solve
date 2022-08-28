module solve
using Random, LinearAlgebra

function backtrack(f̃, f′, α = 0.01, β = 0.5)
    f = f̃(0)
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
        f̃, ∇f, Δx = gen(x)
        f′ = ∇f'Δx

        if abs(f′) < ε
            break
        end

        x += backtrack(f̃, f′) * Δx
    end

    x
end

function test()
    Random.seed!(1234)
    A = randn(Float32, (200, 100))

    function gen(x)
        Ax = A * x
        d = 1 ./ (1 .- Ax)
        ∇f = A'd - 1 ./ (1 .+ x) + 1 ./ (1 .- x) 
        ∇²f = A'Diagonal(d .^ 2)A + Diagonal(1 ./ (1 .+ x) .^ 2 + 1 ./ (1 .- x) .^ 2)
        Δx = Δxₙₜ(∇f, ∇²f)
        AΔx = A * Δx

        function f̃(t)
            z = x + t * Δx 
            Z = Ax + t * AΔx

            maximum(abs.(z)) < 1 && maximum(Z) < 1 ? -sum(log.(1 .- Z)) - sum(log.(1 .+ z)) - sum(log.(1 .- z)) : Inf
        end    

        f̃, ∇f, Δx
    end

    println(newton(gen, zeros(Float32, size(A)[2]))[1])
end

test()
end