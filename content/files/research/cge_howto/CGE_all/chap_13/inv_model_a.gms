$title 投資を考慮したモデル（貿易はなし）
$ontext
Time-stamp:     <2022-01-21 00:34:04 st>
First-written:  <2014/03/15>

+ 投資を考慮したモデル（ただし、貿易は考慮していない）
+ モデルは Chapter 5 のモデルと基本的に同じ

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
$offtext
parameter
    alpha_x(j,i)        生産関数のウェイトパラメータ
    alpha_v(i)          生産関数のウェイトパラメータ
    beta_v(f,i)         生産関数のウェイトパラメータ
    gamma(i)            効用関数のウェイトパラメータ
;
parameter
    alpha_nu            効用関数のパラメータ
;
*       --------------------------------------------------------------
*       代替の弾力性パラメータ
$ontext
+ 生産関数、効用関数の中の代替の弾力性 (elasticity of substitution,
  EOS) も外生的に設定する。
+ 1と0（つまり、Cobb-DouglasとLeontief型）には設定できないので注意。
+ Chapter 5のときと同じ値を設定。
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
+ 以下をSAMとして利用する。
+ chap_13_SAM_example.xlsx のデータ
$offtext
table   SAM     SAM data (benchmark data)
             AGR     MAN     SER     LAB     CAP     CON     INV      HH
AGR           30      10      30       0       0      80      20       0
MAN           10      50      20       0       0     120     130       0
SER           20      40      20       0       0     100      10       0
LAB           60     110      70       0       0       0       0       0
CAP           50     120      50       0       0       0       0       0
CON            0       0       0       0       0       0       0     300
INV            0       0       0       0       0       0       0     160
HH             0       0       0     240     220       0       0       0
;
set     row     / agr, man, ser, lab, cap, con, inv, hh  /;
alias(col,row), (row, roww);

$ontext
以下の0付きのパラメータはベンチマークの変数の値を表すパラメータ
$offtext
parameters
    p0(i)       財の価格
    p_va0(i)    合成生産要素の価格
    p_f0(f)     生産要素の価格
    p_inv0      投資財の価格

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
    q_inv0      投資財の生産量
    a_inv0(i)   単位投資需要

    c0(i)       生産の単位費用
    c_va0(i)    合成生産要素生産の単位費用
    e0          消費支出
    e_s0        貯蓄額（投資支出）
    c_inv0      投資財生産の単位費用
    nu0         効用水準（貯蓄率一定モデル用）
;
*       Harberger convention（全ての価格を1に規準化）
p0(i) = 1;
p_va0(i) = 1;
p_f0(f) = 1;
p_inv0 = 1;

*       生産量＝生産額/価格
y0(i) = sum(col, SAM(col,i)) / p0(i);

*       投入需要量＝需要額/価格
x0(j,i) = SAM(j,i) / p0(j);

*       合成生産要素需要量＝需要額/価格
v_a0(i) = sum(f, SAM(f,i)) / p_va0(i);

*       生産要素需要量＝需要額/価格
vf0(f,i) = SAM(f,i) / p_f0(f);

*       単位投入需要量＝投入需要量/生産量
a_x0(j,i) = x0(j,i) / y0(i);

*       単位合成生産要素需要量＝合成生産要素需要量/生産量
a_v0(i) = v_a0(i) / y0(i);

*       単位生産要素需要量＝生産要素需要量/生産量
a_f0(f,i) = vf0(f,i) / v_a0(i);

*       消費需要量＝消費需要額/価格
d0(i) = SAM(i,"CON") / p0(i);

*       所得額
m0 = sum(f, SAM("HH",f));

*       効用水準
u0 = m0;

*       投資財の生産量
q_inv0 = sum(i, SAM(i,"INV")) / p_inv0;

*       単位投資需要
a_inv0(i) = (SAM(i,"INV") / q_inv0) / p0(i);

*       生産の単位費用
c0(i) = p0(i);

*       合成生産要素生産の単位費用
c_va0(i) = p_va0(i);

*       貯蓄額（投資支出）
e_s0 = p_inv0*q_inv0;

*       消費支出
e0 = m0 - e_s0;

*       投資財生産の単位費用
c_inv0 = p_inv0;

*       効用水準（貯蓄率一定モデル用）
nu0 = u0 + e_s0;

