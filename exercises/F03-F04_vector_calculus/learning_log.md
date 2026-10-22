# F03-F04 統合学習ログ

## 実行前予想

- 四公式の成分証明で、積の微分や混合偏微分の交換をどこで使うと予想したか：
curl　grad = 0 と div curl = 0 で混合偏微分の交換を使うと予想した．積の発散では積の微分則を使い，curl curl の証明では成分展開と混合偏微分の交換を使うと予想した．

- 前進・後退・中心差分の誤差は刻み幅を半分にするとどう変わると予想したか：
前進差分と後退差分は刻み幅を半分にすると誤差は約1/2になると予想した．
中心差分は誤差が約1/4になると予想した．

- ベクトル解析四公式の残差は格子を細かくするとどう変わると予想したか：
格子を細かくすると小さくなると予想した．

## 証明：curl grad = 0

- 使用した定義：
\nabla\phi=
\left(
\frac{\partial\phi}{\partial x},
\frac{\partial\phi}{\partial y},
\frac{\partial\phi}{\partial z}
\right)

\nabla\times\boldsymbol{A}=
\left(
\frac{\partial A_z}{\partial y}-\frac{\partial A_y}{\partial z},
\frac{\partial A_x}{\partial z}-\frac{\partial A_z}{\partial x},
\frac{\partial A_y}{\partial x}-\frac{\partial A_x}{\partial y}
\right)

- 成分展開：
\left(
\frac{\partial^2 \phi}{\partial y \partial z}-\frac{\partial^2 \phi}{\partial z \partial y},
\frac{\partial^2 \phi}{\partial z \partial x}-\frac{\partial^2 \phi}{\partial x \partial z},
\frac{\partial^2 \phi}{\partial x \partial y}-\frac{\partial^2 \phi}{\partial y \partial x}
\right)

- 混合偏微分を交換した箇所：
\frac{\partial^2 \phi}{\partial y \partial z}=\frac{\partial^2 \phi}{\partial z \partial y},
\frac{\partial^2 \phi}{\partial z \partial x}=\frac{\partial^2 \phi}{\partial x \partial z},
\frac{\partial^2 \phi}{\partial x \partial y}=\frac{\partial^2 \phi}{\partial y \partial x}

- 結論：
場がC^2級であれば各成分が打ち消し合うため，\nabla\times(\nabla\phi)=0となる．

## 証明：div curl = 0

- 使用した定義：
\nabla\cdot\boldsymbol{A}=
\frac{\partial A_x}{\partial x}
+\frac{\partial A_y}{\partial y}
+\frac{\partial A_z}{\partial z}

\nabla\phi=
\left(
\frac{\partial\phi}{\partial x},
\frac{\partial\phi}{\partial y},
\frac{\partial\phi}{\partial z}
\right)

- 成分展開：
\frac{\partial^2 A_z}{\partial x \partial y} - \frac{\partial^2 A_y}{\partial x \partial z}
+\frac{\partial^2 A_x}{\partial y \partial z} - \frac{\partial^2 A_z}{\partial y \partial x}
+\frac{\partial^2 A_y}{\partial z \partial x} - \frac{\partial^2 A_x}{\partial z \partial y}

- 混合偏微分を交換した箇所：
\frac{\partial^2 A_z}{\partial x \partial y}=\frac{\partial^2 A_z}{\partial y \partial x}
\frac{\partial^2 A_x}{\partial y \partial z}=\frac{\partial^2 A_x}{\partial z \partial y}
\frac{\partial^2 A_y}{\partial z \partial x}=\frac{\partial^2 A_y}{\partial x \partial z}

- 結論：
対応する項同士が打ち消し合うため\nabla\cdot(\nabla\times\boldsymbol{A})

## 証明：積の発散

- 使用した定義：
\nabla\cdot\boldsymbol{A}=
\frac{\partial A_x}{\partial x}
+\frac{\partial A_y}{\partial y}
+\frac{\partial A_z}{\partial z}

- 積の微分による成分展開：
\frac{\partial (\phi A_x)}{\partial x} = A_x \frac{\partial \phi}{\partial x} + \phi\frac{\partial A_x}{\partial x}
\frac{\partial (\phi A_y)}{\partial y} = A_y \frac{\partial \phi}{\partial y} + \phi\frac{\partial A_y}{\partial y}
\frac{\partial (\phi A_z)}{\partial z} = A_z \frac{\partial \phi}{\partial z} + \phi\frac{\partial A_z}{\partial z}

- 必要な滑らかさと、混合偏微分の交換を使わない理由：
積の微分則のみを用いるため，混合偏微分の交換は使用しない．

- 結論：
\nabla\cdot(\phi\boldsymbol{A}) = \boldsymbol{A}\cdot\nabla\phi + \phi(\nabla\cdot\boldsymbol{A})を得た．

## 証明：curl curl

- ベクトルLaplacianの定義：
\nabla^2\boldsymbol{A}=(\nabla^2 A_x,\nabla^2 A_y,\nabla^2 A_z)

- 三成分の展開：
各成分についてcurlを2回適用して整理した．

- 混合偏微分を交換した箇所と条件：
条件：場がC^2級である
交換した箇所：
\frac{\partial^2 A_x}{\partial y \partial x}=\frac{\partial^2 A_x}{\partial x \partial y}
\frac{\partial^2 A_x}{\partial z \partial x}=\frac{\partial^2 A_x}{\partial x \partial z}
\frac{\partial^2 A_y}{\partial x \partial y}=\frac{\partial^2 A_y}{\partial y \partial x}
\frac{\partial^2 A_y}{\partial z \partial y}=\frac{\partial^2 A_y}{\partial y \partial z}
\frac{\partial^2 A_z}{\partial x \partial z}=\frac{\partial^2 A_z}{\partial z \partial x}
\frac{\partial^2 A_z}{\partial y \partial z}=\frac{\partial^2 A_z}{\partial z \partial y}

- 結論：
\nabla\times(\nabla\times\boldsymbol{A})=\nabla(\nabla\cdot\boldsymbol{A})-\nabla^2\boldsymbol{A}が成り立つことを確認した．

## 前進・後退・中心差分

- 3つの差分式：
前進差分式：\frac{f(x+h) - f(x)}{h}
後退差分：\frac{f(x) - f(x-h)}{h}
中心差分式：\frac{f(x+h) - f(x-h)}{2h}

- 参照する近傍点の違い：
前進差分は前側1点，後退差分は後ろ側1点を利用する．中心差分は前後1点ずつ利用する．

- Taylor 展開から予想する収束次数：
前進差分・後退差分は一次，中心差分は二次．

## 一次元の誤差と収束次数

| `h` | 前進誤差 | 後退誤差 | 中心誤差 |
|---:|---:|---:|---:|
| 0.2 | 0.2845033878495342 | 0.26356227877986793 | 0.010470554534833143 |
| 0.1 | 0.13994638477238697 | 0.134671969737316 | 0.0026372075175356002 |
| 0.05 | 0.06935149322820822 | 0.06803044512294831 | 0.0006605240526298406 |
| 0.025 | 0.03451523283352209 | 0.034184818063184075 |　0.00016520738516900835 |

- 誤差比と観測収束次数の解釈：
誤差比
| `h` | 前進誤差 | 後退誤差 | 中心誤差 |
|---:|---:|---:|---:|
| 0.2/0.1 | 2.03 | 1.96 | 3.97 |
| 0.1/0.05 | 2.02 | 1.98 | 3.99 |
| 0.05/0.025 | 2.01 | 1.99 | 4.00 |

前進差分と後退差分では，刻み幅を半分にすると誤差も概ね半分になったため，誤差比は約2，観測収束次数は約1となった．
一方，中心差分では刻み幅を半分にすると誤差がおよそ1/4になったため，誤差比は約4，観測収束次数は約2となった．
したがって，前進差分と後退差分は一次収束，中心差分は二次収束であることを確認できた．

## ベクトル解析四公式の数値検証

| 公式 | `n=9` | `n=17` | 粗格子／細格子 |
|---|---:|---:|---:|
| `curl grad = 0` | 0.04410437211036733 | 0.01102604495784032 | 4.00 |
| `div curl = 0` | 1.0344198257567623 | 0.2567890653754059 | 4.03 |
| `div(φ A) = A・grad φ + φ div A` | 0.24841539110969002 | 0.061704530391081036 | 4.03 |
| `curl curl A = grad div A - ∇²A` | 0.5472737120352011 | 0.13563481007748557 | 4.04 |

- 各公式で細格子の残差が粗格子より小さいこと：
すべての公式で，細格子の残差は粗格子より小さくなった．そのため，格子を細かくすると数値解が理論値に近づいていることを確認できた．
- 粗格子／細格子比と中心差分の二次収束の関係：
各公式における粗格子／細格子の残差比は約4であったことから数値検証でも中心差分の二次収束が確認できた．

## 解析的証明と数値的検証の役割

- 解析的な証明がすべての十分滑らかな場について保証すること：
解析的な証明では，場が十分滑らかであれば四公式が成り立つことを示した． そのため，今回用いた関数だけでなく，条件を満たす一般の場についても公式が成立することが保証される．

- 有限個の格子で得た数値結果が示すことと、単独では保証しないこと：
数値的検証では，今回設定した関数と格子に対して公式が成り立つことを確認した． 一方で，有限個の例を試しただけではすべての関数に対して成り立つことまでは保証できない． そのため，解析的証明と数値的検証は互いを補う役割を持つと考えられる．

- 積の発散の左右辺と、ほかの公式の内側・外側で、解析微分と数値微分をどう使い分けたか：
数値検証では，左右や内側と外側の両方を数値微分で計算すると誤差が打ち消し合う可能性がある．そのため，内側には解析微分を用い，外側に数値微分を用いた．

## 自分のテスト

- 手計算できる独立な入力と期待値：
f(x,y,z)=x-2+2y^2+3z^2を用いた．

点 (1,2,3)(1,2,3)(1,2,3) におけるy方向の偏微分は
\frac{\partial f}{\partial y}=4y
より

\frac{\partial f}{\partial y}(1,2,3)=8
となる．

そのため，centered_partial(quadratic_3d, (1.0, 2.0, 3.0), 2, 0.1) の結果が 8.0 に近くなることを期待した．

- このテストが検出する実装誤り：
偏微分する方向の指定を誤った場合や，中心差分の式の符号を間違えた場合，期待値 8.0 からずれるため検出できると考えた．また，前後の評価点の取り方を誤った場合にも異常を発見できると考えた．

## AI利用

- 依頼内容（利用なしの場合は「利用なし」）：
ベクトル解析四公式の成分証明の確認，数値微分の収束次数の解釈，および学習ログの記述内容の整理についてAIを利用した．また，run.jlのコードの解説もお願いした．
- 重要な提案：
混合偏微分の交換を使用する箇所の整理，二次収束の解釈，および解析的証明と数値検証の役割の違いについて説明を受けた．

- 採用・修正・却下と理由：
提案内容を自分で授業資料などを確認した上で採用した．数式表記や説明文については授業資料に合わせて一部修正した．

## diff・テスト・結果

- diff確認：
変更箇所について diff を確認し，意図しない変更が含まれていないことを確認した．
- 実行コマンドと成功／失敗：
課題で指定されたテストおよびスクリプトを実行し，すべて成功した．
- 結果と最終判断の理由：
解析的証明と数値的検証の両方で期待される結果が得られたため．


## 理解度チェック・LETUS提出

- 対応する授業ID：F03,F04
- LETUS提出日：10/15,10/22
- 提出済み確認：10/15,10/22
- 理解できた点：
・四公式の証明では混合偏微分の交換が重要であること
・前進差分と後退差分は一次収束，中心差分は二次収束となること
・誤差比から収束次数を確認できること
・数値的検証は解析的証明を補う役割を持つこと
- 残った疑問：現状特になし
- 対話全文はLETUSへ提出し，このリポジトリには含めていない：はい
