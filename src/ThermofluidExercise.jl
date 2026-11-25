# N05の共通API。周期添字 → 流束 → バッファ検証 → 刻み調整 → 既習課題の入口の順に読みます。
# TODOを実装して既存の入力・返り値の契約を保ち、N06以降でも再利用します。

module ThermofluidExercise

"""
    periodic_left_index(i, n)

1始まりの周期配列で左隣の添字を求める。

# 引数

- `i`: 1始まりの現在の添字。
- `n`: 配列の点数。

i,nはBoolを除く整数、n>=1、1<=i<=n。

# 返り値

実装後は 1からnまでの整数。

# 受講生のToDo

N02の周期左隣を共通化し、先頭から左へ越えたときは末尾の添字を返す。1点の場合も扱う。
この関数では引数条件の検証も学生が実装する。N05の共通APIと既習N02を参照する。配布状態では未実装エラーで停止する。
"""
function periodic_left_index(i::Integer, n::Integer)
    # TODO(N05): 周期配列の左隣添字を返す。
    (i isa Bool || n isa Bool || n < 1 || !(1 <= i <= n)) &&
        throw(ArgumentError("添字は1 <= i <= n、点数はn >= 1の整数です（Bool不可）"))
    # TODO(N02): 先頭の左隣が末尾になるようにする。
    return i == 1 ? n : i - 1
end

"""
    periodic_right_index(i, n)

1始まりの周期配列で右隣の添字を求める。

# 引数

- `i`: 1始まりの現在の添字。
- `n`: 配列の点数。

i,nはBoolを除く整数、n>=1、1<=i<=n。

# 返り値

実装後は 1からnまでの整数。

# 受講生のToDo

周期右隣の添字を求め、末尾から右へ越えたときは先頭へ戻す。1点の場合も扱う。
左隣APIと同じ引数条件の検証も学生が実装する。N04の周期左右隣接とN05の共通APIを参照する。配布状態では未実装エラーで停止する。
"""
function periodic_right_index(i::Integer, n::Integer)
    # TODO(N05): 周期配列の右隣添字を返す。
    (i isa Bool || n isa Bool || n < 1 || !(1 <= i <= n)) &&
        throw(ArgumentError("添字は1 <= i <= n、点数はn >= 1の整数です（Bool不可）"))
    # TODO(N02): 末尾の右隣が先頭になるようにする。
    return i == n ? 1 : i + 1
end

"""
    linear_flux(u, speed)

有限な実数の線形流束を評価する。

# 引数

- `u`: 有限な実数の場の値。
- `speed`: 有限な実数の移流速度。

u,speedの有限実数を検証する。

# 返り値

実装後は スカラーの線形流束。

# 受講生のToDo

1点の場と速度を有限実数として検証し、N01で使った線形流束をスカラーで返す。配列の更新は呼出し側の責務である。
入力検証も学生の実装範囲。N05の共通APIを参照する。配布状態では未実装エラーで停止する。
"""
function linear_flux(u::Number, speed::Number)
    # TODO(N05): 有限実数の入力を検証し、線形流束を返す。
    all(x -> x isa Real && !(x isa Bool) && isfinite(x), (u, speed)) ||
        throw(ArgumentError("入力は有限な実数です（Bool不可）"))
    flux = u * speed
    isfinite(flux) || throw(ArgumentError("線形流束が表現範囲外です"))
    return flux
end

"""
    burgers_flux(u)

有限な実数のBurgers流束を評価する。

# 引数

- `u`: 有限な実数の場の値。

負値も受け付け、有限実数を検証する。

# 返り値

実装後は スカラーのBurgers流束。

# 受講生のToDo

1点の場を有限実数として検証し、既習N02のBurgers流束をスカラーで返す。負値も流束の入力として扱う。
入力検証も学生の実装範囲。配布状態では未実装エラーで停止する。
"""
function burgers_flux(u::Number)
    # TODO(N05): 有限実数の入力を検証し、Burgers流束を返す。
    u isa Real && !(u isa Bool) && isfinite(u) ||
        throw(ArgumentError("入力は有限な実数です（Bool不可）"))
    flux = u^2 / 2
    isfinite(flux) || throw(ArgumentError("Burgers流束が表現範囲外です"))
    return flux
