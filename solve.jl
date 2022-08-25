module solve

n = 100

let
    global f, g
    using Random

    Random.seed!(1234)
    A = randn(Float32, (200, n))

    function f(x)
        -sum(log.(1 .- A * x)) - sum(log.(1 .- x .* x))
    end

    function g(x)
        3
    end
end

function test()
    x0 = zeros(Float32, n)
    println(f(x0), ' ', g(x0))
end

test()
end