display y0, x0, v_a0, vf0, a_x0, a_v0, a_f0, d0, m0, u0, q_inv0,
        a_inv0, c0, c_va0, e0, e_s0, c_inv0, nu0;

parameter
    phi_s       貯蓄率
;
phi_s = e_s0 / m0;
display phi_s;

*       --------------------------------------------------------------
*       カリブレーション

alpha_x(j,i) = (a_x0(j,i))**(1/sig(i)) * p0(j) / c0(i);

alpha_v(i) = (a_v0(i))**(1/sig(i)) * p_va0(i) / c0(i);

beta_v(f,i) = (a_f0(f,i))**(1/sig_v(i)) * p_f0(f) / c_va0(i);

gamma(i) = (d0(i)/u0)**(1/sig_c) * p0(i) * u0 / e0;

option alpha_x:8, alpha_v:8, beta_v:8, gamma:8;
display alpha_x, alpha_v, beta_v, gamma;

alpha_nu = nu0 / ((u0)**(1-phi_s) * (q_inv0)**(phi_s));
display alpha_nu;

*       --------------------------------------------------------------
*       外生変数
$ontext
+ モデルの外生変数は生産要素の賦存量。
$offtext
parameter
    v_bar(f)    生産要素の賦存量（外生的）
    v_bar0(f)   生産要素の賦存量（外生的）;
v_bar(f) = SAM("hh",f);
v_bar0(f) = v_bar(f);
display v_bar;

parameter
    t_c(i)      消費に対する従価税率
    t_f(f,i)    生産要素の投入に対する従価税率
    t_y(i)      生産に対する従価税率
    t_c0(i)     消費に対する従価税率（初期値）
    t_f0(f,i)   生産要素の投入に対する従価税率（初期値）
    t_y0(i)     生産に対する従価税率（初期値）
;
*       税率の初期値はゼロとする。
t_c0(i) = 0;
t_f0(f,i) = 0;
t_y0(i) = 0;

t_c(i) = t_c0(i);
t_f(f,i) = t_f0(f,i);
t_y(i) = t_y0(i);

*       投資を固定するモデル用
parameter
    q_inv_bar   外生的な投資量
    q_inv_bar0  外生的な投資量
;
q_inv_bar0 = q_inv0;
q_inv_bar = q_inv_bar0;
display q_inv_bar0;

*       モデル選択のためのパラメータ
parameter
    fl_i_fix    投資固定モデルなら非ゼロ
    fl_i_var    貯蓄率一定モデルなら非ゼロ
;
fl_i_fix = 1;
fl_i_var = 0$fl_i_fix + 1$(not fl_i_fix);
display fl_i_fix, fl_i_var;

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
    c_inv       投資財生産の単位費用
    q_inv       投資財の生産量
    p(i)        財の価格
    p_va(i)     合成生産要素の価格
    p_f(f)      生産要素の価格
    p_inv       投資財の価格
    u           効用水準
    m           所得
    e_s         貯蓄額（投資支出）
    nu          効用水準
    p_u         効用の価格
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
    e_c_inv     投資財生産の単位費用
    e_q_inv     投資財の生産の利潤最大化条件
    e_p(i)      財の市場均衡
    e_p_va(i)   合成生産要素の市場均衡
    e_p_f(f)    生産要素の市場均衡
    e_p_inv     投資財の市場均衡
    e_u         支出＝所得
    e_m         所得の定義式
    e_e_s       貯蓄額（投資支出）の定義式
    e_nu        効用関数
    e_p_u       効用の価格
;
*       --------------------------------------------------------------
*       式の定義
$ontext
式の定義については解説書の方を参照。
$offtext

*       生産の単位費用
e_c(i) .. c(i) =e=
          (sum(j, alpha_x(j,i)**sig(i) * p(j)**(1-sig(i)))
              + alpha_v(i)**sig(i) * p_va(i)**(1-sig(i)))**(1/(1-sig(i)));

*       合成生産要素生産の単位費用
e_c_va(i) .. c_va(i) =e=
             (sum(f, beta_v(f,i)**sig_v(i)
                 * ((1+t_f(f,i))*p_f(f))**(1-sig_v(i))))**(1/(1-sig_v(i)));

*       生産における利潤最大化条件
e_y(i) .. c(i) =e= (1 - t_y(i)) * p(i);

*       生産要素合成における利潤最大化条件
e_v_a(i) .. c_va(i) =e= p_va(i);
            
*       単位投入需要
e_a_x(j,i) ..
          a_x(j,i) =e= (alpha_x(j,i) * c(i) / p(j))**(sig(i));

*       単位合成生産要素需要
e_a_v(i) .. a_v(i) =e= (alpha_v(i) * c(i) / p_va(i))**(sig(i));

*       単位生産要素需要
e_a_f(f,i) ..
          a_f(f,i) =e=
              (beta_v(f,i) * c_va(i) / ((1+t_f(f,i))*p_f(f)))**(sig_v(i));

*       支出関数
e_e .. e =e=
       u * (sum(i,
           (gamma(i))**(sig_c) * ((1+t_c(i))*p(i))**(1-sig_c)))**(1/(1-sig_c));
       
*       消費需要
e_d(i) .. d(i) =e= 
          u * (gamma(i)*(e/u)/((1+t_c(i))*p(i)))**(sig_c);

*       投資財生産の単位費用
e_c_inv .. c_inv =e= sum(i, p(i) * a_inv0(i));

*       投資財の生産の利潤最大化条件
e_q_inv .. c_inv =e= p_inv;

*       財の市場均衡
e_p(i) .. y(i) =e= sum(j, a_x(i,j)*y(j)) + d(i) + a_inv0(i) * q_inv;

*       合成生産要素の市場均衡
e_p_va(i) .. v_a(i) =e= a_v(i)*y(i);

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*v_a(i));

*       投資財の市場均衡
e_p_inv ..
    (q_inv - q_inv_bar)$fl_i_fix
    + (q_inv * p_inv - e_s)$fl_i_var =e= 0;

*       支出＝所得
e_u ..    e - m + e_s =e= 0;

*       所得の定義式
e_m .. m =e= sum(f, p_f(f)*v_bar(f))
             + sum((f,i), t_f(f,i)*p_f(f)*a_f(f,i)*v_a(i))
             + sum(i, t_c(i)*p(i)*d(i))
             + sum(i, t_y(i)*p(i)*y(i));

*       貯蓄額（投資支出）
e_e_s .. e_s =e=
         (p_inv * q_inv)$fl_i_fix + (phi_s * m)$fl_i_var;

*       投入需要
e_x(j,i) .. x(j,i) =e= a_x(j,i) * y(i);

*       生産要素需要
e_vf(f,i) .. vf(f,i) =e= a_f(f,i) * v_a(i);

*       効用水準
e_nu .. nu =e= nu0$fl_i_fix
        + (alpha_nu * (u)**(1-phi_s) * (q_inv)**(phi_s))$fl_i_var;

*       効用の価格
e_p_u .. p_u =e= (m - e_s) / u;

*       --------------------------------------------------------------
*       モデルの宣言
$ontext
+ MCPタイプのモデルとしてモデルを定義する。
+ 各式に対してその式に対応する変数を指定する。

$offtext
model inv_model_a 投資を考慮したモデル
      / e_c.c, e_c_va.c_va, e_y.y, e_v_a.v_a, e_a_x.a_x, e_a_v.a_v,
      e_a_f.a_f, e_e.e, e_d.d, e_c_inv.c_inv, e_q_inv.q_inv, e_p.p,
      e_p_va.p_va, e_p_f.p_f, e_p_inv.p_inv, e_u.u, e_m.m, e_e_s.e_s,
      e_x.x, e_vf.vf, e_nu.nu, e_p_u.p_u /;

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
q_inv.lo = 0;
x.lo(j,i) = 0;
vf.lo(f,i) = 0;

*       価格変数については下限を0ではない0に非常に近い値にする。
c.lo(i) = 1e-6;
c_va.lo(i) = 1e-6;
c_inv.lo = 1e-6;
p.lo(i) = 1e-6;
p_va.lo(i) = 1e-6;
p_f.lo(f) = 1e-6;
p_inv.lo = 1e-6;
e.lo = 0;
e_s.lo = 0;
u.lo = 0;
m.lo = 0;
nu.lo = 0;
p_u.lo = 0;

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
c_inv.l = c_inv0;
q_inv.l = q_inv0;
x.l(j,i) = a_x0(j,i) * y0(i);
vf.l(f,i) = a_f0(f,i) * v_a0(i);
p.l(i) = 1;
p_va.l(i) = 1;
p_f.l(f) = 1;
p_inv.l = p_inv0;
u.l = u0;
m.l = m0;
e_s.l = e_s0;
nu.l = nu0;
p_u.l = (m0 - e_s0) / u0;

*       --------------------------------------------------------------
*       ニュメレールの指定
p.fx("agr") = 1;

$ontext
+ chk_walras はワルラス法則をチェックするためのパラメータ。
$offtext
parameter
    chk_walras  "Excess supply for the numeraire (agr)"
    results
    results_pc
;
set     scn     シナリオ        /
        bench           基準均衡,
        "rt_c"          MANへの消費税,
        "rt_p"          MANへの生産税 /
        mdl     モデル          / A-1, A-2 /
        mdl_c(mdl)
;
$macro output_result(mdl,scn) \
    chk_walras(mdl,scn) = round(p.m("agr"), 4); \
    results(mdl,"q_inv",scn) = q_inv.l; \
    results(mdl,"p_inv",scn) = p_inv.l / p_u.l; \
    results(mdl,"u",scn) = u.l; \
    results(mdl,"nu",scn) = nu.l; \
    results(mdl,"y_man",scn) = y.l("man"); \
    results(mdl,"y_agr",scn) = y.l("agr"); \
    results(mdl,"y_ser",scn) = y.l("ser"); \
    results(mdl,"c_man",scn) = d.l("man"); \
    results(mdl,"c_agr",scn) = d.l("agr"); \
    results(mdl,"c_ser",scn) = d.l("ser"); \
    abort$chk_walras(mdl,scn) "Walras' law is violated!!!", chk_walras;

*       ------------------------------------------------------------
*       説明
$ontext
モデル
A-1) 投資を固定したモデル
A-2) 貯蓄率一定のモデル + 消費・貯蓄のCobb-Douglas効用関数

まず、A-1 を解き、同じシナリオを A-2 でも解く。

政策シナリオ
1) MAN財の消費に税金をかける
2) MAN財の生産に税金をかける

チェックすること
・二つのシナリオで効用水準 (u) がどう変化するか？
・A-2 のモデルでは u と nu の動き方の違いをチェック。

$offtext
*       --------------------------------------------------------------
*       Benchmark replication (A-1)

*       A-1 のモデルを選択
fl_i_fix = 1;
fl_i_var = 0$fl_i_fix + 1$(not fl_i_fix);

inv_model_a.iterlim = 0;

option mcp = path;
solve inv_model_a using mcp;

chk_walras("chk","chk") = round(p.m("agr"), 4);
abort$chk_walras("chk","chk") "ワルラス法則が満されていません！", chk_walras;

*       ------------------------------------------------------------
*       Cleanup calculation (A-1)

inv_model_a.iterlim = 1000;
solve inv_model_a using mcp;
output_result("A-1","bench");

*       ------------------------------------------------------------
*       MAN への消費税 (A-1)

t_c("man") = 0.2;
solve inv_model_a using mcp;
t_c(i) = t_c0(i);
output_result("A-1","rt_c");

*       ------------------------------------------------------------
*       MAN への生産税 (A-1)

t_y("man") = 0.2;
solve inv_model_a using mcp;
t_y(i) = t_y0(i);
output_result("A-1","rt_p");

*       ------------------------------------------------------------
*       Cleanup calculation (A-2)

*       A-2 のモデルを選択
fl_i_fix = 0;
fl_i_var = 0$fl_i_fix + 1$(not fl_i_fix);

inv_model_a.iterlim = 1000;
solve inv_model_a using mcp;
output_result("A-2","bench");

*       ------------------------------------------------------------
*       MAN への消費税 (A-2)

t_c("man") = 0.2;
solve inv_model_a using mcp;
t_c(i) = t_c0(i);
output_result("A-2","rt_c");

*       ------------------------------------------------------------
*       MAN への生産税 (A-2)

t_y("man") = 0.2;
solve inv_model_a using mcp;
t_y(i) = t_y0(i);
output_result("A-2","rt_p");

*       ------------------------------------------------------------
*       結果
option results:1;
display results;

set vname / q_inv, u, nu, y_man, y_agr, y_ser, c_man, c_agr, c_ser, p_inv /;

display vname;

results_pc(mdl,vname,scn)$results(mdl,vname,"bench")
    = 100*(results(mdl,vname,scn)/results(mdl,vname,"bench")
        - 1) + eps;
results_pc(mdl,vname,"bench") = 0;
option results_pc:2;
display results_pc;

execute_unload "inv_model_A.gdx", results, results_pc;

* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:
