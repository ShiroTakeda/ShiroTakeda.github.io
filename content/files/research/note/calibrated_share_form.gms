$title  Calibrated share formによるCES関数の表現
display "com: Calibrated share formによるCES関数の表現";
$ontext
Copyright (C)   2012 Shiro Takeda
Time-stamp: 	<2012-07-16 21:22:17 Shiro Takeda>
Author: 	Shiro Takeda <zbc08106@park.zero.ad.jp>
First-written:	<2012/07/16>

同じモデルを

* Normal formのCES関数
* Calibrated share formのCES関数

の両方を用いて記述する。

どちらも同じであることを確認する。


説明は、武田史郎、「CES関数のcalibrated share form」を参照。

$offtext

$ontext
Time-stamp: 	<2010-04-01 19:46:14 Shiro Takeda>
First-written:	<2010/03/12>

□ SAM (ベンチマークデータ)
           |         Sectors         |  Consumers 
Commoditiy |          (部門)         |   (消費者)
   (財)    |    x       y        u   |    cons
-----------------------------------------------------
       px  |  100             -100   |
       py  |          100     -100   |
       pu  |                   200   |    -200
       pl  |  -25     -75            |     100
       pk  |  -75     -25            |     100
-----------------------------------------------------


□ 生産関数

+ x部門もy部門も資本と労働のみを利用する。
+ x部門はCES関数、y部門はCobb-Douglas関数とする。

x部門
         x
        / \ <- sig_x
       /   \
      /     \
     k      l

・代替の弾力性sig_xのCES関数。

y部門
         y
        / \ <- 1
       /   \
      /     \
     k      l

・Cobb-Douglas関数．

効用関数
         y
        / \ <- sig_u
       /   \
      /     \
     k      l

・代替の弾力性sig_uのCES関数

$offtext

*	----------------------------------------------------------------------
*	ベンチマーク・データ:
display "com: ベンチマーク・データ:";

table	sam	ベンチマークデータ
          x       y        u     cons
px      100             -100    
py              100     -100    
pu                       200     -200
pl      -25     -75               100
pk      -75     -25               100
;
display sam;

parameter
    px0		x 財のベンチマーク市場価格
    py0		y 財のベンチマーク市場価格
    pu0		u 財のベンチマーク市場価格
    pk0		資本のベンチマーク市場価格
    pl0		労働のベンチマーク市場価格
;

px0 = 1;
py0 = 1;
pu0 = 1;
pk0 = 1;
pl0 = 1;
display px0, py0, pu0, pk0, pl0;

parameter
    x0		x 財のベンチマーク生産量
    y0		y 財のベンチマーク生産量
    kx0		x 部門における資本のベンチマーク投入量
    ky0		y 部門における資本のベンチマーク投入量
    lx0		x 部門における労働のベンチマーク投入量
    ly0		y 部門における労働のベンチマーク投入量
;

x0 = sam("px","x") / px0;
y0 = sam("py","y") / py0;
kx0 = - sam("pk","x") / pk0;
ky0 = - sam("pk","y") / pk0;
lx0 = - sam("pl","x") / pl0;
ly0 = - sam("pl","y") / pl0;

display x0, y0, kx0, ky0, lx0, ly0;

parameter
    u0		ベンチマークの効用水準
    cx0		x 財のベンチマーク消費量
    cy0		y 財のベンチマーク消費量
;
u0 = sam("pu","u") / pu0;
cx0 = - sam("px","u") / px0;
cy0 = - sam("py","u") / py0;

display u0, cx0, cy0;

parameter
    end_l	労働の賦存量
    end_k	資本の賦存量
    inc0	ベンチマーク所得
;
end_l = sam("pl","cons") / pl0;
end_k = sam("pk","cons") / pk0;
inc0 = - sam("pu","cons");

display end_l, end_k, inc0;

*	----------------------------------------------------------------------
*	その他のパラメータ．
display "com: その他のパラメータ．";

parameter
    sig_x	EOS: 部門 x における資本・労働の EOS	/ 0.5 /
    sig_u	EOS: 効用関数内の EOS			/ 2.0 /
;
display sig_x;

parameter
    s_l		労働賦存量のスケールファクター	/ 1.0 /
    s_k		資本賦存量のスケールファクター	/ 1.0 /
;
display s_l, s_k;

*	======================================================================
*	Normal formの（Calibrated share formを利用しない）記述
*	======================================================================
$ontext

関数形

x = (alpha_k_x*k_x**((sig_x-1)/sig_x) + alpha_l_x*l_x**((sig_x-1)/sig_x))**(sig_x/(sig_x-1))

y = phi_y * (k_y**(sh_k_y) * l_y**(sh_l_y))

u = (alpha_x_u*x**((sig_u-1)/sig_u) + alpha_y_u*y**((sig_u-1)/sig_u))**(sig_u/(sig_u-1))

$offtext

parameter
    sh_k_x	x部門の生産関数のウェイトパラメータ
    sh_l_x	x部門の生産関数のウェイトパラメータ
    sh_x_u	効用関数のウェイトパラメータ
    sh_y_u	効用関数のウェイトパラメータ

    alpha_k_x	x部門の生産関数のウェイトパラメータ
    alpha_l_x	x部門の生産関数のウェイトパラメータ

    phi_y	y部門の生産関数のスケール
    sh_k_y	y部門の生産関数のシェアパラメータ
    sh_l_y	y部門の生産関数のシェアパラメータ

    alpha_x_u	効用関数のウェイトパラメータ
    alpha_y_u	効用関数のウェイトパラメータ
;
$ontext
論文の(5)式を利用して、ウェイトパラメータを求める。
それには、ベンチマークのシェアが必要になるので、求めておく。
$offtext

sh_k_x = pk0*kx0 / (pk0*kx0 + pl0*lx0);
sh_l_x = pl0*lx0 / (pk0*kx0 + pl0*lx0);

sh_k_y = pk0*ky0 / (pk0*ky0 + pl0*ly0);
sh_l_y = pl0*ly0 / (pk0*ky0 + pl0*ly0);

sh_x_u = px0*cx0 / (px0*cx0 + py0*cy0);
sh_y_u = py0*cy0 / (px0*cx0 + py0*cy0);

display sh_k_x, sh_l_x, sh_k_y, sh_l_y, sh_x_u, sh_y_u;

*	ウェイトパラメータのcalibration (論文5式)
alpha_k_x = sh_k_x * (kx0/x0)**((1-sig_x)/sig_x);
alpha_l_x = sh_l_x * (lx0/x0)**((1-sig_x)/sig_x);

alpha_x_u = sh_x_u * (cx0/u0)**((1-sig_u)/sig_u);
alpha_y_u = sh_y_u * (cy0/u0)**((1-sig_u)/sig_u);

display alpha_k_x, alpha_l_x, alpha_x_u, alpha_y_u;

*	Cobb-Double関数のスケールパラメータのcalibration（論文の14式）
phi_y = y0 / (ky0**sh_k_y * ly0**sh_l_y);

display phi_y;

*	----------------------------------------------------------------------
*	変数の宣言

variables
    c_x		x部門の単位費用
    c_y		y部門の単位費用
    c_u		効用部門の単位費用
;

variables
    a_k_x	x部門のkへの単位需要
    a_l_x	x部門のlへの単位需要
    a_k_y	y部門のkへの単位需要
    a_l_y	y部門のlへの単位需要
    a_x_u	x財への単位消費需要
    a_y_u	y財への単位消費位需要
;

variables
    x		x部門の生産
    y		y部門の生産
    u		効用部門の生産（効用水準）
;

variables
    px		x財の価格
    py		x財の価格
    pu		効用の価格
    pk		資本の価格
    pl		労働の価格
;

variables
    inc		家計の所得
;

*	----------------------------------------------------------------------
*	式の宣言

equations
    e_c_x	x部門の単位費用
    e_c_y	y部門の単位費用
    e_c_u	効用部門の単位費用
;

equations
    e_a_k_x	x部門のkへの単位需要
    e_a_l_x	x部門のlへの単位需要
    e_a_k_y	y部門のkへの単位需要
    e_a_l_y	y部門のlへの単位需要
    e_a_x_u	x財への単位消費需要
    e_a_y_u	y財への単位消費位需要
;

equations
    e_x		x部門の生産
    e_y		y部門の生産
    e_u		効用部門の生産（効用水準）
;

equations
    e_px	x財の価格
    e_py	x財の価格
    e_pu	効用の価格
    e_pk	資本の価格
    e_pl	労働の価格
;

equations
    e_inc	家計の所得
;

*	単位費用（論文の2式）
e_c_x .. c_x =e= (alpha_k_x**sig_x * pk**(1-sig_x) + alpha_l_x**sig_x * pl**(1-sig_x))**(1/(1-sig_x));

*	こちらはCobb-Douglas関数なので、論文の12式
e_c_y .. c_y =e= (1/phi_y) * (pk/sh_k_y)**(sh_k_y) * (pl/sh_l_y)**(sh_l_y);

e_c_u .. c_u =e= (alpha_x_u**sig_u * px**(1-sig_u) + alpha_y_u**sig_u * py**(1-sig_u))**(1/(1-sig_u));


*	単位需要

*	論文の3式
e_a_k_x .. a_k_x =e= (alpha_k_x*c_x/pk)**(sig_x);

e_a_l_x .. a_l_x =e= (alpha_l_x*c_x/pl)**(sig_x);

*	論文の13式
e_a_k_y .. a_k_y =e= sh_k_y*c_y/pk;

e_a_l_y .. a_l_y =e= sh_l_y*c_y/pl;

e_a_x_u .. a_x_u =e= (alpha_x_u*c_u/px)**(sig_u);

e_a_y_u .. a_y_u =e= (alpha_y_u*c_u/py)**(sig_u);

*	ゼロ利潤条件

e_x .. c_x =e= px;

e_y .. c_y =e= py;

e_u .. c_u =e= pu;

*	市場均衡条件

e_px .. x =e= a_x_u*u;

e_py .. y =e= a_y_u*u;

e_pu .. pu*u =e= inc;

e_pk .. end_k =e= a_k_x*x + a_k_y*y;

e_pl .. end_l =e= a_l_x*x + a_l_y*y;

*	所得の定義式

e_inc .. inc =e= pk*end_k + pl*end_l;


*	----------------------------------------------------------------------
*	モデルの宣言

model model_normal Model in normal form CES /

		   e_c_x.c_x, e_c_y.c_y, e_c_u.c_u, e_a_k_x.a_k_x,
		   e_a_l_x.a_l_x, e_a_k_y.a_k_y, e_a_l_y.a_l_y, e_a_x_u.a_x_u,
		   e_a_y_u.a_y_u, e_x.x, e_y.y, e_u.u, e_px.px, e_py.py,
		   e_pu.pu, e_pk.pk, e_pl.pl, e_inc.inc

		   /;

c_x.l = 1;
c_y.l = 1;
c_u.l = 1;
a_k_x.l = kx0/x0;
a_l_x.l = lx0/x0;
a_k_y.l = ky0/y0;
a_l_y.l = ly0/y0;
a_x_u.l = cx0/u0;
a_y_u.l = cy0/u0;
x.l = x0;
y.l = y0;
u.l = u0;
px.l = 1;
py.l = 1;
pu.l = 1;
pk.l = 1;
pl.l = 1;
inc.l = inc0;

c_x.lo = 1e-6;
c_y.lo = 1e-6;
c_u.lo = 1e-6;
a_k_x.lo = 0;
a_l_x.lo = 0;
a_k_y.lo = 0;
a_l_y.lo = 0;
a_x_u.lo = 0;
a_y_u.lo = 0;
x.lo = 0;
y.lo = 0;
u.lo = 0;
px.lo = 1e-6;
py.lo = 1e-6;
pu.lo = 1e-6;
pk.lo = 1e-6;
pl.lo = 1e-6;
inc.lo = 1e-6;

*	----------------------------------------------------------------------
*	Benchmark replication.

model_normal.iterlim = 0;
solve model_normal using mcp;

*	----------------------------------------------------------------------
*	Cleanup calculation.

model_normal.iterlim = 10000;
solve model_normal using mcp;

parameter
    report_level
;

report_level("Utility","bau") = u.l;
report_level("Output of x","bau") = x.l;
report_level("Price of x","bau") = px.l/pu.l;

*	======================================================================
*	Calibrated share formを利用する記述
*	======================================================================

*	----------------------------------------------------------------------
*	変数の宣言

variables
    c_x_	x部門の単位費用
    c_y_	y部門の単位費用
    c_u_	効用部門の単位費用
;

variables
    a_k_x_	x部門のkへの単位需要
    a_l_x_	x部門のlへの単位需要
    a_k_y_	y部門のkへの単位需要
    a_l_y_	y部門のlへの単位需要
    a_x_u_	x財への単位消費需要
    a_y_u_	y財への単位消費位需要
;

variables
    x_		x部門の生産
    y_		y部門の生産
    u_		効用部門の生産（効用水準）
;

variables
    px_		x財の価格
    py_		x財の価格
    pu_		効用の価格
    pk_		資本の価格
    pl_
;

variables
    inc_	家計の所得
;

*	----------------------------------------------------------------------
*	式の宣言

equations
    e_c_x_	x部門の単位費用
    e_c_y_	y部門の単位費用
    e_c_u_	効用部門の単位費用
;

equations
    e_a_k_x_	x部門のkへの単位需要
    e_a_l_x_	x部門のlへの単位需要
    e_a_k_y_	y部門のkへの単位需要
    e_a_l_y_	y部門のlへの単位需要
    e_a_x_u_	x財への単位消費需要
    e_a_y_u_	y財への単位消費位需要
;

equations
    e_x_	x部門の生産
    e_y_	y部門の生産
    e_u_	効用部門の生産（効用水準）
;

equations
    e_px_	x財の価格
    e_py_	x財の価格
    e_pu_	効用の価格
    e_pk_	資本の価格
    e_pl_	労働の価格
;

equations
    e_inc_	家計の所得
;

*	単位費用

*	論文の8式（ただし、reference priceは1であるので省略している）
e_c_x_ .. c_x_ =e= (sh_k_x*pk_**(1-sig_x) + sh_l_x*pl_**(1-sig_x))**(1/(1-sig_x));

*	論文16式
e_c_y_ .. c_y_ =e= pk_**(sh_k_y) * pl_**(sh_l_y);

e_c_u_ .. c_u_ =e= (sh_x_u*px_**(1-sig_u) + sh_y_u*py_**(1-sig_u))**(1/(1-sig_u));


*	単位需要

*	論文10式
e_a_k_x_ .. a_k_x_ =e= (kx0/x0)*(c_x_/pk_)**(sig_x);

e_a_l_x_ .. a_l_x_ =e= (lx0/x0)*(c_x_/pl_)**(sig_x);

e_a_k_y_ .. a_k_y_ =e= (ky0/y0)*c_y_/pk_;

e_a_l_y_ .. a_l_y_ =e= (ly0/y0)*c_y_/pl_;

e_a_x_u_ .. a_x_u_ =e= (cx0/u0)*(c_u_/px_)**(sig_u);

e_a_y_u_ .. a_y_u_ =e= (cy0/u0)*(c_u_/py_)**(sig_u);

*	ゼロ利潤条件

e_x_ .. c_x_ =e= px_;

e_y_ .. c_y_ =e= py_;

e_u_ .. c_u_ =e= pu_;

*	市場均衡条件

e_px_ .. x_ =e= a_x_u_*u_;

e_py_ .. y_ =e= a_y_u_*u_;

e_pu_ .. pu_*u_ =e= inc_;

e_pk_ .. end_k =e= a_k_x_*x_ + a_k_y_*y_;

e_pl_ .. end_l =e= a_l_x_*x_ + a_l_y_*y_;


*	所得の定義式

e_inc_ .. inc_ =e= pk_*end_k + pl_*end_l;


*	----------------------------------------------------------------------
*	モデルの宣言

model model_csf Model in calibrated share form CES /

		   e_c_x_.c_x_, e_c_y_.c_y_, e_c_u_.c_u_, e_a_k_x_.a_k_x_,
		   e_a_l_x_.a_l_x_, e_a_k_y_.a_k_y_, e_a_l_y_.a_l_y_, e_a_x_u_.a_x_u_,
		   e_a_y_u_.a_y_u_, e_x_.x_, e_y_.y_, e_u_.u_, e_px_.px_, e_py_.py_,
		   e_pu_.pu_, e_pk_.pk_, e_pl_.pl_, e_inc_.inc_

		   /;

c_x_.l = 1;
c_y_.l = 1;
c_u_.l = 1;
a_k_x_.l = kx0/x0;
a_l_x_.l = lx0/x0;
a_k_y_.l = ky0/y0;
a_l_y_.l = ly0/y0;
a_x_u_.l = cx0/u0;
a_y_u_.l = cy0/u0;
x_.l = x0;
y_.l = y0;
u_.l = u0;
px_.l = 1;
py_.l = 1;
pu_.l = 1;
pk_.l = 1;
pl_.l = 1;
inc_.l = inc0;

c_x_.lo = 1e-6;
c_y_.lo = 1e-6;
c_u_.lo = 1e-6;
a_k_x_.lo = 0;
a_l_x_.lo = 0;
a_k_y_.lo = 0;
a_l_y_.lo = 0;
a_x_u_.lo = 0;
a_y_u_.lo = 0;
x_.lo = 0;
y_.lo = 0;
u_.lo = 0;
px_.lo = 1e-6;
py_.lo = 1e-6;
pu_.lo = 1e-6;
pk_.lo = 1e-6;
pl_.lo = 1e-6;
inc.lo = 1e-6;

*	----------------------------------------------------------------------
*	Benchmark replication.

model_csf.iterlim = 0;
solve model_csf using mcp;

*	----------------------------------------------------------------------
*	Cleanup calculation.

model_csf.iterlim = 10000;
solve model_csf using mcp;

parameter
    report_level_
;

report_level_("Utility","bau") = u_.l;
report_level_("Output of x","bau") = x_.l;
report_level_("Price of x","bau") = px_.l/pu_.l;


*	======================================================================
*	シミュレーション
*	======================================================================
$ontext
資本ストックの50%の増加のシミュレーション。

Normal formのモデルとCalibrated share formのモデルで解が同じになることを確認す
る。
$offtext

end_k = end_k * 1.5;

*	Normal formのモデル
solve model_normal using mcp;

report_level("Utility","CF") = u.l;
report_level("Output of x","CF") = x.l;
report_level("Price of x","CF") = px.l/pu.l;

*	Calibrated share formのモデル
solve model_csf using mcp;

report_level_("Utility","CF") = u_.l;
report_level_("Output of x","CF") = x_.l;
report_level_("Price of x","CF") = px_.l/pu_.l;

*	Normal formのモデルの結果と、Calibrated share formのモデルの結果を比較
*	する。
display report_level, report_level_;


* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* End:

