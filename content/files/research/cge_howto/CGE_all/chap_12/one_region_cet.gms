$title 貿易のある一地域モデル
$ontext
Time-stamp:     <2022-01-20 22:57:54 st>
First-written:  <2016/03/15>

［注］ このプログラムを実行する前に data_create.gms を実行して、
chap_12_SAM_example.gdx というファイルを作成しておくこと。

CET 関数を利用するケースとしないケースの両方

$offtext

$ontext
貿易収支と為替レートに関する扱いの設定。
$offtext
parameter
    fl_fts      "貿易収支固定（為替レート可変）→これがデフォールト"
    fl_fex      "為替レート固定（貿易収支可変）"
    fl_alt      "海外への貯蓄率一定"
;
fl_fts = 1;
fl_fex = 0;
fl_alt = 0;

parameter
    fl_cet      CET関数を利用するなら1
;
fl_cet = 1;

*       --------------------------------------------------------------
*       集合の宣言
set     ct      カテゴリー      / Sector, Factor, DE, Goods, Other, Agent /
        subct                   / agr, man, ser, lab, cap, utl, hh, row /
        i(subct) 財の集合              / agr, man, ser /
        f(subct) 生産要素の集合        / lab, cap /
;
*       aliasの作成
alias(i,j), (i,ii), (f,ff);
display i, j, f;

alias (ct,ctt), (subct, subctt);

*       --------------------------------------------------------------
*       代替の弾力性パラメータ
$ontext
+ 生産関数、効用関数の中の代替の弾力性 (elasticity of substitution,
  EOS) も外生的に設定する。 
+ 1と0（つまり、Cobb-DouglasとLeontief型）には設定できないので注意。

+ Armington 弾力性と変形の弾力性を追加。
$offtext
parameter
    sig(i)      生産要素とそれ以外の投入の間のEOS
    sig_v(i)    生産要素間のEOS
    sig_c       消費におけるEOS
    sig_dm(i)   Armington 弾力性
    eta_de(i)   国内供給と輸出供給の間の変形の弾力性
;
sig(i) = 0.2;
sig_v(i) = 0.5;
sig_c = 0.2;
display sig, sig_v, sig_c;

*       どちらも4にしておく。
sig_dm(i) = 4;
eta_de(i) = 4;
display sig_dm, eta_de;

*       --------------------------------------------------------------
*       ベンチマークデータ
$ontext
SAMを読み込む。
$offtext
parameter
    SAM(ct,subct,ctt,subctt)    SAM;
;
*       gdx ファイルが存在しなければ止める。
$if not exist chap_12_SAM_example.gdx $abort

$gdxin chap_12_SAM_example.gdx
$load SAM

display SAM;

parameter
    p_ew0(i)    輸出財の世界価格
    p_mw0(i)    輸入財の世界価格
;
*       全て1と置く。
p_ew0(i) = 1;
p_mw0(i) = 1;
display p_ew0, p_mw0;

$ontext
以下は主に内生変数の初期値を入れるためのパラメータ。
$offtext
parameters
    c0(i)       生産の単位費用
    c_va0(i)    合成生産要素生産の単位費用
    c_u0        効用生産の単位費用
    c_a0(i)     Armington統合の単位費用
    r_y0(i)     生産の単位収入
    x_e0(i)     輸出量
    x_m0(i)     輸入量
    y0(i)       生産量
    v_a0(i)     合成生産要素
    u0          効用の生産量
    q_a0(i)     Armington統合
    a_x0(j,i)   単位投入需要
    a_v0(i)     単位合成生産要素需要
    a_f0(f,i)   単位生産要素需要
    a_d0(i)     単位消費需要
    a_ad0(i)    Armington統合の単位国内財需要
    a_am0(i)    Armington統合の単位輸入財需要
    a_es0(i)    単位輸出供給
    a_ds0(i)    単位国内供給
    p_d0(i)     国内財の価格
    p_a0(i)     Armington財の価格
    p_va0(i)    合成生産要素の価格
    p_f0(f)     生産要素の価格
    p_u0        効用の価格
    p_e0(i)     輸出財の価格
    p_m0(i)     輸入財の価格
    p_ex0       為替レート（外貨の価格）        
    m0          所得
    m_d0        国内に支出される所得
    t_vf0(f,i)  生産要素需要
    t_x0(j,i)   単位投入需要
    t_v0(i)     合成生産要素需要
    t_f0(f,i)   生産要素需要
    t_d0(i)     消費需要
    t_ad0(i)    Armington統合の国内財需要
    t_am0(i)    Armington統合の輸入財需要
    t_es0(i)    輸出供給
    t_ds0(i)    国内供給
    ts0         貿易収支