end

"""
    validate_buffers(u_new, u_old)

新旧バッファが安全に更新できる入力か検証する。

# 引数

- `u_new`: 更新結果を書き込む配列。旧配列と重ならない独立したバッファ。
- `u_old`: 更新前の値を読む配列。更新中は変更しない。

各軸3点以上・1始まりの同形状の浮動小数配列。非aliasとは同じ記憶領域を共有しないこと。
この条件と有限な旧値を検証する。不正入力は実装後の検証でArgumentError。

# 返り値

実装後は 成功時はnothing。

# 受講生のToDo

新旧配列の型・形状・軸・点数・有限旧値と、同じ記憶領域を共有しないことを検査する。出力の初期値の有限性は要求しない。
全点で同じ旧場を読むため、入力を書き換えず、不正なら更新前にArgumentErrorを投げる検証APIを実装する。
N01〜N04のバッファ検証とN05の共通APIを参照する。配布状態では未実装エラーで停止する。
"""
function validate_buffers(u_new::AbstractArray, u_old::AbstractArray)
    # TODO(N05): 新旧配列の形状・型・非alias・旧値の有限性を検証する。
    eltype(u_new) <: AbstractFloat && eltype(u_old) <: AbstractFloat ||
        throw(ArgumentError("新旧配列は浮動小数の配列です"))

    ndims(u_old) >= 1 ||
        throw(ArgumentError("配列は1次元以上です"))

    axes(u_new) == axes(u_old) ||
        throw(ArgumentError("新旧配列の軸が一致しません"))

    all(length(axis) >= 3 for axis in axes(u_old)) ||
        throw(ArgumentError("各軸は3点以上必要です"))

    Base.require_one_based_indexing(u_new, u_old)

    Base.mightalias(u_new, u_old) &&
        throw(ArgumentError("新旧配列は同じ記憶領域を共有できません"))

    all(isfinite, u_old) ||
        throw(ArgumentError("旧配列は有限値にしてください"))

    return nothing
end


"""
    fit_timestep(dt_max, t_final)

刻み上限を守り、最終時刻へ到達する刻みとステップ数を決める。

# 引数

- `dt_max`: 有限な正の刻み上限。
- `t_final`: 計算の最終時刻。

dt_max,t_finalは有限な正値。表現不能な刻みやステップ数も拒否する。

# 返り値

実装後は `(;steps, dt)` のNamedTuple。stepsは正整数、dtは有限正値でdt_max以下、steps回でt_finalへ到達する。

# 受講生のToDo

最終時刻へ等間隔で到達し、刻みがdt_max以下になる正整数stepsと正のdtを返す。
有限正の入力と、ステップ数・刻みの表現可能性の検証も実装する。N01〜N04の時間刻み調整とN05の共通APIを参照する。配布状態では未実装エラーで停止する。
"""
function fit_timestep(dt_max::Number, t_final::Number)
    # TODO(N05): 安定上限を超えない刻みとステップ数を最終時刻から返す。
    all(x -> x isa Real && !(x isa Bool) && isfinite(x) && x > 0,
        (dt_max, t_final)) ||
        throw(ArgumentError("dt_maxとt_finalは有限な正の実数です"))

    count = t_final / dt_max
    isfinite(count) && count < typemax(Int) - 1 ||
        throw(ArgumentError("ステップ数が表現範囲を超えています"))

    steps = max(1, ceil(Int, count))
    dt = t_final / steps
    isfinite(dt) && dt > 0 && dt <= dt_max ||
        throw(ArgumentError("刻みdtが表現範囲外、または上限を超えています"))

    return (; steps, dt)
end

module N01

