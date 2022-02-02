$title 日本の CGE モデル
$ontext
Time-stamp: <2022-01-24 12:48:36 st>
First-written:  <2016/03/15>

+ このプログラムは Japan_model.gms と基本的に同じモデル。
+ ただし、内生変数の初期値が 1 をとるようにモデルを修正。

［注］
このプログラムを実行する前に

+ data_create.gms
+ data_create_alt.gms

を実行して、Excel ファイルから GDX ファイルを作成してください。

$offtext

* chap_15_SAM_Japan_alt の方を利用するなら、以下の行のコメントアウトをとる。
$setglobal data_name chap_15_SAM_Japan_alt

$ontext
コントロール変数の定義
+ $setglobal や $set 命令でコントロール変数を定義できる。
+ 例えば、name というコントロール変数を定義した場合、%name% という記法
  によって、その変数に代入された値を表現できる。
$offtext
*   シミュレーション名（この値で出力するファイル名が変わる）
$if not setglobal sim_name $setglobal sim_name normalized_alt
display "シミュレーション名の値 = %sim_name%";

*   Dataの名前の設定
$if not setglobal data_name $setglobal data_name chap_15_SAM_Japan
display "data_name の値 = %data_name%";

*   --------------------------------------------------------------
*   集合の宣言
$ontext
+ 集合の定義は別ファイルでおこなっている。
+ これは、利用するデータによって異なる集合を定義するため。
+ 仮に変数 data_name の値が chap_15_SAM_Japan なら
  %data_name%.set は chap_15_SAM_Japan.set に置き換わる。
$offtext
$include %data_name%.set

*       定義された集合を表示
display ct, subct, i, j, f, s_ely;

*   --------------------------------------------------------------
*   ベンチマークデータ
$ontext
SAMを読み込む。
$offtext
parameter
    SAM(ct,subct,ctt,subctt)    SAM（単位10億円）;
;
*   gdx ファイルが存在しなければ止める。
$if not exist %data_name%.gdx $abort

*   gdx ファイルを読み込み
$gdxin %data_name%.gdx
$load SAM

display SAM;

$ontext
+ 元々の SAM データの単位は「10 億円」。
+ これを「1 兆円」に変換する。
$offtext
parameter
    adj_unit    / 1e-3 /
;
SAM(ct,subct,ctt,subctt)
    = SAM(ct,subct,ctt,subctt) * adj_unit;
display adj_unit, SAM;

$ontext
マイナスの要素をチェック。
$offtext
parameter
    chk_sign_sam
;
chk_sign_sam(ct,subct,ctt,subctt)$(SAM(ct,subct,ctt,subctt) < 0)
    = SAM(ct,subct,ctt,subctt);
display chk_sign_sam;

$ontext
中間投入や投資にマイナスの要素が出てくるが、どちらも固定係数で投入が決まるので、
マイナスでも問題ない。

$offtext

*   --------------------------------------------------------------
*   ベンチマークデータ用のパラメータ
parameter
    p_ew0(i)    輸出財の世界価格
    p_mw0(i)    輸入財の世界価格
;
*   全て1と置く。
p_ew0(i) = 1;
p_mw0(i) = 1;
display p_ew0, p_mw0;

$ontext
以下は主に内生変数の初期値を入れるためのパラメータ。
$offtext
parameters
    c0(j)       生産の単位費用
    c_va0(j)    合成生産要素生産の単位費用
    c_u0        効用生産の単位費用
    c_a0(i)     Armington統合の単位費用
    c_inv0      投資財生産の単位費用
    c_gov0      政府消費財生産の単位費用
    r_y0(j)     生産の単位収入
    r_de0(i)    輸出・国内供給配分活動の単位収入
    x_e0(i)     輸出量
    x_m0(i)     輸入量
    y0(j)       生産水準
    v_a0(j)     合成生産要素
    y_de0(i)    輸出・国内供給配分活動
    u0          効用の生産量
    q_a0(i)     Armington統合
    q_inv0      投資財の生産量
    q_gov0      政府消費財の生産量
    t_f0(f,j)   生産要素需要
    t_u0(i)     消費需要
    t_ad0(i)    Armington統合の単位国内財需要
    t_am0(i)    Armington統合の単位輸入財需要
    t_x0(i,j)   中間投入需要
    t_v0(j)     合成生産要素需要
    t_inv0(i)   投資需要
    t_gov0(i)   政府消費需要
    t_es0(i)    輸出供給
    t_ds0(i)    国内供給
    t_y0(i,j)   生産量
    a_f0(f,j)   単位生産要素需要
    a_d0(i)     単位消費需要
    a_ad0(i)    Armington統合の単位国内財需要
    a_am0(i)    Armington統合の単位輸入財需要
    a_x0(i,j)   単位中間投入需要
    a_v0(j)     単位合成生産要素需要
    a_inv0(i)   単位投資需要
    a_gov0(i)   単位政府消費需要
    a_es0(i)    単位輸出供給
    a_ds0(i)    単位国内供給
    a_y0(i,j)   単位生産量
    p_y0(i)     生産物価格
    p_d0(i)     国内財の価格
    p_e0(i)     輸出財の価格
    p_m0(i)     輸入財の価格
    p_a0(i)     Armington財の価格
    p_va0(j)    合成生産要素の価格
    p_f0(f)     生産要素の価格
    p_u0        効用の価格
    p_inv0      投資財の価格
    p_gov0      政府消費財の価格
    p_ex0       為替レート（外貨の価格）
    ts0         貿易収支
    tax_f0(f,j) 生産要素投入税
    tax_out0(j) 生産税
    tax_inc0(f) 所得税
    tax_imp0(i) 輸入関税
    tax_con0(i) 消費税
    tax_all0    税収（一括税以外）
    tax_lump0   一括トランスファー
    m_gov0      政府の所得（トランスファー除去後）
    m_bf_f0     家計の要素所得（税引き前）
    m_bf0       家計の要素所得（税引き前）
    m0          家計の所得（税引き後）
    m_d0        消費に支出される所得
