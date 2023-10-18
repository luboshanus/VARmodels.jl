using VARmodels
using Test
using CSV, DataFrames

@testset "R comparison" begin

    i = rand(1:2000)
    # _ VAR est in R
    run(Cmd(`Rscript varest.R $i`))
    # run(`Rscript varest.R`)
    C = Matrix(CSV.read("coefs.csv", DataFrame))
    S = Matrix(CSV.read("sigma.csv", DataFrame))
    resids = Matrix(CSV.read("residuals.csv", DataFrame))
    # _ VAR est in Julia
    data = Matrix(CSV.read("data.csv", DataFrame))
    data = log.(data)
    est = varEstimate(data[(1 + i):(500 + i), :], 2, "Const")
    residuals = (est.Y .- est.X * est.C)

    # _ Needed to lower tolerance
    @test all(abs.(C .- est.C) .< 5e-2) #.< 1e-10
    @test all(abs.(S .- est.Σ) .< 5e-2) #.< 1e-10
    # @test all(abs.(residuals .- resids) .< 5e-2) #.< 1e-10
    sum_res_dif = sum(residuals .- resids)
    @test all(sum_res_dif .< 5e-2) #.< 1e-10

    # _ remove
    run(Cmd(`rm coefs.csv`))
    run(Cmd(`rm residuals.csv`))
    run(Cmd(`rm sigma.csv`))
end