"""
    upwind_step!(args...; kwargs...)

N01の風上更新を共通APIへ移す。

# 引数

- `args`: 新旧ベクトル、有限正の移流速度、時間刻み、格子幅の順。新配列に書込み、旧配列を保持する。
- `kwargs`: キーワード引数はない。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は更新した新配列。内部点を更新し、境界値は呼出し側で適用する。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""

import ..ThermofluidExercise as Common

function upwind_step!(args...; kwargs...)
    # TODO(N05): 既習のN01.upwind_step!を共通APIを使う処理へ移し、既存の契約を保つ。
    isempty(kwargs) ||
        throw(ArgumentError("キーワード引数はありません"))
    length(args) == 5 ||
        throw(ArgumentError("新旧配列、c、dt、dxの5引数が必要です"))

    u_new, u_old, c, dt, dx = args

    u_new isa AbstractArray && u_old isa AbstractArray ||
        throw(ArgumentError("新旧は配列です"))
    Common.validate_buffers(u_new, u_old)

    all(x -> x isa Real && !(x isa Bool) && isfinite(x) && x > 0, (c, dt, dx)) ||
        throw(ArgumentError("c、dt、dxは有限な正の実数です"))

    courant = c * dt / dx
    isfinite(courant) && courant > 0 ||
        throw(ArgumentError("courantが表現範囲外です"))

    copyto!(u_new, u_old)
    for i in 2:(length(u_old)-1)
        u_new[i] = u_old[i] - courant * (u_old[i] - u_old[i-1])
    end

    return u_new
end

"""
    centered_step!(args...; kwargs...)

N01の中心差分更新を共通APIへ移す。

# 引数

- `args`: 新旧ベクトル、有限正の移流速度、時間刻み、格子幅の順。新配列に書込み、旧配列を保持する。
- `kwargs`: キーワード引数はない。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は更新した新配列。内部点を更新し、境界値は呼出し側で適用する。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""
function centered_step!(args...; kwargs...)
    # TODO(N05): 既習のN01.centered_step!を共通APIを使う処理へ移し、既存の契約を保つ。
    isempty(kwargs) ||
        throw(ArgumentError("キーワード引数はありません"))
    length(args) == 5 ||
        throw(ArgumentError("新旧配列、c、dt、dxの5引数が必要です"))

    u_new, u_old, c, dt, dx = args

    u_new isa AbstractArray && u_old isa AbstractArray ||
        throw(ArgumentError("新旧は配列です"))
    Common.validate_buffers(u_new, u_old)

    all(x -> x isa Real && !(x isa Bool) && isfinite(x) && x > 0, (c, dt, dx)) ||
        throw(ArgumentError("c、dt、dxは有限な正の実数です"))

    courant = c * dt / dx
    isfinite(courant) && courant > 0 ||
        throw(ArgumentError("courantが表現範囲外です"))

    copyto!(u_new, u_old)
    for i in 2:(length(u_old)-1)
        u_new[i] = u_old[i] - courant/2 * (u_old[i+1] - u_old[i-1])
    end

    return u_new
end

"""
    apply_boundary!(args...; kwargs...)

N01の左流入・右流出境界を共通APIへ移す。

# 引数

- `args`: 端点を書き換えるベクトル。
- `kwargs`: `left_value` は有限な左境界値（既定1.0）。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は境界を適用した入力ベクトル。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""
function apply_boundary!(args...; kwargs...)
    # TODO(N05): 既習のN01.apply_boundary!を共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 1 ||
        throw(ArgumentError("境界を適用するベクトルを1つ指定してください"))
    all(k -> k === :left_value, keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはleft_valueだけです"))

    u = args[1]
    left_value = haskey(kwargs, :left_value) ? kwargs[:left_value] : 1.0

    u isa AbstractVector{<:Real} ||
        throw(ArgumentError("uは実数のベクトルです"))
    left_value isa Real && isfinite(left_value) ||
        throw(ArgumentError("left_valueは有限な実数です"))
    length(u) >= 2 ||
        throw(ArgumentError("uには2点以上が必要です"))

    u[1] = left_value
    u[end] = u[end-1]
    return u
end
end

module N02

"""
    nonlinear_upwind_step!(args...; kwargs...)

N02の非線形風上更新を共通APIへ移す。

# 引数

- `args`: 新旧ベクトル、時間刻み、格子幅の順。新旧は独立し、旧場を保持する。
- `kwargs`: `boundary` は `:fixed` または `:periodic`（既定 `:fixed`）。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は境界も適用した新配列。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""

import ..ThermofluidExercise as Common

function nonlinear_upwind_step!(args...; kwargs...)
    # TODO(N05): 既習のN02.nonlinear_upwind_step!を共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 4 ||
        throw(ArgumentError("新旧配列、dt、dxの4引数が必要です"))
    all(k -> k === :boundary, keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはboundaryだけです"))

    u_new, u_old, dt, dx = args
    boundary = haskey(kwargs, :boundary) ? kwargs[:boundary] : :fixed

    boundary in (:fixed, :periodic) ||
        throw(ArgumentError("boundaryは:fixedまたは:periodicです"))
    u_new isa AbstractVector && u_old isa AbstractVector ||
        throw(ArgumentError("新旧バッファはベクトルです"))
    Common.validate_buffers(u_new, u_old)

    all(x -> x isa Real && !(x isa Bool) && isfinite(x) && x > 0, (dt, dx)) ||
        throw(ArgumentError("dtとdxは有限な正の実数です"))

    scale = dt / dx
    isfinite(scale) && scale > 0 ||
        throw(ArgumentError("dt/dxが表現範囲外です"))

    copyto!(u_new, u_old)
    indices = boundary === :periodic ? (1:length(u_old)) : (2:(length(u_old)-1))

    for i in indices
        left = boundary === :periodic ?
               Common.periodic_left_index(i, length(u_old)) : i - 1
        u_new[i] = u_old[i] - scale *
            (Common.burgers_flux(u_old[i]) - Common.burgers_flux(u_old[left]))
    end

    all(isfinite, u_new) ||
        error("更新後に非有限値があります。更新式を確認してください")

    return u_new
end

"""
    apply_boundary!(args...; kwargs...)

N02の固定または周期境界を共通APIへ移す。

# 引数

- `args`: 境界を適用するベクトル。周期境界では格子の全点を使う。
- `kwargs`: `boundary` は `:fixed` または `:periodic`（既定 `:fixed`）。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は境界を適用した入力ベクトル。周期境界では値を変更しない。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""
function apply_boundary!(args...; kwargs...)
    # TODO(N05): 既習のN02.apply_boundary!を共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 1 ||
        throw(ArgumentError("境界を適用するベクトルを1つ指定してください"))
    all(k -> k === :boundary, keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはboundaryだけです"))

    u = args[1]
    boundary = haskey(kwargs, :boundary) ? kwargs[:boundary] : :fixed

    boundary in (:fixed, :periodic) ||
        throw(ArgumentError("boundaryは:fixedまたは:periodicです"))
    u isa AbstractVector ||
        throw(ArgumentError("uはベクトルです"))
    length(u) >= 3 ||
        throw(ArgumentError("境界配列には3点以上が必要です"))
    if boundary === :fixed
        u[1] = 1.0
        u[end] = u[end - 1]
    end
    return u
end
end

module N03

"""
    diffusion_step!(args...; kwargs...)

N03の熱拡散更新を共通APIへ移す。

# 引数

- `args`: 新旧ベクトル、時間刻み、格子幅、有限正の拡散係数の順。新旧は独立し、旧場を保持する。
- `kwargs`: `boundary` は固定   温度の `:fixed`（既定）または断熱の `:insulated`。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は選択した境界も適用した新配列。安定上限を超える刻みも実験用に受け付ける。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""

import ..ThermofluidExercise as Common

function diffusion_step!(args...; kwargs...)
    # TODO(N05): 既習のN03.diffusion_step!を共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 5 ||
        throw(ArgumentError("新旧配列、dt、dx、diffusivityの5引数が必要です"))
    all(k -> k === :boundary, keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはboundaryだけです"))

    u_new, u_old, dt, dx, diffusivity = args
    boundary = haskey(kwargs, :boundary) ? kwargs[:boundary] : :fixed

    boundary in (:fixed, :insulated) ||
        throw(ArgumentError("boundaryは:fixedまたは:insulatedです"))
    u_new isa AbstractVector && u_old isa AbstractVector ||
        throw(ArgumentError("新旧バッファはベクトルです"))
    Common.validate_buffers(u_new, u_old)

    all(x -> x isa Real && !(x isa Bool) && isfinite(x) && x > 0,
        (dt, dx, diffusivity)) ||
        throw(ArgumentError("dt、dx、diffusivityは有限な正の実数です"))

    r = diffusivity * dt / dx^2
    isfinite(r) && r > 0 ||
        throw(ArgumentError("実効Fourier数が表現範囲外です"))

    for i in 2:(length(u_old) - 1)
        u_new[i] = u_old[i] + r * (u_old[i - 1] - 2u_old[i] + u_old[i + 1])
    end

    apply_boundary!(u_new, u_old, r; boundary=boundary)
    return u_new
end

"""
    apply_boundary!(args...; kwargs...)

N03の固定温度または断熱端点の更新を共通APIへ移す。

# 引数

- `args`: 新旧ベクトル、有限正の実効Fourier数の順。新旧は独立し、旧場を保持する。
- `kwargs`: `boundary` は固定温度の `:fixed`（既定）または断熱の `:insulated`。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は両端を更新した新ベクトル。内部点は変更しない。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""

function apply_boundary!(args...; kwargs...)
    # TODO(N05): 既習のN03.apply_boundary!を共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 3 ||
        throw(ArgumentError("新旧配列と実効Fourier数の3引数が必要です"))
    all(k -> k === :boundary, keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはboundaryだけです"))

    u_new, u_old, r = args
    boundary = haskey(kwargs, :boundary) ? kwargs[:boundary] : :fixed

    boundary in (:fixed, :insulated) ||
        throw(ArgumentError("boundaryは:fixedまたは:insulatedです"))
    u_new isa AbstractVector && u_old isa AbstractVector ||
        throw(ArgumentError("新旧バッファはベクトルです"))
    Common.validate_buffers(u_new, u_old)
    r isa Real && !(r isa Bool) && isfinite(r) && r > 0 ||
        throw(ArgumentError("rは有限な正の実数です"))

    if boundary === :fixed
        u_new[1] = 0.0
        u_new[end] = 0.0
    else
        u_new[1] = u_old[1] + 2r * (u_old[2] - u_old[1])
        u_new[end] = u_old[end] + 2r * (u_old[end - 1] - u_old[end])
    end

    return u_new
end
end
module N04

"""
    stable_timestep(args...; kwargs...)

N04の合成安定条件による刻み選択を共通APIへ移す。

# 引数

- `args`: 有限非負の最大速度、有限正の格子幅、有限非負の拡散係数の順。速度と拡散係数を同時に0にしない。
- `kwargs`: `safety` は0より大きく1以下（既定0.8）。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は有限正の時間刻み。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""

import ..ThermofluidExercise as Common

function stable_timestep(args...; kwargs...)
    # TODO(N05): 既習のN04.stable_timestepを共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 3 ||
        throw(ArgumentError("max_speed、dx、diffusivityの3引数が必要です"))
    all(k -> k === :safety, keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはsafetyだけです"))

    max_speed, dx, diffusivity = args
    safety = haskey(kwargs, :safety) ? kwargs[:safety] : 0.8

    all(x -> x isa Real && !(x isa Bool) && isfinite(x), (max_speed, dx, diffusivity)) ||
        throw(ArgumentError("max_speed、dx、diffusivityは有限な実数です"))
    max_speed >= 0 ||
        throw(ArgumentError("max_speedは非負です"))
    dx > 0 ||
        throw(ArgumentError("dxは正です"))
    diffusivity >= 0 ||
        throw(ArgumentError("diffusivityは非負です"))
    (max_speed > 0 || diffusivity > 0) ||
        throw(ArgumentError("max_speedとdiffusivityを同時に0にはできません"))
    safety isa Real && !(safety isa Bool) && isfinite(safety) && 0 < safety <= 1 ||
        throw(ArgumentError("safetyは有限な0より大きく1以下の実数です"))

    rate = max_speed / dx + 2 * diffusivity / dx^2
    isfinite(rate) && rate > 0 ||
        throw(ArgumentError("合成安定レートが表現範囲外です"))

    dt = safety / rate
    isfinite(dt) && dt > 0 ||
        throw(ArgumentError("時間刻みが表現範囲外です"))

    return dt
end

"""
    advection_diffusion_step!(args...; kwargs...)

N04の移流拡散更新を共通APIへ移す。

# 引数

- `args`: 新旧ベクトル、時間刻み、格子幅、有限非負の拡散係数の順。新旧は独立し、旧場を保持する。
- `kwargs`: `model` を明示する。`advection=true`、`speed=1.0` は既習入口と同じ。

対応する既習関数と同じ入力検証を保つ。未実装時は未実装エラーで停止する。

# 返り値

実装後は全周期格子点を更新した新配列。

# 受講生のToDo

既習の同名関数を共通APIを使う処理へ移す。入力検証・更新範囲・入力保持を保つ。
"""
function advection_diffusion_step!(args...; kwargs...)
    # TODO(N05): 既習のN04.advection_diffusion_step!を共通APIを使う処理へ移し、既存の契約を保つ。
    length(args) == 5 ||
        throw(ArgumentError("新旧配列、dt、dx、diffusivityの5引数が必要です"))
    all(k -> k in (:model, :advection, :speed), keys(kwargs)) ||
        throw(ArgumentError("指定できるキーワードはmodel、advection、speedです"))
    haskey(kwargs, :model) ||
        throw(ArgumentError("modelを指定してください"))

    u_new, u_old, dt, dx, diffusivity = args
    model = kwargs[:model]
    advection = haskey(kwargs, :advection) ? kwargs[:advection] : true
    speed = haskey(kwargs, :speed) ? kwargs[:speed] : 1.0

    model in (:linear, :nonlinear) ||
        throw(ArgumentError("modelは:linearまたは:nonlinearです"))
    advection isa Bool ||
        throw(ArgumentError("advectionはBoolです"))
    u_new isa AbstractVector && u_old isa AbstractVector ||
        throw(ArgumentError("新旧配列はベクトルです"))
    Common.validate_buffers(u_new, u_old)

    all(x -> x isa Real && !(x isa Bool) && isfinite(x), (dt, dx, diffusivity, speed)) ||
        throw(ArgumentError("dt、dx、diffusivity、speedは有限な実数です"))
    dt > 0 && dx > 0 ||
        throw(ArgumentError("dtとdxは正です"))
    diffusivity >= 0 ||
        throw(ArgumentError("diffusivityは非負です"))
    model === :linear && speed <= 0 &&
        throw(ArgumentError("線形モデルのspeedは正です"))

    max_speed = if !advection
        0.0
    elseif model === :linear
        speed
    else
        all(u -> u >= 0, u_old) ||
            throw(ArgumentError("非線形移流では旧場は非負です"))
        maximum(u_old)
    end
    cfl = max_speed * (dt / dx)
    fo = diffusivity * (dt / dx) / dx
    all(isfinite, (cfl, fo)) ||
        throw(ArgumentError("CFL・Foが有限ではありません"))
    cfl + 2fo <= 1 + 32eps(Float64) ||
        throw(ArgumentError("合成安定条件CFL+2Fo<=1を超えています"))

    for i in eachindex(u_old)
        left = Common.periodic_left_index(i, length(u_old))
        right = Common.periodic_right_index(i, length(u_old))
        ui = u_old[i]
        u_left = u_old[left]
        u_right = u_old[right]

        flux_difference = if !advection
            0.0
        elseif model === :linear
            Common.linear_flux(ui, speed) - Common.linear_flux(u_left, speed)
        else
            Common.burgers_flux(ui) - Common.burgers_flux(u_left)
        end

        u_new[i] = ui -
            (dt / dx) * flux_difference +
            (diffusivity * dt / dx^2) * (u_left - 2 * ui + u_right)
    end

    return u_new
end
end
include("N06Advection.jl")
include("N07Transport.jl")
include("N08N09Elliptic.jl")
end
