#
# # Example with VAR as in Sims (1980) IRF and FEVD
#
# include("src/VARmodels.jl")
import Pkg;
Pkg.activate(".");

using VARmodels
using CSV, DataFrames, Dates
using LinearAlgebra
using TimeSeries
using FFTW

# _ using revise to reload changes in functions when developing pkg
using Revise
import VARmodels

data = CSV.read("simsData.txt", DataFrame; missingstring="NA")

d = DateTime.(collect(Date(1959, 1, 1):Month(3):Date(2014, 7, 1)))
names_data = names(data)[2:end]

data_var = TimeArray(d, Matrix(data[45:end, 2:end]) .* 1.0, names_data)
DataFrame(data_var) |> describe

s = varEstimate(data_var["cpi", "imports", "unemp"], 3, "Const")
typeof(s)

horz = 100
Phi(s, horz)
Psi(s, horz)

fevd(s, horz)
genFEVD(s, horz)
fftFEVD(s, horz; range = (3,10))
gf = fftGenFEVD(s, horz; range = (3,10))

[fevd(s, h) for h in 1:horz]
[genFEVD(s, h) for h in 1:horz]


# _ new stuff
fr = fftPers(s, 100; range = (1,horz))


using Plots

plot(fr[1,1,:])

plot(gf[1,1,:])