;
*       Harberger convention（全ての価格を1に規準化）
p_d0(i) = 1;
p_a0(i) = 1;
p_va0(i) = 1;
p_f0(f) = 1;
p_u0 = 1;
p_e0(i) = 1;
p_m0(i) = 1;
p_ex0 = 1;
r_y0(i) = 1;

display p_d0, p_a0, p_va0, p_f0, p_u0, p_e0, p_m0, p_ex0, r_y0;

*       生産量＝生産額/価格
y0(i) = sum((ct,subct), SAM(ct,subct,"Sector",i)) / r_y0(i);

*       投入需要量＝需要額/価格
t_x0(j,i) = SAM("Goods",j,"Sector",i) / p_a0(j);

*       合成生産要素需要量＝需要額/価格
v_a0(i) = sum(f, SAM("Factor",f,"Sector",i)) / p_va0(i);

*       生産要素需要量＝需要額/価格
t_vf0(f,i) = SAM("Factor",f,"Sector",i) / p_f0(f);

*       単位投入需要量＝投入需要量/生産量
a_x0(j,i) = t_x0(j,i) / y0(i);

*       単位合成生産要素需要量＝合成生産要素需要量/生産量
a_v0(i) = v_a0(i) / y0(i);

*       単位生産要素需要量＝生産要素需要量/生産量
a_f0(f,i) = t_vf0(f,i) / v_a0(i);

*       輸出供給
t_es0(i) = SAM("DE",i,"Agent","ROW") / p_e0(i);

*       国内供給
t_ds0(i) = SAM("DE",i,"Goods",i) / p_d0(i);

*       単位輸出供給
a_es0(i) = t_es0(i) / SAM("Sector",i,"DE",i);

*       単位国内供給
a_ds0(i) = t_ds0(i) / SAM("Sector",i,"DE",i);

*       輸出量
x_e0(i) = t_es0(i);

*       輸入量
x_m0(i) = SAM("Agent","ROW","Goods",i) / p_m0(i);

*       Armington統合の国内財需要
t_ad0(i) = SAM("DE",i,"Goods",i) / p_d0(i);

*       Armington統合の輸入財需要
t_am0(i) = SAM("Agent","ROW","Goods",i) / p_m0(i);

*       Armington統合
q_a0(i) = t_ad0(i) + t_am0(i);

*       Armington統合の単位国内財需要
a_ad0(i) = t_ad0(i) / q_a0(i);

*       Armington統合の単位輸入財需要
a_am0(i) = t_am0(i) / q_a0(i);

*       効用の生産量＝効用の生産額/価格
u0 = SAM("Other","utl","Agent","hh") / p_u0;

*       消費需要量＝消費需要額/価格
t_d0(i) = SAM("Goods",i,"Other","utl") / p_a0(i);

*       単位消費需要量＝消費需要量/効用
a_d0(i) = t_d0(i) / u0;

*       所得額
m0 = sum(f, SAM("Agent","hh","Factor",f));

*       国内に支出される所得
m_d0 = m0 - SAM("Agent","ROW","Agent","HH");

*       生産の単位費用
c0(i) = r_y0(i);

*       合成生産要素生産の単位費用
c_va0(i) = p_va0(i);

*       Armington統合の単位費用
c_a0(i) = p_a0(i);

*       効用生産の単位費用
c_u0 = p_u0;

*       貿易収支
ts0 = sum(i, p_ew0(i)*x_e0(i) - p_mw0(i)*x_m0(i));

display y0, t_x0, v_a0, t_vf0, a_x0, a_v0, a_f0, t_es0, t_ds0, a_es0,
        a_ds0, x_e0, x_m0, t_ad0, t_am0, q_a0, a_ad0, a_am0, u0, t_d0,
        a_d0, m0, m_d0, c0, c_va0, c_a0, c_u0, ts0;

parameter
    srate_f     海外への貯蓄率
;
srate_f = ts0 / sum(f, SAM("Agent","hh","Factor",f));
display srate_f;

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
    alpha_ad(i)         Armington統合関数内のウェイトパラメータ
    alpha_am(i)         Armington統合関数内のウェイトパラメータ
    delta_es(i)         CET関数内のウェイトパラメータ
    delta_ds(i)         CET関数内のウェイトパラメータ
;
*       --------------------------------------------------------------
*       カリブレーション
$ontext
カリブレーションについては Part 8 に説明。
$offtext
alpha_x(j,i) = (a_x0(j,i))**(1/sig(i)) * p_a0(j) / c0(i);

alpha_v(i) = (a_v0(i))**(1/sig(i)) * p_va0(i) / c0(i);

beta_v(f,i) = (a_f0(f,i))**(1/sig_v(i)) * p_f0(f) / c_va0(i);

gamma(i) = (a_d0(i))**(1/sig_c) * p_a0(i) / c_u0;

option alpha_x:8, alpha_v:8, beta_v:8, gamma:8;
display alpha_x, alpha_v, beta_v, gamma;

alpha_ad(i) = (a_ad0(i))**(1/sig_dm(i)) * p_d0(i) / c_a0(i);
alpha_am(i) = (a_am0(i))**(1/sig_dm(i)) * p_m0(i) / c_a0(i);

delta_es(i)$a_es0(i) = p_e0(i) / (r_y0(i) * (a_es0(i))**(1/eta_de(i)));
delta_ds(i)$a_ds0(i) = p_d0(i) / (r_y0(i) * (a_ds0(i))**(1/eta_de(i)));

option alpha_ad:8, alpha_am:8, delta_es:8, delta_ds:8;
display alpha_ad, alpha_am, delta_es, delta_ds;

*       --------------------------------------------------------------
*       外生変数
$ontext
+ モデルの外生変数は生産要素の賦存量。
$offtext
parameter
    v_bar(f)    生産要素の賦存量（外生的）
    v_bar0(f)   生産要素の賦存量（外生的）;

v_bar(f) = SAM("Agent","hh","Factor",f);
v_bar0(f) = v_bar(f);
display v_bar;

$ontext
+ 税率を表すパラメータ。
+ 初期値は全てゼロとする。
$offtext
parameter
    rt_c(i)     消費に対する従価税率
    rt_f(f,i)   生産要素の投入に対する従価税率
    rt_m(i)     関税率
    rt_c0(i)    消費に対する従価税率（初期値）
    rt_f0(f,i)  生産要素の投入に対する従価税率（初期値）
    rt_m0(i)    関税率（初期値）
;
*       税率の初期値はゼロとする。
rt_c0(i) = 0;
rt_f0(f,i) = 0;
rt_m0(i) = 0;

rt_c(i) = rt_c0(i);
rt_f(f,i) = rt_f0(f,i);
rt_m(i) = rt_m0(i);
display rt_c, rt_f, rt_m;

