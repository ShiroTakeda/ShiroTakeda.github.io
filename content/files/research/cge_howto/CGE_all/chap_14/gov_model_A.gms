$title 政府を考慮したモデル
$ontext
Time-stamp:     <2022-01-21 15:15:31 st>
First-written:  <2016/03/15>

+ 政府を考慮したモデル
+ モデルは Part 5 のモデルと基本的に同じ

［注］ このプログラムを実行する前に data_create.gms を実行して、
chap_14_SAM_example.gdx というファイルを作成しておくこと。

$offtext

*       --------------------------------------------------------------
*       集合の宣言
set     ct      カテゴリー      / Sector, Factor, Policy, Goods, Other, Agent /
        subct                   / agr, man, ser, lab, cap, itx, con, gcn, hh, gov /
        i(subct)        財の集合              / agr, man, ser /
        f(subct)        生産要素の集合        / lab, cap /
;
*       aliasの作成
alias(i,j), (i,ii), (f,ff);
display i, j, f;

alias (ct,ctt), (subct, subctt);

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
SAMを読み込む。
$offtext
parameter
    SAM(ct,subct,ctt,subctt)    SAM;
;
*       gdx ファイルが存在しなければ止める。
$if not exist chap_14_SAM_example.gdx $abort

$gdxin chap_14_SAM_example.gdx
$load SAM

display SAM;

$ontext
以下の0付きのパラメータはベンチマークの変数の値を表すパラメータ
$offtext
parameters
    p0(i)       財の価格
    p_va0(i)    合成生産要素の価格
    p_f0(f)     生産要素の価格
    p_gov0      政府消費財の価格

    y0(i)       生産量
    vf0(f,i)    生産要素需要
    x0(j,i)     投入需要
    v_a0(i)     合成生産要素
    a_x0(j,i)   単位投入需要
    a_v0(i)     単位合成生産要素需要
    a_f0(f,i)   単位生産要素需要
    d0(i)       消費需要
    m_bf0       家計の所得（税引き前）
    m0          家計の所得（税引き後）
    m_gov0      政府の所得
    u0          効用水準
    q_gov0      政府消費財の生産量
    a_gov0(i)   単位政府消費需要

    c0(i)       生産の単位費用
    c_va0(i)    合成生産要素生産の単位費用
    e0          家計の消費支出
    c_gov0      政府消費財生産の単位費用
    tax_lump0   一括税
    tax_f0(f,i) 生産要素投入税
    tax_ind0(i) 純間接税
;
*       Harberger convention（全ての価格を1に規準化）
p0(i) = 1;
p_va0(i) = 1;
p_f0(f) = 1;
p_gov0 = 1;

*       生産量＝生産額/価格
y0(i) = sum((ct,subct), SAM(ct,subct,"Sector",i)) / p0(i);

*       投入需要量＝需要額/価格
x0(j,i) = SAM("Goods",j,"Sector",i) / p0(j);

*       合成生産要素需要量＝需要額/価格
v_a0(i) = sum(f, SAM("Factor",f,"Sector",i) + SAM("Policy",f,"Sector",i)) / p_va0(i);

*       生産要素需要量＝需要額/価格
vf0(f,i) = SAM("Factor",f,"Sector",i) / p_f0(f);

*       単位投入需要量＝投入需要量/生産量
a_x0(j,i) = x0(j,i) / y0(i);

*       単位合成生産要素需要量＝合成生産要素需要量/生産量
a_v0(i) = v_a0(i) / y0(i);

*       単位生産要素需要量＝生産要素需要量/生産量
a_f0(f,i) = vf0(f,i) / v_a0(i);

*       消費需要量＝消費需要額/価格
d0(i) = SAM("Goods",i,"Other","CON") / p0(i);

*       家計の所得額（税引き前）＝要素所得
m_bf0 = sum(f, SAM("Agent","HH","Factor",f));

*       一括税
tax_lump0 = SAM("Agent","GOV","Agent","HH") / p_gov0;