;
parameter
    v_bar(f)    生産要素の賦存量（外生的）
    v_bar0(f)   生産要素の賦存量（外生的）
    end_hh(i)   家計の初期保有する財の量（外生的）
    end_hh0(i)  家計の初期保有する財の量（外生的）
;
*   Harberger convention（全ての価格を1に規準化）
p_y0(i) = 1;
p_d0(i) = 1;
p_e0(i) = 1;
p_m0(i) = 1;
p_a0(i) = 1;
p_va0(j) = 1;
p_f0(f) = 1;
p_u0 = 1;
p_inv0 = 1;
p_gov0 = 1;
p_ex0 = 1;
r_y0(j) = 1;
r_de0(i) = 1;

display p_y0, p_d0, p_e0, p_m0, p_a0, p_va0, p_f0, p_u0, p_inv0, p_gov0, p_ex0,
    r_y0, r_de0;

*   生産要素の賦存量（外生的）
v_bar0(f) = SAM("Agent","hh","Factor",f) / p_f0(f);
v_bar(f) = v_bar0(f);
display v_bar;

*   家計の初期保有する財の量（外生的）
end_hh0(i) = SAM("Agent","hh","Com",i) / p_d0(i);
end_hh(i) = end_hh0(i);
display end_hh0;

*   輸出量
x_e0(i) = SAM("Dealc",i,"Agent","ROW") / p_e0(i);

*   輸入量
x_m0(i) = SAM("Agent","ROW","Com",i) / p_mw0(i);

*   生産水準
y0(j) = sum((ct,subct), SAM(ct,subct,"Sector",j)) / r_y0(j);

*   合成生産要素
v_a0(j) =
    sum(f, SAM("Factor",f,"Sector",j) + SAM("Tax_fac",f,"Sector",j))
    / p_va0(j);

*   輸出・国内供給配分活動
y_de0(i) = sum(j, SAM("Sector",j,"Dealc",i)) / r_de0(i);

*   効用の生産量
u0 = SAM("Oth","CON","Agent","HH") / p_u0;

*   Armington統合
q_a0(i) = sum((ct,subct), SAM(ct,subct,"Com",i)) / p_a0(i);

*   投資財の生産量
q_inv0 = sum(i, SAM("Com",i,"Oth","INV")) / p_inv0;

*   政府消費財の生産量
q_gov0 = sum(i, SAM("Com",i,"Oth","GCN")) / p_gov0;

display x_e0, x_m0, y0, v_a0, y_de0, u0, q_a0, q_inv0, q_gov0;

*   生産要素需要
t_f0(f,j) = SAM("Factor",f,"Sector",j) / p_f0(f);

*   消費需要
t_u0(i) = SAM("Com",i,"Oth","CON") / p_a0(i);

*   Armington統合の単位国内財需要
t_ad0(i) = SAM("Dealc",i,"Com",i) / p_d0(i) +  end_hh0(i);

*   Armington統合の単位輸入財需要
t_am0(i) = SAM("Agent","ROW","Com",i) / p_m0(i);

*   中間投入需要
t_x0(i,j) = SAM("Com",i,"Sector",j) / p_a0(i);

*   合成生産要素需要
t_v0(j) =
    (sum(f, SAM("Factor",f,"Sector",j) + SAM("Tax_fac",f,"Sector",j))) / p_va0(j);

*   投資需要
t_inv0(i) = SAM("Com",i,"Oth","INV") / p_a0(i);

*   政府消費需要
t_gov0(i) = SAM("Com",i,"Oth","GCN") / p_a0(i);

*   輸出供給
t_es0(i) = SAM("Dealc",i,"Agent","ROW") / p_e0(i);

*   国内供給
t_ds0(i) = SAM("Dealc",i,"Com",i) / p_d0(i);

*   生産量
t_y0(i,j) = SAM("Sector",j,"Dealc",i) / p_y0(i);

display t_f0, t_u0, t_ad0, t_am0, t_x0, t_v0, t_inv0, t_gov0, t_es0,
    t_ds0, t_y0;

*   単位生産要素需要
a_f0(f,j)$v_a0(j) = t_f0(f,j) / v_a0(j);

*   単位消費需要
a_d0(i) = t_u0(i) / u0;

*   Armington統合の単位国内財需要
a_ad0(i)$q_a0(i) = t_ad0(i) / q_a0(i);

*   Armington統合の単位輸入財需要
a_am0(i)$q_a0(i) = t_am0(i) / q_a0(i);

*   単位中間投入需要
a_x0(i,j)$y0(j) = t_x0(i,j) / y0(j);

*   単位合成生産要素需要
a_v0(j)$y0(j) = t_v0(j) / y0(j);

*   単位投資需要
a_inv0(i) = t_inv0(i) / q_inv0;

*   単位政府消費需要
a_gov0(i) = t_gov0(i) / q_gov0;

*   単位輸出供給
a_es0(i)$y_de0(i) = t_es0(i) / y_de0(i);

*   単位国内供給
a_ds0(i)$y_de0(i) = t_ds0(i) / y_de0(i);

*   単位生産量
a_y0(i,j)$y0(j) = t_y0(i,j) / y0(j);

display a_f0, a_d0, a_ad0, a_am0, a_x0, a_v0, a_inv0, a_gov0, a_es0,
    a_ds0, a_y0;

*   貿易収支
ts0 = sum(i, p_ew0(i)*x_e0(i) - p_mw0(i)*x_m0(i));

*   生産要素投入税
tax_f0(f,j) = 0;
tax_f0(f,j) = SAM("Tax_fac",f,"Sector",j);

*   生産税
tax_out0(j) = SAM("Tax_oth","OUT","Sector",j);

*   所得税
tax_inc0(f) = SAM("Tax_finc",f,"Agent","HH");

*   輸入関税
tax_imp0(i) = SAM("Tax_oth","imp","Com",i);

*   消費税
*tax_con0(i) = SAM("Policy","T_CON","Com",i);
tax_con0(i) = 0.05 * p_a0(i)*t_u0(i);

*   税収（一括税以外）
tax_all0 = sum((f,j), tax_f0(f,j))
    + sum(i, tax_imp0(i))
    + sum(i, tax_con0(i))
    + sum(j, tax_out0(j))
    + sum(f, tax_inc0(f));

*   一括トランスファー（政府→家計）
tax_lump0 = SAM("Agent","HH","Agent","Gov");

*   政府の所得（トランスファー除去後）
m_gov0 = sum(f, SAM("Agent","Gov","Tax_fac",f))
    + sum(f, SAM("Agent","Gov","Tax_finc",f))
    +  SAM("Agent","Gov","Tax_oth","out")
    +  SAM("Agent","Gov","Tax_oth","con")
    +  SAM("Agent","Gov","Tax_oth","imp")
    - tax_lump0;

*   家計の要素所得（要素別、税引き前）
m_bf_f0(f) = SAM("Agent","HH","Factor",f);

*   家計の要素所得（税引き前）
m_bf0 = sum(f, m_bf_f0(f));

*   家計の所得
m0 = m_bf0 + sum(i, p_d0(i)*end_hh0(i)) - sum(f, tax_inc0(f)) + tax_lump0
;

*   消費に支出される所得（所得 - 国内貯蓄 + 海外からの投資）
m_d0 = m0 - SAM("Oth","INV","Agent","HH") + SAM("Agent","ROW","Agent","HH");

display ts0, tax_f0, tax_out0, tax_inc0, tax_imp0, tax_con0, tax_all0,
        tax_lump0, m_gov0, m_bf_f0, m_bf0, m0, m_d0;

$ontext
+ 税率を表すパラメータ。
$offtext
parameter
    rt_c(i)     消費に対する従価税率
    rt_f(f,j)   生産要素の投入に対する従価税率
    rt_inc(f)   所得税率
    rt_m(i)     関税率
    rt_y(j)     生産に対する従価税率
    rt_c0(i)    消費に対する従価税率（初期値）
    rt_f0(f,j)  生産要素の投入に対する従価税率（初期値）
    rt_inc0(f)  所得税率（初期値）
    rt_m0(i)    関税率（初期値）
    rt_y0(j)    生産に対する従価税率（初期値）
;
*   SAM より計算
rt_c0(i)$t_u0(i) = tax_con0(i) / t_u0(i);
rt_f0(f,j)$t_f0(f,j) = tax_f0(f,j) / t_f0(f,j);
rt_inc0(f) = tax_inc0(f) / m_bf_f0(f);
rt_m0(i)$x_m0(i) = tax_imp0(i) / x_m0(i);
rt_y0(j)$y0(j) = tax_out0(j) / (r_y0(j)*y0(j));
display rt_c0, rt_f0, rt_inc0, rt_m0, rt_y0;

rt_c(i) = rt_c0(i);
rt_f(f,j) = rt_f0(f,j);
rt_inc(f) = rt_inc0(f);
rt_m(i) = rt_m0(i);
rt_y(j) = rt_y0(j);
display rt_c, rt_f, rt_inc, rt_m, rt_y;

*   --------------------------------------------------------------
*   単位費用の初期値

*   生産の単位費用
c0(j) = (1 - rt_y0(j)) * r_y0(j);

*   合成生産要素生産の単位費用
c_va0(j) = p_va0(j);

*   効用生産の単位費用
c_u0 = p_u0;

*   Armington統合の単位費用
c_a0(i) = p_a0(i);

*   投資財生産の単位費用
c_inv0 = p_inv0;

*   政府消費財生産の単位費用
c_gov0 = p_gov0;

display c0, c_va0, c_u0, c_a0, c_inv0, c_gov0;

*   --------------------------------------------------------------
*   代替の弾力性パラメータ
$ontext
+ 生産関数、効用関数の中の代替の弾力性 (elasticity of substitution,
  EOS) も外生的に設定する。
+ 1と0（つまり、Cobb-DouglasとLeontief型）には設定できないので注意。
+ Armington 弾力性と変形の弾力性も。
$offtext
parameter
    sig_v(j)    生産要素間のEOS
    sig_c       消費におけるEOS
    sig_dm(i)   Armington 弾力性
    eta_de(i)   国内供給と輸出供給の間の変形の弾力性
;
sig_v(j) = 0.5;
sig_c = 0.2;
display sig_v, sig_c;

*   どちらも4にしておく。
sig_dm(i) = 4;
eta_de(i) = 4;
display sig_dm, eta_de;

*   --------------------------------------------------------------
*   生産関数・効用関数のパラメータ
$ontext
+ 生産関数、効用関数内のウェイトパラメータの宣言。
+ これをカリブレートする。
$offtext
parameter
    beta_v(f,j)     生産関数のウェイトパラメータ
    gamma(i)        効用関数のウェイトパラメータ
    alpha_ad(i)     Armington統合関数内のウェイトパラメータ
    alpha_am(i)     Armington統合関数内のウェイトパラメータ
    delta_es(i)     CET関数内のウェイトパラメータ
    delta_ds(i)     CET関数内のウェイトパラメータ
;
*   --------------------------------------------------------------
*   カリブレーション
$ontext
+ カリブレーションについては Part 8 で説明。
+ カリブレーションは Agent 価格でおこなう。
$offtext
beta_v(f,j) = (a_f0(f,j))**(1/sig_v(j)) * (1+rt_f0(f,j))*p_f0(f) / c_va0(j);
gamma(i)$a_d0(i) = (a_d0(i))**(1/sig_c) * (1+rt_c0(i))*p_a0(i) / c_u0;
option beta_v:8, gamma:8;
display beta_v, gamma;

alpha_ad(i) = (a_ad0(i))**(1/sig_dm(i)) * p_d0(i) / c_a0(i);
alpha_am(i) = (a_am0(i))**(1/sig_dm(i)) * (1+rt_m0(i))*p_m0(i) / c_a0(i);
delta_es(i)$a_es0(i) = p_e0(i) / (r_de0(i) * (a_es0(i))**(1/eta_de(i)));
delta_ds(i)$a_ds0(i) = p_d0(i) / (r_de0(i) * (a_ds0(i))**(1/eta_de(i)));

option alpha_ad:8, alpha_am:8, delta_es:8, delta_ds:8;
display alpha_ad, alpha_am, delta_es, delta_ds;

*   --------------------------------------------------------------
*   外生変数

*   投資を固定するモデル用
parameter
    q_inv_bar   外生的な投資量
    q_inv_bar0  外生的な投資量
;
q_inv_bar0 = q_inv0;
q_inv_bar = q_inv_bar0;
display q_inv_bar0;

*   政府消費を固定するモデル用
parameter
    q_gov_bar   外生的な政府消費量
    q_gov_bar0  外生的な政府消費量（初期値）
;
q_gov_bar0 = q_gov0;
q_gov_bar = q_gov_bar0;
display q_gov_bar0;

*   貿易収支を固定するモデル用
parameter
    ts_bar  外生的な貿易収支
    ts_bar0 外生的な貿易収支
;
ts_bar = ts0;
ts_bar0 = ts_bar;
display ts_bar0;

*   一括トランスファーの値
$ontext
tax_lump0 の値はプラスだが、トランスファーは場合によってはマイナスにもなる。その
場合は、一括の税ということ。

$offtext
parameter
    tax_lump_bar    外生的な一括トランスファー
    tax_lump_bar0   外生的な一括トランスファー（初期値）
;
tax_lump_bar0 = tax_lump0;
tax_lump_bar = tax_lump_bar0;
display tax_lump_bar0;

*   --------------------------------------------------------------
*   変数の宣言
variables
    c(j)        生産の単位費用
    c_va(j)     合成生産要素生産の単位費用
    c_u         効用生産の単位費用
    c_a(i)      Armington統合の単位費用
    c_inv       投資財生産の単位費用
    c_gov       政府消費財生産の単位費用
    r_y(j)      生産の単位収入
    r_de(i)     輸出・国内供給配分活動の単位収入
    x_e(i)      輸出量
    x_m(i)      輸入量
    y(j)        生産水準
    v_a(j)      合成生産要素
    y_de(i)     輸出・国内供給配分活動
    u           効用の生産量
    q_a(i)      Armington統合
    q_inv       投資財の生産量
    q_gov       政府消費財の生産量
    p_y(i)      生産物価格
    p_d(i)      国内財の価格
    p_e(i)      輸出財の価格
    p_m(i)      輸入財の価格
    p_a(i)      Armington財の価格
    p_va(j)     合成生産要素の価格
    p_f(f)      生産要素の価格
    p_u         効用の価格
    p_inv       投資財の価格
    p_gov       政府消費財の価格
    p_ex        為替レート（外貨の価格）
    ts          貿易収支
    tax_all     税収
    tax_lump    一括トランスファー
    m_gov       政府の所得
    m_bf        家計の要素所得（税引き前）
    m           家計の所得（税引き後）
    m_d         消費に支出される所得
