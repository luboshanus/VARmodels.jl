import TimeSeries: TimeArray

function varEstimate(data::TimeArray{Float64}, lags::Int, typ::AbstractString)
    t = varEstimate(values(data), lags, typ)
    t.seriesNames = string.(colnames(data))
    return t
end
