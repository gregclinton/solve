module solve

using Random

function test()
    Random.seed!(1234)

    n = 50
    m = 100
    A = randn(Float32, (m, n))
    b = rand(Float32, m)

    println(sum(b), ' ', sum(A))
end

test()
end