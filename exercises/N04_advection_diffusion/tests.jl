# 必須テストは提供済みの期待値で確認します。末尾の自作テストだけを受講生が編集します。
# 入力の準備 → 独立した期待値との比較 → 入力保持・不正入力の確認の順に読みます。

using Test
if !isdefined(Main, :N04AdvectionDiffusion)
    include(joinpath(@__DIR__, "run.jl"))
end
import .N04AdvectionDiffusion
const N04 = N04AdvectionDiffusion
N04.validate_model(N04.SELECTED_MODEL)
@testset "N04 必須テスト" begin
    model = N04.SELECTED_MODEL
    @testset "非対称1ステップ・周期端・旧配列不変" begin
        old = [1., 2., 4., 3.]
        saved = copy(old)
        new = similar(old)
        expected = model == :linear ? [1.26, 1.92, 3.74, 3.08] : [1.46, 1.87, 3.34, 3.33]
        @test N04.advection_diffusion_step!(new, old, 0.1, 1., 0.2) === new
        @test new ≈ expected atol = 1e-14
        @test old == saved
    end
    @testset "定数場と周期積分" begin
        old = fill(1.7, 5)
        new = similar(old)
        N04.advection_diffusion_step!(new, old, 0.1, 1., 0.2)
        @test new ≈ old
        @test N04.conserved_integral([1., 2., 4., 3.], 0.5) == 5.
    end
    @testset "移流・拡散をゼロにした極限" begin
        old = [1., 2., 4., 3.]
        new = similar(old)
        N04.advection_diffusion_step!(new, old, 0.1, 1., 0.2; advection=false)
        @test new ≈ [1.06, 2.02, 3.94, 2.98]
        N04.advection_diffusion_step!(new, old, 0.1, 1., 0.)
        @test new ≈ (model == :linear ? [1.2, 1.9, 3.8, 3.1] : [1.4, 1.85, 3.4, 3.35])
    end
    @testset "合成刻み・最終時刻・標準安定性" begin
        @test N04.stable_timestep(2., 0.5, 0.1) ≈ 1 / 6
        r = N04.simulate()
        @test r.steps * r.dt ≈ r.t_final == 1.
        @test r.max_stability_number <= 0.8 + 1e-12
        @test all(isfinite, r.u) && 1 - 1e-12 <= r.minimum <= r.maximum <= 2 + 1e-12
    end
end
@testset "N04 自作テスト" begin
    # TODO(自作): 非対称な非定数配列を複数ステップ進め、周期積分の保存を確認する。
    initial = [0.4, 1.3, 0.7, 1.8, 0.9, 1.1, 1.5, 0.6]
    # 初期積分を独立に計算し、点数・ステップ数・値の大きさから許容誤差を説明する。
    old = copy(initial)
    new = similar(old)

    dx = 2 / length(initial)
    initial_integral = dx * sum(initial)

    for _ in 1:20
        N04.advection_diffusion_step!(
            new, old, 0.005, dx, 0.1;
            model=N04.SELECTED_MODEL,
            speed=1.0,
        )
        old, new = new, old
    end

    final_integral = dx * sum(old)

    # TODO(N04): 複数ステップ保存
    @test isapprox(final_integral, initial_integral; atol=1e-12, rtol=1e-12)

    # TODO(自作): 選択モデルの解析解と40・80・160点の誤差・観測次数を確認する。
    # 誤差の指標、同じ最終時刻、0.8〜1.2の次数範囲、検出できない誤りも説明する。
    errors = Float64[]
    for nx in (40, 80, 160)
        result = N04.simulate(;
            model=N04.SELECTED_MODEL,
            nx,
            diffusivity=0.1,
            speed=1.0,
            t_final=1.0,
            initial=:mode,
        )

        exact = N04.analytic_solution(
            result.x,
            result.t_final;
            model=N04.SELECTED_MODEL,
            diffusivity=0.1,
            speed=1.0,
        )

        # 各格子点の誤差を二乗平均平方根（RMS誤差）でまとめる。
        error = sqrt(sum(abs2, result.u .- exact) / length(result.u))
        push!(errors, error)
    end

    # 格子幅を半分にしたときの観測次数を計算する。
    order_40_80 = log2(errors[1] / errors[2])
    order_80_160 = log2(errors[2] / errors[3])

    # TODO(N04): 格子収束
    # 誤差が計算できていて、正の有限値であることを確認する。
    @test all(e -> isfinite(e) && e > 0, errors)

    # 課題で指定された範囲に入ることを確認する。
    @test 0.8 <= order_40_80 <= 1.2
    @test 0.8 <= order_80_160 <= 1.2
end