*       --------------------------------------------------------------
*       変数の宣言
variables
    c(i)        生産の単位費用
    c_va(i)     合成生産要素生産の単位費用
    c_u         効用生産の単位費用
    c_a(i)      Armington統合の単位費用
    r_y(i)      生産の単位収入
    x_e(i)      輸出量
    x_m(i)      輸入量
    y(i)        生産量
    v_a(i)      合成生産要素
    u           効用の生産量
    q_a(i)      Armington統合
    a_x(j,i)    単位投入需要
    a_v(i)      単位合成生産要素需要
    a_f(f,i)    単位生産要素需要
    a_d(i)      単位消費需要
    a_ad(i)     Armington統合の単位国内財需要
    a_am(i)     Armington統合の単位輸入財需要
    a_es(i)     単位輸出供給
    a_ds(i)     単位国内供給
    p_d(i)      国内財の価格
    p_a(i)      Armington財の価格
    p_va(i)     合成生産要素の価格
    p_f(f)      生産要素の価格
    p_u         効用の価格
    p_e(i)      輸出財の価格
    p_m(i)      輸入財の価格
    p_ex        為替レート（外貨の価格）        
    m           所得
    m_d         国内に支出される所得
    ts          貿易収支
    p(i)        財の価格
;
*       --------------------------------------------------------------
*       式の宣言
equations
    e_c(i)      生産の単位費用
    e_c_va(i)   合成生産要素生産の単位費用
    e_c_u       効用生産の単位費用
    e_c_a(i)    Armington統合の単位費用
    e_r_y(i)    生産の単位収入
    e_x_e(i)    輸出量
    e_x_m(i)    輸入量
    e_y(i)      生産量
    e_v_a(i)    合成生産要素
    e_u         効用の生産量
    e_q_a(i)    Armington統合
    e_a_x(j,i)  単位投入需要
    e_a_v(i)    単位合成生産要素需要
    e_a_f(f,i)  単位生産要素需要
    e_a_d(i)    単位消費需要
    e_a_ad(i)   Armington統合の単位国内財需要
    e_a_am(i)   Armington統合の単位輸入財需要
    e_a_es(i)   単位輸出供給
    e_a_ds(i)   単位国内供給
    e_p_d(i)    国内財の価格
    e_p_a(i)    Armington財の価格
    e_p_va(i)   合成生産要素の価格
    e_p_f(f)    生産要素の価格
    e_p_u       効用の価格
    e_p_e(i)    輸出財の価格
    e_p_m(i)    輸入財の価格
    e_p_ex      為替レート（外貨の価格）        
    e_m         所得
    e_m_d       国内に支出される所得
    e_ts        貿易収支
    e_p(i)      財の価格
;
*       --------------------------------------------------------------
*       式の定義
$ontext
式の定義については解説書の方を参照。
$offtext

*       ------------------------------------------------------------
*       単位費用・単位収入の定義

*       生産の単位費用
e_c(i) .. c(i) =e=
          (sum(j, alpha_x(j,i)**sig(i) * p_a(j)**(1-sig(i)))
              + alpha_v(i)**sig(i) * p_va(i)**(1-sig(i)))**(1/(1-sig(i)));

*       合成生産要素生産の単位費用
e_c_va(i) .. c_va(i) =e=
             (sum(f, beta_v(f,i)**sig_v(i)
                 * ((1+rt_f(f,i))*p_f(f))**(1-sig_v(i))))**(1/(1-sig_v(i)));

*       効用生産の単位費用
e_c_u .. c_u =e=
        (sum(i,
            (gamma(i))**(sig_c) * ((1+rt_c(i))*p_a(i))**(1-sig_c))
        )**(1/(1-sig_c));

*       Armington統合の単位費用
e_c_a(i) .. c_a(i) =e=
            ((alpha_ad(i)**(sig_dm(i)) * (p_d(i))**(1-sig_dm(i)))$a_ad0(i)
                + (alpha_am(i)**(sig_dm(i)) * ((1+rt_m(i))*p_m(i))**(1-sig_dm(i)))$a_am0(i)
            )**(1/(1-sig_dm(i)));

*       生産の単位収入
e_r_y(i) ..

    (r_y(i) -
        ((delta_es(i)**(-eta_de(i)) * (p_e(i))**(1+eta_de(i)))$a_es0(i)
            + (delta_ds(i)**(-eta_de(i)) * (p_d(i))**(1+eta_de(i)))$a_ds0(i)
        )**(1/(1+eta_de(i))))$fl_cet

    + (r_y(i) - p_d(i))$(not fl_cet) =e= 0;

*       ------------------------------------------------------------
*       利潤最大化条件

*       輸出活動の利潤最大化条件
e_x_e(i)$x_e0(i) ..

    p_e(i) =g= p_ex * p_ew0(i);

*       輸入活動の利潤最大化条件
e_x_m(i)$x_m0(i) ..

    p_ex * p_mw0(i) =g= p_m(i);
    
*       生産における利潤最大化条件
e_y(i) .. c(i) =e= r_y(i)$fl_cet + p(i)$(not fl_cet);

*       生産要素合成における利潤最大化条件
e_v_a(i) .. c_va(i) =e= p_va(i);
            
*       効用生産における利潤最大化条件
e_u .. c_u =e= p_u;

*       Armington統合における利潤最大化条件
e_q_a(i) .. c_a(i) =e= p_a(i);

*       ------------------------------------------------------------
*       単位需要・単位供給

*       単位投入需要
e_a_x(j,i) ..
          a_x(j,i) =e= (alpha_x(j,i) * c(i) / p_a(j))**(sig(i));

*       単位合成生産要素需要
e_a_v(i) .. a_v(i) =e= (alpha_v(i) * c(i) / p_va(i))**(sig(i));

*       単位生産要素需要
e_a_f(f,i) ..
          a_f(f,i) =e=
              (beta_v(f,i) * c_va(i) / ((1+rt_f(f,i))*p_f(f)))**(sig_v(i));

*       単位消費需要
e_a_d(i) .. a_d(i) =e= 
          (gamma(i) * c_u / ((1+rt_c(i))*p_a(i)))**(sig_c);

*       Armington統合の単位国内財需要
e_a_ad(i) .. a_ad(i) =e=
             (alpha_ad(i) * c_a(i) / p_d(i))**(sig_dm(i));

*       Armington統合の単位輸入財需要
e_a_am(i) .. a_am(i) =e=
             (alpha_am(i) * c_a(i) / ((1+rt_m(i))*p_m(i)))**(sig_dm(i));

*       単位輸出供給
e_a_es(i)$(fl_cet and a_es0(i)) ..

    a_es(i) =e= (p_e(i) / (delta_es(i) * r_y(i)))**(eta_de(i));
    
*       単位国内供給
e_a_ds(i)$(fl_cet and a_ds0(i)) ..

     a_ds(i) =e= (p_d(i) / (delta_ds(i) * r_y(i)))**(eta_de(i));

*       ------------------------------------------------------------
*       市場均衡条件

*       国内財の市場均衡
e_p_d(i) ..

    (a_ds(i) * y(i) - a_ad(i) * q_a(i))$fl_cet
    + (p_d(i) - p(i))$(not fl_cet) =e= 0;

*       Armington財の市場均衡
e_p_a(i) .. q_a(i) =e= sum(j$a_x0(i,j), a_x(i,j) * y(j)) + a_d(i) * u;
    
*       合成生産要素の市場均衡
e_p_va(i) .. v_a(i) =e= a_v(i)*y(i);

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*v_a(i));

*       効用の市場均衡
e_p_u ..    u =e= m_d / p_u;

*       輸出財の市場均衡
e_p_e(i)$x_e0(i) ..

    (a_es(i) * y(i) - x_e(i))$fl_cet  + (p_e(i) - p(i))$(not fl_cet) =e= 0;

*       輸入財の市場均衡
e_p_m(i)$x_m0(i) .. x_m(i) =e= a_am(i) * q_a(i);

*       財の価格
e_p(i)$(not fl_cet) ..

    y(i) =e= a_ad(i) * q_a(i) + x_e(i)$x_e0(i);

*       貿易収支の定義
e_ts .. ts =e= sum(i$x_e0(i), p_ew0(i)*x_e(i)) - sum(i$x_m0(i), p_mw0(i)*x_m(i));

*       外貨の市場均衡（貿易収支）
e_p_ex .. (ts - ts0)$fl_fts + (p_ex / p_u - 1)$fl_fex
          + (p_ex * ts - srate_f * m)$fl_alt
          =e= 0;

*       ------------------------------------------------------------
*       所得の定義

e_m .. m =e= sum(f, p_f(f)*v_bar(f))
             + sum((f,i), rt_f(f,i)*p_f(f)*a_f(f,i)*v_a(i))
             + sum(i, rt_c(i)*p_a(i)*a_d(i)*u)
             + sum(i$x_m0(i), rt_m(i)*p_m(i)*x_m(i));

e_m_d .. m_d =e= m - p_ex * (ts0$fl_fts + ts$fl_fex + ts$fl_alt);

*       --------------------------------------------------------------
*       モデルの宣言
$ontext
+ MCPタイプのモデルとしてモデルを定義する。
+ 各式に対してその式に対応する変数を指定する。
$offtext

model one_region One region trade model / e_c.c, e_c_va.c_va,
      e_c_u.c_u, e_c_a.c_a, e_r_y.r_y, e_x_e.x_e, e_x_m.x_m, e_y.y,
      e_v_a.v_a, e_u.u, e_q_a.q_a, e_a_x.a_x, e_a_v.a_v, e_a_f.a_f,
      e_a_d.a_d, e_a_ad.a_ad, e_a_am.a_am, e_a_es.a_es, e_a_ds.a_ds,
      e_p_d.p_d, e_p_a.p_a, e_p_va.p_va, e_p_f.p_f, e_p_u.p_u,
      e_p_e.p_e, e_p_m.p_m, e_p_ex.p_ex, e_ts.ts, e_m.m, e_m_d.m_d, e_p.p /;

*       --------------------------------------------------------------
*       変数の下限値
$ontext
本来は全ての変数について下限値は0であるが、価格変数については0ではない
非常に小さい値（ここでは1e-6）を指定しておく。価格変数についてはモデル
において分母に入ってくる部分があり、下限を0に指定すると計算の途中におい
て価格が0になる場合があり、その際「division by zero」エラーが生じてしま
うため。

+ 貿易収支 ts はマイナスの値となってもいいので制約を付けない。

$offtext
*       数量を表す変数の下限は0とする。
x_e.lo(i) = 0;
x_m.lo(i) = 0;
y.lo(i) = 0;
v_a.lo(i) = 0;
u.lo = 0;
q_a.lo(i) = 0;
a_x.lo(j,i) = 0;
a_v.lo(i) = 0;
a_f.lo(f,i) = 0;
a_d.lo(i) = 0;
a_ad.lo(i) = 0;
a_am.lo(i) = 0;
a_es.lo(i) = 0;
a_ds.lo(i) = 0;

*       価格変数については下限を0ではない0に非常に近い値にする。
c.lo(i) = 1e-6;
c_va.lo(i) = 1e-6;
c_u.lo = 1e-6;
c_a.lo(i) = 1e-6;
r_y.lo(i) = 1e-6;
p_d.lo(i) = 1e-6;
p_a.lo(i) = 1e-6;
p_va.lo(i) = 1e-6;
p_f.lo(f) = 1e-6;
p_u.lo = 1e-6;
p_e.lo(i) = 1e-6;
p_m.lo(i) = 1e-6;
p_ex.lo = 1e-6;
p.lo(i) = 1e-6;

m.lo = 0;
m_d.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値
$ontext
ここで指定した値がモデルを解く際の変数の初期値として利用される。
$offtext

