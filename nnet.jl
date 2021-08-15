# https://github.com/FluxML/model-zoo/blob/master/vision/mlp_mnist/mlp_mnist.jl
# https://towardsdatascience.com/deep-learning-with-julia-flux-jl-story-7544c99728ca

module nnet

using Flux
using Flux.Data: DataLoader
using Flux: onehotbatch, onecold
using Flux.Losses: logitcrossentropy
using CUDA
using MLDatasets

function test()
    batchsize = 64
    device = cpu
    ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"
    xtrain, ytrain = MLDatasets.MNIST.traindata(Float32)
    xtrain = Flux.flatten(xtrain)
    ytrain = onehotbatch(ytrain, 0:9)
    loader = DataLoader((xtrain, ytrain), batchsize = batchsize)

    model = Chain(
        Dense(784, 100, relu),
        Dense(100, 10)) |> device
    opt = Descent(0.1)

    for epoch in 1:10
        for (x, y) in loader
            x, y = device(x), device(y)
            gs = gradient(() -> logitcrossentropy(model(x), y), Flux.params(model))
            Flux.Optimise.update!(opt, ps, gs)
        end
        print('.')
    end

    println()

    accuracy = 0
    count = 0
    for (x, y) in loader
        x, y = device(x), device(y)
        accuracy += sum(onecold(cpu(model(x))) .== onecold(cpu(y)))
        count += size(x, 2)
    end

    println(accuracy / count)
end

end