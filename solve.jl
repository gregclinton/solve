module solve

n = 100

let
    global f, g
    using Random

    Random.seed!(1234)
    A = randn(Float32, (200, n))

    f(x) = -sum(log.(1 .- A * x)) - sum(log.(1 .- x .* x))
    g(x) = -sum(1 ./ (1 .- A * x))
end

function test()
    x0 = zeros(Float32, n)
    println(f(x0), ' ', g(x0))
end

test()
end