;
*   --------------------------------------------------------------
*   式の宣言
equations
    e_c(j)      生産の単位費用
    e_c_va(j)   合成生産要素生産の単位費用
    e_c_u       効用生産の単位費用
    e_c_a(i)    Armington統合の単位費用
    e_c_inv     投資財生産の単位費用
    e_c_gov     政府消費財生産の単位費用
    e_r_y(j)    生産の単位収入
    e_r_de(i)   輸出・国内供給配分活動の単位収入
    e_x_e(i)    輸出量
    e_x_m(i)    輸入量
    e_y(j)      生産水準
    e_v_a(j)    合成生産要素
    e_y_de(i)   輸出・国内供給配分活動
    e_u         効用の生産量
    e_q_a(i)    Armington統合
    e_q_inv     投資財の生産量
    e_q_gov     政府消費財の生産量
    e_p_y(i)    生産物価格
    e_p_d(i)    国内財の価格
    e_p_e(i)    輸出財の価格
    e_p_m(i)    輸入財の価格
    e_p_a(i)    Armington財の価格
    e_p_va(j)   合成生産要素の価格
    e_p_f(f)    生産要素の価格
    e_p_u       効用の価格
    e_p_inv     投資財の価格
    e_p_gov     政府消費財の価格
    e_p_ex      為替レート（外貨の価格）
    e_ts        貿易収支
    e_tax_all   税収
    e_tax_lump  一括トランスファー
    e_m_gov     政府の所得
    e_m_bf      家計の要素所得（税引き前）
    e_m         家計の所得（税引き後）
    e_m_d       消費に支出される所得
;
*   --------------------------------------------------------------
*   式の定義
$ontext
式の定義については解説書の方を参照。

$offtext
*   ------------------------------------------------------------
*   単位費用・単位収入の定義

*   生産の単位費用
e_c(j)$y0(j) ..
    c0(j)*c(j) =e=
    sum(i$a_x0(i,j), p_a0(i)*p_a(i)*a_x0(i,j)) + p_va0(j)*p_va(j)*a_v0(j);

*   合成生産要素生産の単位費用
e_c_va(j) ..
    c_va0(j)*c_va(j) =e=
    (sum(f, beta_v(f,j)**sig_v(j)
    * ((1+rt_f(f,j))*p_f0(f)*p_f(f))**(1-sig_v(j))))**(1/(1-sig_v(j)));

*   効用生産の単位費用
e_c_u ..
    c_u0*c_u =e=
    (sum(i$a_d0(i),
    (gamma(i))**(sig_c) * ((1+rt_c(i))*p_a0(i)*p_a(i))**(1-sig_c))
    )**(1/(1-sig_c));

*   Armington統合の単位費用
e_c_a(i)$q_a0(i) ..
    c_a0(i)*c_a(i) =e=
    ((alpha_ad(i)**(sig_dm(i))
    * (p_d0(i)*p_d(i))**(1-sig_dm(i)))$a_ad0(i)
    + (alpha_am(i)**(sig_dm(i))
        * ((1+rt_m(i))*p_m0(i)*p_m(i))**(1-sig_dm(i)))$a_am0(i)
    )**(1/(1-sig_dm(i)));

*   投資財生産の単位費用
e_c_inv ..
    c_inv0*c_inv =e=
    sum(i$a_inv0(i), p_a0(i)*p_a(i) * a_inv0(i));

*   政府消費財生産の単位費用
e_c_gov ..
    c_gov0*c_gov =e= sum(i$a_gov0(i), p_a0(i)*p_a(i) * a_gov0(i));

*   生産の単位収入
e_r_y(j)$y0(j) ..
    r_y0(j)*r_y(j) =e= sum(i$a_y0(i,j), p_y0(i)*p_y(i)*a_y0(i,j));

*   輸出・国内供給配分活動の単位収入
e_r_de(i) ..
    r_de0(i)*r_de(i) =e=
    ((delta_es(i)**(-eta_de(i))
    * (p_e0(i)*p_e(i))**(1+eta_de(i)))$a_es0(i)
    + (delta_ds(i)**(-eta_de(i))
        * (p_d0(i)*p_d(i))**(1+eta_de(i)))$a_ds0(i)
    )**(1/(1+eta_de(i)));

*   ------------------------------------------------------------
*   利潤最大化条件

*   輸出量
e_x_e(i)$x_e0(i) .. p_e0(i)*p_e(i) =e= p_ex0*p_ex * p_ew0(i);

*   輸入量
e_x_m(i)$x_m0(i) .. p_ex0*p_ex * p_mw0(i) =e= p_m0(i)*p_m(i);

*   生産水準
e_y(j)$y0(j) .. c0(j)*c(j) =e= (1 - rt_y(j)) * r_y0(j)*r_y(j);

*   合成生産要素
e_v_a(j) .. c_va0(j)*c_va(j) =e= p_va0(j)*p_va(j);

*   輸出・国内供給配分活動
e_y_de(i)$y_de0(i) .. p_y0(i)*p_y(i) =e= r_de0(i)*r_de(i);

*   効用の生産量
e_u .. c_u0*c_u =e= p_u0*p_u;

*   Armington統合
e_q_a(i) .. c_a0(i)*c_a(i) =e= p_a0(i)*p_a(i);

*   投資財の生産量
e_q_inv .. c_inv0*c_inv =e= p_inv0*p_inv;

*   政府消費財の生産量
e_q_gov .. c_gov0*c_gov =e= p_gov0*p_gov;

*   ------------------------------------------------------------
*   単位需要・単位供給
$ontext
+ GAMS の demo version では変数の数に制限がある。
+ 全ての変数を文字通り「変数（variable）」として定義すると demo
  version の GAMS では解けない可能性が高い。
+ そこで、変数を減らすために macro の機能を利用する。
+ macro として定義したものは形式上は変数のように扱えるが、実際には変数
  ではないので、変数の数を減らすことができる。
+ 単位需要を表す変数を macro を利用して表現する。

マクロによって定義する変数

a_f(f,j)    単位生産要素需要
a_d(i)      単位消費需要
a_ad(i)     Armington統合の単位国内財需要
a_am(i)     Armington統合の単位輸入財需要
a_es(i)     単位輸出供給
a_ds(i)     単位国内供給
$offtext

*   単位生産要素需要
$macro a_f(f,j)  ((beta_v(f,j) * c_va0(j)*c_va(j) \
    / ((1+rt_f(f,j))*p_f0(f)*p_f(f)))**(sig_v(j)))

*   単位消費需要
$macro a_d(i)  ((gamma(i) * c_u0*c_u / ((1+rt_c(i))*p_a0(i)*p_a(i)))**(sig_c))

*   Armington統合の単位国内財需要
$macro a_ad(i)  ((alpha_ad(i) * c_a0(i)*c_a(i) / (p_d0(i)*p_d(i)))**(sig_dm(i)))

*   Armington統合の単位輸入財需要
$macro a_am(i)  ((alpha_am(i) * c_a0(i)*c_a(i) / ((1+rt_m(i))*p_m0(i)*p_m(i)))**(sig_dm(i)))

*   単位輸出供給
$macro a_es(i)  ((p_e0(i)*p_e(i) / (delta_es(i) * r_de0(i)*r_de(i)))**(eta_de(i)))

*   単位国内供給
$macro a_ds(i) ((p_d0(i)*p_d(i) / (delta_ds(i) * r_de0(i)*r_de(i)))**(eta_de(i)))

*   ------------------------------------------------------------
*   市場均衡条件

*   生産物価格
e_p_y(i)$y_de0(i) .. sum(j$a_y0(i,j), a_y0(i,j)*y0(j)*y(j)) =e= y_de0(i)*y_de(i);

*   国内財の価格
e_p_d(i)$a_ad0(i) .. a_ds(i) * y_de0(i)*y_de(i) + end_hh(i) =e= a_ad(i)*q_a0(i)*q_a(i);

*   輸出財の価格
e_p_e(i)$x_e0(i) .. a_es(i) * y_de0(i)*y_de(i) =e= x_e0(i)*x_e(i);

*   輸入財の価格
e_p_m(i)$x_m0(i) .. x_m0(i)*x_m(i) =e= a_am(i) * q_a0(i)*q_a(i);

*   Armington財の市場均衡
e_p_a(i) .. q_a0(i)*q_a(i) =e=
        sum(j$a_x0(i,j), a_x0(i,j)*y0(j)*y(j))
        + (a_d(i)*u0*u)$a_d0(i)
        + (a_inv0(i)*q_inv0*q_inv)$a_inv0(i)
        + (a_gov0(i)*q_gov0*q_gov)$a_gov0(i);

*   合成生産要素の市場均衡
e_p_va(j) .. v_a0(j)*v_a(j) =e= a_v0(j)*y0(j)*y(j);

*   生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(j$a_f0(f,j), a_f(f,j)*v_a0(j)*v_a(j));

*   効用の市場均衡
e_p_u ..    p_u0*p_u * u0*u =e= m_d;

*   投資財の市場均衡
e_p_inv .. q_inv0*q_inv - q_inv_bar =e= 0;

*   政府消費財の市場均衡
e_p_gov .. q_gov0*q_gov =e= m_gov / (p_gov0*p_gov);

*   貿易収支の定義
e_ts .. ts =e= sum(i$x_e0(i), p_ew0(i)*x_e0(i)*x_e(i))
    - sum(i$x_m0(i), p_mw0(i)*x_m0(i)*x_m(i));

*   外貨の市場均衡（貿易収支）
e_p_ex .. ts - ts_bar =e= 0;

*   ------------------------------------------------------------
*   所得の定義

*   税収（一括税以外）
e_tax_all ..
    tax_all =e=
    sum((f,j)$a_f0(f,j),
    rt_f(f,j)*p_f0(f)*p_f(f)*a_f(f,j)*v_a0(j)*v_a(j))
    + sum(i$x_m0(i), rt_m(i)*p_m0(i)*p_m(i)*x_m0(i)*x_m(i))
    + sum(i$a_d0(i), rt_c(i)*p_a0(i)*p_a(i)*a_d(i)*u0*u)
    + sum(j$y0(j), rt_y(j)*r_y0(j)*r_y(j)*y0(j)*y(j))
    + sum(f$v_bar(f), rt_inc(f)*p_f0(f)*p_f(f)*v_bar(f));

*   家計の要素所得（税引き前）
e_m_bf .. m_bf =e= sum(f, p_f0(f)*p_f(f)*v_bar(f));

*   家計の所得（税引き後）
e_m .. m =e= sum(f, (1-rt_inc(f))*p_f0(f)*p_f(f)*v_bar(f))
       + sum(i, p_d0(i)*p_d(i)*end_hh(i))
       + p_gov0*p_gov*tax_lump;