*       家計の所得（税引き後）
m0 = m_bf0 - tax_lump0;

*       生産要素投入税
tax_f0(f,i) = SAM("Policy",f,"Sector",i);

*       純間接税
tax_ind0(i) = SAM("Policy","ITX","Sector",i);

*       政府の所得
m_gov0 = sum(i, tax_ind0(i)) + sum((f,i), tax_f0(f,i))
         + p_gov0*tax_lump0;

*       効用水準
u0 = m0;

*       政府消費財の生産量
q_gov0 = SAM("Other","GCN","Agent","GOV") / p_gov0;

*       単位政府支出需要
a_gov0(i) = (SAM("Goods",i,"Other","GCN") / p0(i)) / q_gov0;

*       生産の単位費用
c0(i) = (p0(i) * y0(i) - tax_ind0(i)) / y0(i);

*       合成生産要素生産の単位費用
c_va0(i) = p_va0(i);

*       消費支出
e0 = sum(i, d0(i));

*       政府消費財生産の単位費用
c_gov0 = p_gov0;

display y0, x0, v_a0, vf0, a_x0, a_v0, a_f0, d0, m_bf0, tax_lump0, m0,
    tax_f0, tax_ind0, m_gov0, u0, q_gov0, a_gov0, c0, c_va0, e0,
    c_gov0;

*       --------------------------------------------------------------
*       外生変数
$ontext
+ モデルの外生変数は生産要素の賦存量。
$offtext
parameter
    v_bar(f)    生産要素の賦存量（外生的）
    v_bar0(f)   生産要素の賦存量（外生的）;
v_bar(f) = SAM("Agent","HH","Factor",f);
v_bar0(f) = v_bar(f);
display v_bar;

$ontext
+ 税率の初期値はベンチマークデータから求める。
+ ただし、消費税は 0 である。
$offtext
parameter
    t_c(i)      消費に対する従価税率
    t_f(f,i)    生産要素の投入に対する従価税率
    t_y(i)      生産に対する従価税率
    t_c0(i)     消費に対する従価税率（初期値）
    t_f0(f,i)   生産要素の投入に対する従価税率（初期値）
    t_y0(i)     生産に対する従価税率（初期値）
;
*       初期値 0
t_c0(i) = 0;

*       生産要素投入税率 = 税額 / 生産要素投入額
t_f0(f,i)$vf0(f,i) = tax_f0(f,i) / (p_f0(f)*vf0(f,i));

*       純間接税率 = 税額 / 生産額
t_y0(i) = tax_ind0(i) / (p0(i)*y0(i));

t_c(i) = t_c0(i);
t_f(f,i) = t_f0(f,i);
t_y(i) = t_y0(i);
display t_c0, t_f0, t_y0;

*       政府消費を固定するモデル用
parameter
    q_gov_bar   外生的な政府消費量
    q_gov_bar0  外生的な政府消費量（初期値）
;
q_gov_bar0 = q_gov0;
q_gov_bar = q_gov_bar0;
display q_gov_bar0;

parameter
    tax_lump_bar        外生的な政府消費量
    tax_lump_bar0       外生的な政府消費量（初期値）
;
tax_lump_bar0 = tax_lump0;
tax_lump_bar = tax_lump_bar0;
display tax_lump_bar0;

*       モデル選択のためのパラメータ
parameter
    fl_g_fix    政府消費固定モデルなら非ゼロ
    fl_g_var    政府消費可変モデルなら非ゼロ
;
fl_g_fix = 1;
fl_g_var = 0;
* fl_g_fix = 0;
* fl_g_var = 1;
display fl_g_fix, fl_g_var;

*       --------------------------------------------------------------
*       カリブレーション

alpha_x(j,i) = (a_x0(j,i))**(1/sig(i)) * p0(j) / c0(i);

alpha_v(i) = (a_v0(i))**(1/sig(i)) * p_va0(i) / c0(i);

beta_v(f,i) = (a_f0(f,i))**(1/sig_v(i)) * (1+t_f(f,i))*p_f0(f) / c_va0(i);

gamma(i) = (d0(i)/u0)**(1/sig_c) * p0(i) * u0 / e0;

option alpha_x:8, alpha_v:8, beta_v:8, gamma:8;
display alpha_x, alpha_v, beta_v, gamma;

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
    e           消費支出
    d(i)        消費需要
    c_gov       政府消費財生産の単位費用
    q_gov       政府消費財の生産量
    p(i)        財の価格
    p_va(i)     合成生産要素の価格
    p_f(f)      生産要素の価格
    p_gov       政府消費財の価格
    u           効用水準
    m           家計の所得（税引き後）
    m_gov       政府の所得
    tax_lump    一括税
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
    e_c_gov     政府消費財生産の単位費用
    e_q_gov     政府消費財の生産の利潤最大化条件
    e_p(i)      財の市場均衡
    e_p_va(i)   合成生産要素の市場均衡
    e_p_f(f)    生産要素の市場均衡
    e_p_gov     政府消費財の市場均衡
    e_u         支出＝所得
    e_m         家計の所得（税引き後）の定義式
    e_m_gov     政府の所得の定義式
    e_tax_lump  一括税
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
            
*       単位合成生産要素需要
e_a_v(i) .. a_v(i) =e= (alpha_v(i) * c(i) / p_va(i))**(sig(i));

*       単位投入需要
e_a_x(j,i) ..
          a_x(j,i) =e= (alpha_x(j,i) * c(i) / p(j))**(sig(i));

*       単位生産要素需要
e_a_f(f,i) ..
          a_f(f,i) =e=
              (beta_v(f,i) * c_va(i) / ((1+t_f(f,i))*p_f(f)))**(sig_v(i));

*       支出関数
e_e .. e =e=
       u * (sum(i,
           (gamma(i))**(sig_c) * ((1+t_c(i))*p(i))**(1-sig_c)))**(1/(1-sig_c));
       
*       消費需要
e_d(i) .. d(i) =e= u * (gamma(i)*(e/u)/((1+t_c(i))*p(i)))**(sig_c);

*       政府消費財生産の単位費用
e_c_gov .. c_gov =e= sum(i, p(i) * a_gov0(i));

*       政府消費財の生産の利潤最大化条件
e_q_gov .. c_gov =e= p_gov;

*       財の市場均衡
e_p(i) .. y(i) =e= sum(j, a_x(i,j)*y(j)) + d(i) + a_gov0(i)*q_gov;

*       合成生産要素の市場均衡
e_p_va(i) .. v_a(i) =e= a_v(i)*y(i);

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*v_a(i));

*       政府消費財の市場均衡
e_p_gov ..  q_gov =e= m_gov / p_gov;

*       政府の所得の定義式
e_m_gov .. m_gov =e=
           sum(i, t_y(i)*p(i)*y(i))
           + sum((f,i), t_f(f,i)*p_f(f)*a_f(f,i)*v_a(i))
           + sum(i, t_c(i)*p(i)*d(i))
           + p_gov*tax_lump;

*       家計の所得（税引き後）の定義式
e_m .. m =e= sum(f, p_f(f)*v_bar(f)) - p_gov*tax_lump;

*       支出＝所得
e_u ..    e - m =e= 0;

*       一括税
e_tax_lump .. (q_gov - q_gov_bar)$fl_g_fix
              + (tax_lump - tax_lump_bar)$fl_g_var =e= 0;

*       投入需要
e_x(j,i) .. x(j,i) =e= a_x(j,i) * y(i);

*       生産要素需要
e_vf(f,i) .. vf(f,i) =e= a_f(f,i) * v_a(i);

*       効用の価格
e_p_u .. p_u =e= e / u;

*       --------------------------------------------------------------
*       モデルの宣言
$ontext
+ MCPタイプのモデルとしてモデルを定義する。
+ 各式に対してその式に対応する変数を指定する。
$offtext

model gov_model_a 政府を考慮したモデル / e_c.c, e_c_va.c_va, e_y.y,
      e_v_a.v_a, e_a_v.a_v, e_a_x.a_x, e_a_f.a_f, e_e.e, e_d.d,
      e_c_gov.c_gov, e_q_gov.q_gov, e_p.p, e_p_va.p_va, e_p_f.p_f,
      e_p_gov.p_gov, e_m_gov.m_gov, e_m.m, e_u.u, e_tax_lump.tax_lump,
      e_x.x, e_vf.vf,e_p_u.p_u /;

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
q_gov.lo = 0;
x.lo(j,i) = 0;
vf.lo(f,i) = 0;

*       価格変数については下限を0ではない0に非常に近い値にする。
c.lo(i) = 1e-6;
c_va.lo(i) = 1e-6;
c_gov.lo = 1e-6;
p.lo(i) = 1e-6;
p_va.lo(i) = 1e-6;
p_f.lo(f) = 1e-6;
p_gov.lo = 1e-6;
e.lo = 0;
u.lo = 0;
m.lo = 0;
m_gov.lo = 0;
p_u.lo = 0;

*       tax_lump は負になる場合もありうるので下限を 0 としない。
tax_lump.lo = -inf;

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
c_gov.l = c_gov0;
q_gov.l = q_gov0;
x.l(j,i) = a_x0(j,i) * y0(i);
vf.l(f,i) = a_f0(f,i) * v_a0(i);
p.l(i) = p0(i);
p_va.l(i) = p_va0(i);
p_f.l(f) = p_f0(f);
p_gov.l = p_gov0;
u.l = u0;
m.l = m0;
m_gov.l = m_gov0;
tax_lump.l = tax_lump0;
p_u.l = m0 / u0;

*       --------------------------------------------------------------
*       ニュメレールの指定
p.fx("agr") = 1;

$ontext
ワルラス法則をチェックするためのパラメータ。
$offtext
parameter
    chk_walras  "Excess supply for the numeraire (agr)"
    results
    results_pc
;
set     scn     シナリオ        /
        bench           基準均衡,
        "scn_ca"        MAN に 20 %の消費税を導入
        "scn_cb"        全ての財に 20 %の消費税を導入
        "scn_ra"        全ての税金を撤廃するケース
        "scn_rb"        AGR 部門の LAB への課税のみ撤廃するケース
        "scn_sub"       生産税を補助金に変更するケース
        /
        mdl     モデル          / A-1, A-2 /
        mdl_c(mdl)
;
*       結果をパラメータに代入するためのマクロを定義
$macro output_result(mdl,scn) \
    chk_walras(mdl,scn) = round(p.m("agr"), 4); \
    results(mdl,"q_gov",scn) = q_gov.l; \
    results(mdl,"p_gov",scn) = p_gov.l / p_u.l; \
    results(mdl,"tax_lump",scn) = tax_lump.l; \
    results(mdl,"u",scn) = u.l; \
    results(mdl,"y_man",scn) = y.l("man"); \
    results(mdl,"y_agr",scn) = y.l("agr"); \
    results(mdl,"y_ser",scn) = y.l("ser"); \
    results(mdl,"c_man",scn) = d.l("man"); \
    results(mdl,"c_agr",scn) = d.l("agr"); \
    results(mdl,"c_ser",scn) = d.l("ser"); \
    abort$chk_walras(mdl,scn) "Walras law is violated!!!", chk_walras;

*       政策変数を初期化するためのマクロを定義
$macro policy_initialize \
    t_c(i) = t_c0(i); \
    t_y(i) = t_y0(i); \
    t_f(f,i) = t_f0(f,i); \
    tax_lump_bar = tax_lump_bar0; \

*       ------------------------------------------------------------
*       説明
$ontext
モデル
A-1) 政府消費を固定したモデル
A-2) 政府消費を可変にしたモデル

まず、A-1 を解き、同じシナリオを A-2 でも解く。

チェックする変数
・効用水準 (u)
・政府消費の水準 (q_gov)

$offtext
*       --------------------------------------------------------------
*       Benchmark replication (A-1)

*       A-1 のモデルを選択
fl_g_fix = 1;
fl_g_var = 0;

gov_model_a.iterlim = 0;
option mcp = path;
solve gov_model_a using mcp;

chk_walras("A-1","bench") = round(p.m("agr"), 4);
abort$chk_walras("A-1","bench") "ワルラス法則が満されていません！", chk_walras;

*       ------------------------------------------------------------
*       Cleanup calculation (A-1)
display "@ A-1 & bench";
gov_model_a.iterlim = 1000;
solve gov_model_a using mcp;
output_result("A-1","bench");

*       ------------------------------------------------------------
*       MAN への消費税の導入
display "@ A-1 & scn_ca";
t_c("MAN") = 0.2;
solve gov_model_a using mcp;
output_result("A-1","scn_ca");
policy_initialize;

*       ------------------------------------------------------------
*       消費税の導入
display "@ A-1 & scn_cb";
t_c(i) = 0.2;
solve gov_model_a using mcp;
output_result("A-1","scn_cb");
policy_initialize;

*       ------------------------------------------------------------
*       税金の撤廃
display "@ A-1 & scn_ra";
t_c(i) = 0;
t_y(i) = 0;
t_f(f,i) = 0;
solve gov_model_a using mcp;
output_result("A-1","scn_ra");
policy_initialize;

*       ------------------------------------------------------------
*       一部の税金の撤廃
display "@ A-1 & scn_rb";
t_f("lab","agr") = 0;
solve gov_model_a using mcp;
output_result("A-1","scn_rb");
policy_initialize;

*       ------------------------------------------------------------
*       生産税を生産補助金に変更
display "@ A-1 & scn_sub";
t_y(i) = - 0.1;;
solve gov_model_a using mcp;
output_result("A-1","scn_sub");
policy_initialize;

*       ------------------------------------------------------------
*       Cleanup calculation (A-2)

*       A-2 のモデルを選択
fl_g_fix = 0;
fl_g_var = 1;

display "@ A-2 & bench";
gov_model_a.iterlim = 1000;
solve gov_model_a using mcp;
output_result("A-2","bench");

display "@ A-2 & scn_ca";
t_c("MAN") = 0.2;
solve gov_model_a using mcp;
output_result("A-2","scn_ca");
policy_initialize;

display "@ A-2 & scn_cb";
t_c(i) = 0.2;
solve gov_model_a using mcp;
output_result("A-2","scn_cb");
policy_initialize;

display "@ A-2 & scn_ra";
t_c(i) = 0;
t_y(i) = 0;
t_f(f,i) = 0;
solve gov_model_a using mcp;
output_result("A-2","scn_ra");
policy_initialize;

display "@ A-2 & scn_rb";
t_f("lab","agr") = 0;
solve gov_model_a using mcp;
output_result("A-2","scn_rb");
policy_initialize;

display "@ A-2 & scn_sub";
t_y(i) = - 0.1;;
solve gov_model_a using mcp;
output_result("A-2","scn_sub");
policy_initialize;

*       ------------------------------------------------------------
*       結果
option results:1;
display results;

set vname / q_gov, p_gov, tax_lump, u, y_man, y_agr, y_ser, c_man, c_agr, c_ser /;

display vname;

results_pc(mdl,vname,scn)$results(mdl,vname,"bench")
    = 100*(results(mdl,vname,scn)/results(mdl,vname,"bench")
        - 1);
results_pc(mdl,vname,scn)$results(mdl,vname,"bench")
    = round(results_pc(mdl,vname,scn)$results(mdl,vname,"bench"), 6)
    + eps;
results_pc(mdl,vname,"bench") = 0;
option results_pc:2;
display results_pc;

execute_unload "gov_model_A.gdx", results, results_pc;


* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:
