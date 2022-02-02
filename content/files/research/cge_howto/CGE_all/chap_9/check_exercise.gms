$title モデルのチェックの練習
$ontext
Time-stamp:     <2021-02-19 17:08:12 st>
First-written:  <2014/03/15>

+ Calibrated share formのCES関数を使ってモデルを表現
+ Normal formのモデルと同じ計算結果になるかと確認

+ Part 8の"calibrated_share_form.gms"が基のプログラム。

$offtext

*       --------------------------------------------------------------
*       集合の宣言
set     i 財の集合              / agr, man, ser /
        f 生産要素の集合        / lab, cap /
;
*       aliasの作成
alias(i,j), (i,ii), (f,ff);
display i, j, f;

*       --------------------------------------------------------------
*       生産関数・効用関数のパラメータ
$ontext
+ 生産関数、効用関数内のウェイトパラメータの宣言。
+ これをカリブレートする。

注: 今回はcalibrated share formで表現するので、以下のウェイトパラメー
タは利用しない。

parameter
    alpha_x(j,i)        生産関数のウェイトパラメータ
    alpha_v(i)          生産関数のウェイトパラメータ
    beta_v(f,i)         生産関数のウェイトパラメータ
    gamma(i)            効用関数のウェイトパラメータ
;
$offtext

*       --------------------------------------------------------------
*       代替の弾力性パラメータ
$ontext
+ 生産関数、効用関数の中の代替の弾力性 (elasticity of substitution,
  EOS) も外生的に設定する。
+ 1と0（つまり、Cobb-DouglasとLeontief型）には設定できないので注意。
+ Part 5のときと同じ値を設定。
$offtext
parameter
    sig(i)      生産要素とそれ以外の投入の間のEOS
    sig_v(i)    生産要素間のEOS
    sig_c       消費におけるEOS
;
sig(i) = 0.5;
sig_v(i) = 0.5;
sig_c = 0.5;
display sig, sig_v, sig_c;

*       --------------------------------------------------------------
*       ベンチマークデータ
$ontext
以下をSAMとして利用する。
$offtext

table   SAM     SAM data (benchmark data)
              agr      man      ser      lab      cap       hh
agr            30       10       30        0        0       70
man            10       50       20        0        0      220
ser            10       40       20        0        0       70
lab            50       80       50        0        0        0
cap            30      120       30        0        0        0
hh              0        0        0      180      180        0
;

set     row     / agr, man, ser, lab, cap, hh /;
alias(col,row), (row, roww);

$ontext
以下の0付きのパラメータはベンチマークの変数の値を表すパラメータ
$offtext
parameters
    p0(i)       財の価格
    p_va0(i)    合成生産要素の価格
    p_f0(f)     生産要素の価格

    y0(i)       生産量
    vf0(f,i)    生産要素需要
    x0(j,i)     投入需要
    v_a0(i)     合成生産要素
    a_x0(j,i)   単位投入需要
    a_v0(i)     単位合成生産要素需要
    a_f0(f,i)   単位生産要素需要
    d0(i)       消費需要
    m0          所得
    u0          効用水準

    c0(i)       生産の単位費用
    c_va0(i)    合成生産要素生産の単位費用
    e0          支出
;
*       Harberger convention（全ての価格を1に規準化）
p0(i) = 1;
p_va0(i) = 1;
p_f0(f) = 1;

*       生産量＝生産額/価格
y0(i) = sum(col, SAM(col,i)) / p0(i);

*       投入需要量＝需要額/価格
x0(j,i) = SAM(j,i) / p0(j);

*       合成生産要素需要量＝需要額/価格
v_a0(i) = sum(f, SAM(f,i)) / p_va0(i);

*       生産要素需要量＝需要額/価格
vf0(f,i) = SAM(f,i) / p_f0(f);

*       単位投入需要量＝投入需要量/生産量
a_x0(j,i) = x0(j,i) / v_a0(i);

*       単位合成生産要素需要量＝合成生産要素需要量/生産量
a_v0(i) = v_a0(i) / y0(i);

*       単位生産要素需要量＝生産要素需要量/生産量
a_f0(f,i) = vf0(f,i) / v_a0(i);

*       消費需要量＝消費需要額/価格
d0(i) = SAM(i,"hh") / p0(i);

*       所得額
m0 = sum(f, SAM("hh",f));

*       効用水準
u0 = m0;

*       生産の単位費用
c0(i) = p0(i);

*       合成生産要素生産の単位費用
c_va0(i) = p_va0(i);

*       支出
e0 = m0;

display y0, x0, v_a0, vf0, a_x0, a_v0, a_f0, d0, m0, u0, c0, c_va0, e0;

*       --------------------------------------------------------------
*       カリブレーション
$ontext
今回はcalibrated share formを利用するので、以下のコードは使わない。
$offtext

$ontext
alpha_x(j,i) = (a_x0(j,i))**(1/sig(i)) * p0(j) / c0(i);

alpha_v(i) = (a_v0(i))**(1/sig(i)) * p_va0(i) / c0(i);

beta_v(f,i) = (a_f0(f,i))**(1/sig_v(i)) * p_f0(f) / c_va0(i);

gamma(i) = (d0(i)/u0)**(1/sig_c) * p0(i) * u0 / e0;

option alpha_x:8, alpha_v:8, beta_v:8, gamma:8;
display alpha_x, alpha_v, beta_v, gamma;
$offtext

*       --------------------------------------------------------------
*       Calibrated share form
$ontext
+ calibrated share formによる表現ではベンチマークにおけるシェアを表す
  パラメータを利用する。
$offtext

parameter
    cost_y0(i)          生産費用
    cost_v_a0(i)        合成生産要素生産の費用
    cost_c0             消費額
;

cost_y0(i) = sum(j, p0(j)*x0(j,i)) + p_va0(i)*v_a0(i);
cost_v_a0(i) = sum(f, p_f0(f)*vf0(f,i));
cost_c0 = sum(i, p0(i)*d0(i));

display cost_y0, cost_v_a0, cost_c0;
    
parameter
    sh_x(j,i)   中間投入財のシェア
    sh_v(i)     合成生産要素のシェア
    sh_f(f,i)   生産要素のシェア
    sh_c(i)     消費における各財のシェア
;

sh_x(j,i) = p0(j)*x0(j,i) / cost_y0(i);
sh_v(i) = p_va0(i)*v_a0(i) / cost_y0(i);
sh_f(f,i) = p_f0(f)*vf0(f,i) / cost_v_a0(i);
sh_c(i) = p0(i)*d0(i) / cost_c0;

display sh_x, sh_v, sh_f, sh_c;

*       --------------------------------------------------------------
*       外生変数
$ontext
+ モデルの外生変数は生産要素の賦存量。
$offtext
parameter
    v_bar(f)    生産要素の賦存量（外生的）
    v_bar0(f)   生産要素の賦存量（外生的）;
v_bar(f) = SAM(f,"agr") + SAM(f,"man");
v_bar0(f) = v_bar(f);
display v_bar;

parameter
    t_c(i)      消費に対する従価税率
    t_f(f,i)    生産要素の投入に対する従価税率
    t_c0(i)     消費に対する従価税率（初期値）
    t_f0(f,i)   生産要素の投入に対する従価税率（初期値）
;
*       税率の初期値はゼロとする。
t_c0(i) = 0.1;
t_f0(f,i) = 0;

t_c(i) = t_c0(i);
t_f(f,i) = t_f0(f,i);

*       --------------------------------------------------------------
*       変数の宣言
variables
    c(i)        生産の単位費用
    c_va(i)     合成生産要素生産の単位費用
    y(i)        生産量
    v_a(i)      合成生産要素
    a_x(j,i)    単位投入需要
    x(j,i)      投入需要
    a_v(i)      単位合成生産要素需要
    a_f(f,i)    単位生産要素需要
    vf(f,i)     生産要素需要
    e           支出
    d(i)        消費需要
    p(i)        財の価格
    p_va(i)     合成生産要素の価格
    p_f(f)      生産要素の価格
    u           効用水準
    m           所得
;
*       --------------------------------------------------------------
*       式の宣言
equations
    e_c(i)      生産の単位費用
    e_c_va(i)   合成生産要素生産の単位費用
    e_y(i)      生産における利潤最大化条件
    e_v_a(i)    生産要素合成における利潤最大化条件
    e_a_x(j,i)  単位投入需要
    e_x(j,i)    投入需要
    e_a_v(i)    単位合成生産要素需要
    e_a_f(f,i)  単位生産要素需要
    e_vf(f,i)   生産要素需要
    e_e         支出関数
    e_d(i)      消費需要
    e_p(i)      財の市場均衡
    e_p_va(i)   合成生産要素の市場均衡
    e_p_f(f)    生産要素の市場均衡
    e_u         支出＝所得
    e_m         所得の定義式
;
*       --------------------------------------------------------------
*       式の定義
$ontext
式の定義については解説書の方を参照。
$offtext

*       生産の単位費用
e_c(i) .. c(i) =e=
          c0(i) * (sum(j, sh_x(i,j) * (p(j)/p0(j))**(1-sig(i)))
              + sh_v(i) * (p_va(i)/p_va0(i))**(1-sig(i))
          )**(1/(1-sig(i)));

*       合成生産要素生産の単位費用
e_c_va(i) ..
    c_va(i) =e=
    c_va0(i)
    * (sum(f,
        sh_f(f,i)
        * (((1+t_f(f,i))*p_f(f))/((1+t_f0(f,i))*p_f0(f)))**(1-sig_v(i)))
    )**(1/(1+sig_v(i)));

*       生産における利潤最大化条件
e_y(i) .. c(i) =e= p(i);;

*       生産要素合成における利潤最大化条件
e_v_a(i) .. c_va(i) =e= p_va(i);;

*       単位投入需要
e_a_x(j,i) ..
          a_x(j,i) =e= a_x0(j,i)
          * ((c(i) / c0(i)) / (p(j) / p0(j)))**(1/sig(i));

*       単位合成生産要素需要
e_a_v(i) .. a_v(i) =e= a_v0(i)
            * ((c(i) / c0(i)) / (p_va(i) / p_va0(i)))**sig(i);

*       単位生産要素需要
e_a_f(f,i) ..
          a_f(f,i) =e= a_f0(f,i)
          * ((c_va(i) / c_va0(i)) /
              (((1+t_f(f,i))*p_f(f)) / ((1+t_f0(f,i))*p_f0(f))))**sig_v(i);

*       支出関数
e_e .. e =e=
       u * (e0/u0)
       * (sum(i, sh_c(i) * (((1+t_c(i))*p(i)) / ((1+t_c0(i))*p0(i)))**(1-sig_c))
       );

*       消費需要
e_d(i) .. d(i) =e=
          d0(i) * (u/u0)**(1-sig_c)
          * ((e/e0) / (((1+t_c(i))*p(i)) / ((1+t_c0(i))*p0(i))))**sig_c;

*       財の市場均衡
e_p(i) .. y(i) =e= sum(j, a_x(i,j)*y(j)) + d(i);

*       合成生産要素の市場均衡
e_p_va(i) .. v_a(i) =e= a_v(i)*y(i);

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*y(i));

*       支出＝所得
e_u ..    e =e= m;

*       所得の定義式
e_m .. m =e= sum(f, p_f(f)*v_bar(f))
             + sum(i, t_c(i)*p(i)*d(i))
             + sum((f,i), t_f(f,i)*p_f(f)*a_f(f,i)*v_a(i));

*       投入需要
e_x(j,i) .. x(j,i) =e= a_x(j,i) * y(i);

*       生産要素需要
e_vf(f,i) .. vf(f,i) =e= a_f(f,i) * v_a(i);

*       --------------------------------------------------------------
*       モデルの宣言
$ontext
+ MCPタイプのモデルとしてモデルを定義する。
+ 各式に対してその式に対応する変数を指定する。

$offtext

model csf_model Calibrates share formのモデル

      / e_c.c, e_c_va.c_va, e_y.y, e_v_a.v_a, e_a_x.a_x, e_a_v.a_v,
      e_a_f.a_f, e_e.e, e_d.d, e_p.p, e_p_va.p_va, e_p_f.p_f, e_u.u,
      e_m.m, e_x.x, e_vf.vf /;

*       --------------------------------------------------------------
*       変数の下限値
$ontext
本来は全ての変数について下限値は0であるが、価格変数については0ではない
非常に小さい値（ここでは1e-6）を指定しておく。価格変数についてはモデル
において分母に入ってくる部分があり、下限を0に指定すると計算の途中におい
て価格が0になる場合があり、その際「division by zero」エラーが生じてしま
うため。

$offtext
*       数量を表す変数の下限は0とする。
y.lo(i) = 0;
v_a.lo(i) = 0;
a_x.lo(j,i) = 0;
a_v.lo(i) = 0;
a_f.lo(f,i) = 0;
d.lo(i) = 0;
x.lo(j,i) = 0;
vf.lo(f,i) = 0;

*       価格変数については下限を0ではない0に非常に近い値にする。
c.lo(i) = 1e-6;
c_va.lo(i) = 1e-6;
p.lo(i) = 1e-6;
p_va.lo(i) = 1e-6;
p_f.lo(f) = 1e-6;
e.lo = 0;
u.lo = 0;
m.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値
$ontext
ここで指定した値がモデルを解く際の変数の初期値として利用される。
$offtext

c.l(i) = c0(i);
c_va.l(i) = c_va0(i);
y.l(i) = y0(i);
v_a.l(i) = v_a0(i);
a_x.l(j,i) = a_x0(j,i);
a_v.l(i) = a_v0(i);
a_f.l(f,i) = a_f0(f,i);
e.l = e0;
d.l(i) = d0(i);
x.l(j,i) = a_x0(j,i) * y0(i);
vf.l(f,i) = a_f0(f,i) * v_a0(i);
p.l(i) = 1;
p_va.l(i) = 1;
p_f.l(f) = 1;
u.l = u0;
m.l = m0;

*       --------------------------------------------------------------
*       ニュメレールの指定
p.fx("agr") = 1;

$ontext
ワルラス法則をチェックするためのパラメータ。
$offtext
parameter
    chk_walras  "Excess supply for the numeraire (agr)"
;
*       ソルバーの指定
option mcp = path;

*       --------------------------------------------------------------
*       Benchmark replication
csf_model.iterlim = 0;
solve csf_model using mcp;

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
$exit

*       --------------------------------------------------------------
*       Cleanup calculation
csf_model.iterlim = 10000;
solve csf_model using mcp;

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
$exit

*       --------------------------------------------------------------
*       ニュメレールによるチェック
p.fx("agr") = 2;
solve csf_model using mcp;
p.fx("agr") = 1;

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
$exit

*       --------------------------------------------------------------
*       外生変数の比例的変化
v_bar(f) = v_bar0(f) * 2;
solve csf_model using mcp;
v_bar(f) = v_bar0(f);

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
$exit

*       --------------------------------------------------------------
*       税金の導入
t_c("agr") = 0.2;
t_f("lab","man") = 0.2;
solve csf_model using mcp;

t_c(i) = t_c0(i);
t_f(f,i) = t_f0(f,i);

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;

* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
