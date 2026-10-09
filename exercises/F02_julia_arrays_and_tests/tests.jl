using Test

if !isdefined(Main, :F02JuliaArraysAndTests)
    include(joinpath(@__DIR__, "run.jl"))
end

@testset "F02 必須テスト（配布済み）" begin
    values = [5.0, 7.0, 12.0]
    original = copy(values)
    anomalies = F02JuliaArraysAndTests.temperature_anomaly(values)

    # この具体例の平均と偏差は厳密に表せる値なので、==で比較する。
    @test F02JuliaArraysAndTests.mean_temperature(values) == 8.0
    @test anomalies == [-3.0, -1.0, 4.0]

    # originalは呼び出し前にcopyした値。単なる代入では変更を見逃す。
    @test values == original
    @test_throws ArgumentError F02JuliaArraysAndTests.mean_temperature(Float64[])
end

@testset "F02 自作テスト" begin
    values = [7.0, 13.0, 4.0]
    anomalies = F02JuliaArraysAndTests.temperature_anomaly(values)

    @test sum(anomalies) ≈ 0.0
end