*   政府の所得
e_m_gov .. m_gov =e= tax_all - p_gov0*p_gov*tax_lump;

*   消費に支出される所得
e_m_d .. m_d =e= m - p_inv0*p_inv*q_inv0*q_inv - p_ex0*p_ex*ts;

*   ------------------------------------------------------------
*   その他

*   一括税
e_tax_lump .. q_gov0*q_gov =e= q_gov_bar;

*   --------------------------------------------------------------
*   モデルの宣言
$ontext
+ MCPタイプのモデルとしてモデルを定義する。
+ 各式に対してその式に対応する変数を指定する。
$offtext

model japan_model 日本のCGEモデル
      / e_c.c, e_c_va.c_va, e_c_u.c_u, e_c_a.c_a, e_c_inv.c_inv,
    e_c_gov.c_gov, e_r_y.r_y, e_r_de.r_de, e_x_e.x_e, e_x_m.x_m,
    e_y.y, e_v_a.v_a, e_y_de.y_de, e_u.u, e_q_a.q_a,
    e_q_inv.q_inv, e_q_gov.q_gov, e_p_y.p_y,
    e_p_d.p_d, e_p_e.p_e, e_p_m.p_m, e_p_a.p_a, e_p_va.p_va,
    e_p_f.p_f, e_p_u.p_u, e_p_inv.p_inv, e_p_gov.p_gov, e_ts.ts,
    e_p_ex.p_ex, e_tax_all.tax_all, e_m_bf.m_bf, e_m.m,
    e_m_gov.m_gov, e_m_d.m_d, e_tax_lump.tax_lump /;

*   --------------------------------------------------------------
*   変数の下限値
$ontext
+ 価格変数については0ではない非常に小さい値（ここでは1e-6）を指定
+ 貿易収支 ts はマイナスの値なので制約を付けない。
+ 一括トランスファーもマイナスの値になる可能性があるので制約を付けない。

$offtext

c.lo(j) = 1e-6;
c_va.lo(j) = 1e-6;
c_u.lo = 1e-6;
c_a.lo(i) = 1e-6;
c_inv.lo = 1e-6;
c_gov.lo = 1e-6;
r_y.lo(j) = 1e-6;
r_de.lo(i) = 1e-6;
x_e.lo(i) = 0;
x_m.lo(i) = 0;
y.lo(j) = 0;
v_a.lo(j) = 0;
y_de.lo(i) = 0;
u.lo = 0;
q_a.lo(i) = 0;
q_inv.lo = 0;
q_gov.lo = 0;
p_y.lo(i) = 1e-6;
p_d.lo(i) = 1e-6;
p_e.lo(i) = 1e-6;
p_m.lo(i) = 1e-6;
p_a.lo(i) = 1e-6;
p_va.lo(j) = 1e-6;
p_f.lo(f) = 1e-6;
p_u.lo = 1e-6;
p_inv.lo = 1e-6;
p_gov.lo = 1e-6;
p_ex.lo = 1e-6;
ts.lo = -inf;
tax_all.lo = 0;
tax_lump.lo = -inf;
m_gov.lo = 0;
m_bf.lo = 0;
m.lo = 0;
m_d.lo = 0;

*   --------------------------------------------------------------
*   変数の初期値
$ontext
+ ここで指定した値がモデルを解く際の変数の初期値として利用される。
+ （一部を除き）変数の初期値が 1 になるように規準化しているので初期値
  は 1。
$offtext

c.l(j) = 1;
c_va.l(j) = 1;
c_u.l = 1;
c_a.l(i) = 1;
c_inv.l = 1;
c_gov.l = 1;
r_y.l(j) = 1;
r_de.l(i) = 1;
x_e.l(i) = 1;
x_m.l(i) = 1;
y.l(j) = 1;
v_a.l(j) = 1;
y_de.l(i) = 1;
u.l = 1;
q_a.l(i) = 1;
q_inv.l = 1;
q_gov.l = 1;
p_y.l(i) = 1;
p_d.l(i) = 1;
p_e.l(i) = 1;
p_m.l(i) = 1;
p_a.l(i) = 1;
p_va.l(j) = 1;
p_f.l(f) = 1;
p_u.l = 1;
p_inv.l = 1;
p_gov.l = 1;
p_ex.l = 1;
ts.l = ts0;
tax_all.l = tax_all0;
tax_lump.l = tax_lump0;
m_gov.l = m_gov0;
m_bf.l = m_bf0;
m.l = m0;
m_d.l = m_d0;

*   --------------------------------------------------------------
*   ニュメレールの指定
$ontext
とりあえず、p_d("agr") を固定。
$offtext
p_d.fx("agr") = p_d0("agr");

*   --------------------------------------------------------------
*   Benchmark replication
option mcp = path;
japan_model.iterlim = 0;
solve japan_model using mcp;

*   --------------------------------------------------------------
*   Clean-up calculation
japan_model.iterlim = 100000;
solve japan_model using mcp;

*   --------------------------------------------------------------
*   シミュレーション
$ontext
以下で様々なシミュレーションをおこなう。

+ シナリオについては解説書を見て欲しい。
$offtext

set scn_all 全てのシナリオ /
    bnch    "基準均衡"
    nume    "ニュメレール"
    prop    "比例的ショック"
    cont    "消費税の増税"
    linc    "労動所得税の増税"
    labi    "労動の賦存量の増加"
    prdt    "生産税の増税"
    elyt    "ELYへの生産税の増税"
    rmtx    "（一括税）以外の撤廃"
    ftrd    "貿易自由化"
    prop_    "比例的ショック"
    /
    scn(scn_all) 実行するシナリオ /
    bnch    "基準均衡"
    nume    "ニュメレール"
    prop    "比例的ショック"
    cont    "消費税の増税"
    linc    "労動所得税の増税"
    labi    "労動の賦存量の増加"
    prdt    "生産税の増税"
    elyt    "ELYへの生産税の増税"
    rmtx    "（一括税）以外の撤廃"
    ftrd    "貿易自由化"
*     prop_    "比例的ショック"
    /
    c_scn(scn_all)  現在のシナリオ
;
c_scn(scn_all) = no;
display scn;

set ele 出力する変数のインデックス
    / u, q_inv, q_gov, pricon, invest, govcon, export, import,
      tot, ts, m_d, gdp /;

*   chk_walras はワルラス法則をチェックするためのパラメータ。
parameter
    chk_walras;

*   結果を表示するためのパラメータ
parameter
    results         結果を表示するためのパラメータ
    results_y       生産量
    results_pc      "結果（変化率，%）"
    results_y_pc    生産量の変化率（%）
;
*   計算結果をまとめるためのマクロ
$macro calc_results(scn) \
    chk_walras(scn) = round(p_d.m("agr"), 4); \
    results("u",scn) = u0*u + eps; \
    results("q_inv",scn) = q_inv0*q_inv + eps; \
    results("q_gov",scn) = q_gov0*q_gov + eps; \
    results("pricon",scn) = sum(i, (1+rt_c0(i))*p_a0(i)*a_d(i)*u0*u) + eps; \
    results("invest",scn) = sum(i, p_a0(i)*a_inv0(i)*q_inv0*q_inv) + eps; \
    results("govcon",scn) = sum(i, p_a0(i)*a_gov0(i)*q_gov0*q_gov) + eps; \
    results("export",scn) = sum(i, p_e0(i)*x_e0(i)*x_e(i)) + eps; \
    results("import",scn) = sum(i, (1+rt_m0(i))*p_m0(i)*x_m0(i)*x_m(i)) + eps; \
    results("tot",scn) = p_e0("agr")*p_e("agr") / (p_m0("agr")*p_m("agr")) + eps; \
    results("ts",scn) = ts + eps; \
    results("m_d",scn) = m_d / (p_u0*p_u) ; \
    results("gdp",scn) = \
    results("pricon",scn) + results("invest",scn) + results("govcon",scn) \
    + results("export",scn) - results("import",scn); \
    results_y(j,scn) = y0(j)*y(j); \
    abort$chk_walras(scn) "Walras' law is violated!!!", chk_walras;

$ontext
$ondotl - $offdotl 命令について

+ 通常、変数のレベル値を用いるには x.l のように「.l」サフィッスクスを付
  ける必要がある。
+ 以下でモデルを解いた後に calc_results というマクロを実行している。
+ その calc_results の中では a_d というマクロが利用されている。
+ a_d の中では変数がサフィックスなしで利用されているので、そのままでは
  エラーとなってしまう。
+ このエラーを防ぐため $ondotl-$offdotl 命令を利用する。
+ この命令の間にはさまれた領域では「.l」サフィックスなしの変数をサフィッ
  クスありと同等の扱いをする。
$offtext
*   ここから ondotl
$ondotl
*   --------------------------------------------------------------
*   Benchmark replication
option mcp = path;
japan_model.iterlim = 0;
solve japan_model using mcp;
chk_walras("bnch") = round(p_d.m("agr"), 4);
abort$chk_walras("bnch") "Walras' law is violated!!!", chk_walras;

*   --------------------------------------------------------------
*   Clean-up calculation
japan_model.iterlim = 100000;
solve japan_model using mcp;
calc_results("bnch");
abort$chk_walras("bnch") "Walras' law is violated!!!", chk_walras;

*   以下で loop を利用してシミュレーションをおこなう。
loop(scn,

*   現在のシナリオ
    c_scn(scn) = yes;
    display c_scn;

*   ここでシナリオ別の設定ファイルを読み込む。このファイルの中でシ
*   ナリオ別に設定を変更している。
$include sub_scenario_setting.gms

*   モデルを解く
    solve japan_model using mcp;

*   計算結果をまとめる
    calc_results(scn);

    c_scn(scn) = no;
);

*   ondotl はここまで
$offdotl

*   --------------------------------------------------------------
*   結果を表示

*   変化率の計算
results_pc(ele,scn)$results(ele,"bnch") =
    100 * (results(ele,scn) / results(ele,"bnch") - 1);
results_pc(ele,scn) = round(results_pc(ele,scn), 4) + eps;

results_y_pc(j,scn)$results_y(j,"bnch") =
    100 * (results_y(j,scn) / results_y(j,"bnch") - 1);
results_y_pc(j,scn) = round(results_y_pc(j,scn), 4) + eps;

display scn;
display chk_walras, results, results_y;

option results_pc:1;
display results_pc, results_y_pc;

*   gdx ファイルに結果を出力
execute_unload "japan_model_%sim_name%.gdx",
    results, results_y, results_pc, results_y_pc;


* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:
