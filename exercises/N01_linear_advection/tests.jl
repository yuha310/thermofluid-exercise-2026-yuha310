# N01のテスト枠。必須テストと自作テストの両方を受講生が実装します。
# 各TODOで入力と独立した期待値を選び、配列全体・境界・安定性を確認します。

using Test

if !isdefined(Main, :N01LinearAdvection)
    include(joinpath(@__DIR__, "run.jl"))
end

@testset "N01 必須テスト" begin
    # TODO(必須): 座標、base、plateau、区間端を自分で選び、rectangular_initial_conditionが返す配列全体を手計算した期待値と比較する。
    x = [0.0, 0.5, 1.0, 1.5]
    actual = N01LinearAdvection.rectangular_initial_condition(
        x;
        base=1.0,
        plateau=3.0,
        plateau_start=0.5,
        plateau_end=1.0,
    )
    expected = [1.0, 3.0, 3.0, 1.0]

    @test actual == expected

    # TODO(必須): 小さなu_old、移流速度、時間刻み、格子幅を選び、upwind_step!後のu_new配列全体を手計算した期待値と比較する。
    u_old = [1.0, 3.0, 3.0, 1.0]
    u_new = similar(u_old)
    #similar(u_old)はu_oldと同じ長さ・型の配列を作る．

    c = 1.0
    dt = 0.1
    dx = 0.2
    N01LinearAdvection.upwind_step!(u_new, u_old, c, dt, dx)

    expected = [1.0, 2.0, 3.0, 1.0]
    #upwind_step!の中では内側の点だけ計算している．

    @test u_new == expected

    # TODO(必須): 同じ入力でcentered_step!後のu_new配列全体を手計算した期待値と比較する。風上差分との違いが現れる入力を選ぶ。
    u_old = [1.0, 3.0, 3.0, 1.0]
    u_new = similar(u_old)
    #similar(u_old)はu_oldと同じ長さ・型の配列を作る．

    c = 1.0
    dt = 0.1
    dx = 0.2
    N01LinearAdvection.centered_step!(u_new, u_old, c, dt, dx)

    expected = [1.0, 2.5, 3.5, 1.0]
    #centered_step!の中では内側の点だけ計算している．

    @test u_new == expected

    # TODO(必須): apply_boundary!が左端と右端を課題の境界条件どおりに書き換えることを、配列全体の期待値で確かめる。
    u = [9.0, 2.5, 3.5, 7.0]
    N01LinearAdvection.apply_boundary!(u; left_value=1.0)

    expected = [1.0, 2.5, 3.5, 3.5]
    @test u == expected

    # TODO(必須): simulateで安定な風上差分と不安定な中心差分を同じ条件で計算し、最終値の範囲または振幅から両者の違いを確かめる。条件と判定基準は自分で書く。
    upwind = N01LinearAdvection.simulate(
        scheme=:upwind; nx=81, c=1.0, cfl=0.5, t_final=0.5
    )
    centered = N01LinearAdvection.simulate(
        scheme=:centered; nx=81, c=1.0, cfl=0.5, t_final=0.5
    )

    @test upwind.minimum >= 1.0 - 1e-12
    @test upwind.maximum <= 2.0 + 1e-12
    @test centered.minimum < 1.0 - 1e-8 || centered.maximum > 2.0 + 1e-8
end

@testset "N01 自作テスト" begin
    # TODO(自作): 必須とは異なる初期条件、CFL、格子数、またはAPIの性質を一つ選び、期待する結果を自分で書く。PNG、TOML、ファイルサイズは対象にしない。
    x = [0.0, 0.25, 0.5, 0.75, 1.0]
    original_x = copy(x)

    actual = N01LinearAdvection.rectangular_initial_condition(
        x;
        base=1.0,
        plateau=4.0,
        plateau_start=0.25,
        plateau_end=0.5,
    )

    @test actual == [1.0, 4.0, 4.0, 1.0, 1.0]
    @test x == original_x
    @test actual !== x
    #!==は同じオブジェクトではないという意味．
end