c.l(i) = c0(i);
c_va.l(i) = c_va0(i);
c_u.l = c_u0;
c_a.l(i) = c_a0(i);
r_y.l(i) = r_y0(i);
x_e.l(i) = x_e0(i);
x_m.l(i) = x_m0(i);
y.l(i) = y0(i);
v_a.l(i) = v_a0(i);
u.l = u0;
q_a.l(i) = q_a0(i);
a_x.l(j,i) = a_x0(j,i);
a_v.l(i) = a_v0(i);
a_f.l(f,i) = a_f0(f,i);
a_d.l(i) = a_d0(i);
a_ad.l(i) = a_ad0(i);
a_am.l(i) = a_am0(i);
a_es.l(i) = a_es0(i);
a_ds.l(i) = a_ds0(i);
p_d.l(i) = p_d0(i);
p_a.l(i) = p_a0(i);
p_va.l(i) = p_va0(i);
p_f.l(f) = p_f0(f);
p_u.l = p_u0;
p_e.l(i) = p_e0(i);
p_m.l(i) = p_m0(i);
p_ex.l = p_ex0;
p.l(i) = p_d.l(i);
m.l = m0;
m_d.l = m_d0;
ts.l = ts0;

*       --------------------------------------------------------------
*       ニュメレールの指定
p_d.fx("agr") = 1;

parameter
    chk_walras;

*       --------------------------------------------------------------
*       Benchmark replication

option mcp = path;
one_region.iterlim = 0;
solve one_region using mcp;
chk_walras = round(p_d.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;

*       --------------------------------------------------------------
*       Clean-up calculation

one_region.iterlim = 1000;
solve one_region using mcp;
chk_walras = round(p_d.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;

parameter
    results     結果を表示するためのパラメータ
    results_pc  "結果（変化率，%）"
;

$macro calc_results(scn) \
    results("u",scn) = u.l; \
    results("tot",scn) = p_e.l("agr") / p_m.l("agr"); \
    results("y_agr",scn) = y.l("agr"); \
    results("y_man",scn) = y.l("man"); \
    results("y_ser",scn) = y.l("ser"); \
    results("c_agr",scn) = a_d.l("agr")*u.l; \
    results("c_man",scn) = a_d.l("man")*u.l; \
    results("c_ser",scn) = a_d.l("ser")*u.l; \
    results("d_agr",scn) = a_ad.l("agr")*q_a.l("agr"); \
    results("d_man",scn) = a_ad.l("man")*q_a.l("agr"); \
    results("d_ser",scn) = a_ad.l("ser")*q_a.l("agr"); \
    results("e_agr",scn)$x_e0("agr") = x_e.l("agr"); \
    results("e_man",scn)$x_e0("man") = x_e.l("man"); \
    results("e_ser",scn)$x_e0("ser") = x_e.l("ser"); \
    results("m_agr",scn)$x_m0("agr") = x_m.l("agr"); \
    results("m_man",scn)$x_m0("man") = x_m.l("man"); \
    results("m_ser",scn)$x_m0("ser") = x_m.l("ser"); \
    results("ts",scn) = ts.l; \
    results("p_d_m",scn) = p_d.m("agr"); \
    results("p_ex",scn) = p_ex.l / p_u.l; \
    results("p_d_agr",scn) = p_d.l("agr") / p_u.l; \
    results("p_d_man",scn) = p_d.l("man") / p_u.l; \
    results("p_d_ser",scn) = p_d.l("ser") / p_u.l; \
    results("p_e_agr",scn)$x_e0("agr") = p_e.l("agr") / p_u.l; \
    results("p_e_man",scn)$x_e0("man") = p_e.l("man") / p_u.l; \
    results("p_e_ser",scn)$x_e0("ser") = p_e.l("ser") / p_u.l; \
    results("p_m_agr",scn)$x_m0("agr") = p_m.l("agr") / p_u.l; \
    results("p_m_man",scn)$x_m0("man") = p_m.l("man") / p_u.l; \
    results("p_m_ser",scn)$x_m0("ser") = p_m.l("ser") / p_u.l; \
    results("p_a_agr",scn) = p_a.l("agr") / p_u.l; \
    results("p_a_man",scn) = p_a.l("man") / p_u.l; \
    results("p_a_ser",scn) = p_a.l("ser") / p_u.l; \
    results("r_y_agr",scn) = r_y.l("agr") / p_u.l; \
    results("r_y_man",scn) = r_y.l("man") / p_u.l; \
    results("r_y_ser",scn) = r_y.l("ser") / p_u.l;

calc_results("bench");

*       --------------------------------------------------------------
*       資本の賦存量が20%減少するシミュレーション
$ontext
+ 資本の賦存量は v_bar("cap") というパラメータの値で表されている。
+ これを20%減少させる
$offtext

v_bar("cap") = v_bar0("cap") * 0.8;

solve one_region using mcp;

*       元の値に戻しておく。
v_bar("cap") = v_bar0("cap");

calc_results("cap_i");

*       --------------------------------------------------------------
*       manとserに対して10%の消費税を導入するシナリオ
$ontext
+ manとserという2つの財に対して消費税を導入する政策
+ 消費税率は rt_c(i) であった。

$offtext

rt_c("man") = 0.1;
rt_c("ser") = 0.1;

solve one_region using mcp;

rt_c(i) = rt_c0(i);

calc_results("rt_c");

*       --------------------------------------------------------------
*       agr に 20% の関税導入
$ontext
+ 関税率 rt_m(i) であった。

$offtext
rt_m("agr") = 0.2;

solve one_region using mcp;

rt_m(i) = rt_m0(i);

calc_results("rt_m");

*       --------------------------------------------------------------
*       結果を表示

set ele / u, tot, y_agr, y_man, y_ser, c_agr, c_man, c_ser, d_agr,
          d_man, d_ser, e_agr, e_man, e_ser, m_agr, m_man, m_ser, ts,
          p_ex, p_d_agr, p_d_man, p_d_ser, p_e_agr, p_e_man, p_e_ser,
          p_m_agr, p_m_man, p_m_ser, p_a_agr, p_a_man, p_a_ser,
          r_y_agr, r_y_man, r_y_ser /;

set scn / bench, cap_i, rt_c, rt_m /;

results_pc(ele,scn)$results(ele,"bench") =
    100 * (results(ele,scn) / results(ele,"bench") - 1);
results_pc(ele,scn) = round(results_pc(ele,scn), 6);

display results, results_pc;

* $exit

*       ============================================================
*       以下では CET 関数を利用しないで同じシミュレーション
$ontext
+ fl_cet にゼロを設定

$offtext
fl_cet = 0;

*       --------------------------------------------------------------
*       資本の賦存量が20%減少するシミュレーション

v_bar("cap") = v_bar0("cap") * 0.8;

solve one_region using mcp;

*       元の値に戻しておく。
v_bar("cap") = v_bar0("cap");

calc_results("cap_i_ncet");

*       --------------------------------------------------------------
*       manとserに対して10%の消費税を導入するシナリオ

rt_c("man") = 0.1;
rt_c("ser") = 0.1;

solve one_region using mcp;

rt_c(i) = rt_c0(i);

calc_results("rt_c_ncet");

*       --------------------------------------------------------------
*       agr に 20% の関税導入

rt_m("agr") = 0.2;

solve one_region using mcp;

rt_m(i) = rt_m0(i);

calc_results("rt_m_ncet");

*       ------------------------------------------------------------
*       結果（まとめ）

set scn_ / cap_i_ncet, rt_c_ncet, rt_m_ncet /;

results_pc(ele,scn_)$results(ele,"bench") =
    100 * (results(ele,scn_) / results(ele,"bench") - 1);
results_pc(ele,scn_) = round(results_pc(ele,scn_), 6);

display results, results_pc;

execute_unload "one_region_cet.gdx", results, results_pc;

* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:

