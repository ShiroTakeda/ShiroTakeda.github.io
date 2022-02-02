$title モデルのチェックの練習
$ontext
Time-stamp:     <2021-02-19 17:08:08 st>
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
ser            20       40       20        0        0       70
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
a_x0(j,i) = x0(j,i) / y0(i);

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
v_bar(f) = sum(i, SAM(f,i));
v_bar0(f) = v_bar(f);
display v_bar;

parameter
    t_c(i)      消費に対する従価税率
    t_f(f,i)    生産要素の投入に対する従価税率
    t_c0(i)     消費に対する従価税率（初期値）
    t_f0(f,i)   生産要素の投入に対する従価税率（初期値）
;
*       税率の初期値はゼロとする。
t_c0(i) = 0;
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
          c0(i) * (sum(j, sh_x(j,i) * (p(j)/p0(j))**(1-sig(i)))
              + sh_v(i) * (p_va(i)/p_va0(i))**(1-sig(i))
          )**(1/(1-sig(i)));

*       合成生産要素生産の単位費用
e_c_va(i) ..
    c_va(i) =e=
    c_va0(i)
    * (sum(f,
        sh_f(f,i)
        * (((1+t_f(f,i))*p_f(f))/((1+t_f0(f,i))*p_f0(f)))**(1-sig_v(i)))
    )**(1/(1-sig_v(i)));

*       生産における利潤最大化条件
e_y(i) .. c(i) =e= p(i);;

*       生産要素合成における利潤最大化条件
e_v_a(i) .. c_va(i) =e= p_va(i);;

*       単位投入需要
e_a_x(j,i) ..
          a_x(j,i) =e= a_x0(j,i)
          * ((c(i) / c0(i)) / (p(j) / p0(j)))**sig(i);

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
       )**(1/(1-sig_c));

*       消費需要
e_d(i) .. d(i) =e=
          d0(i) * (u/u0)**(1-sig_c)
          * ((e/e0) / (((1+t_c(i))*p(i)) / ((1+t_c0(i))*p0(i))))**sig_c;

*       財の市場均衡
e_p(i) .. y(i) =e= sum(j, a_x(i,j)*y(j)) + d(i);

*       合成生産要素の市場均衡
e_p_va(i) .. v_a(i) =e= a_v(i)*y(i);

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*v_a(i));

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

display SAM;

$ontext
+ c(i)のmarginal値が0にならない。

---- VAR c  生産の単位費用

       LOWER     LEVEL     UPPER    MARGINAL

agr 1.0000E-6     1.000     +INF     -0.165      
man 1.0000E-6     1.000     +INF     -0.089      
ser 1.0000E-6     1.000     +INF      0.231

e_c(i)をチェックする。
$offtext

parameter       chk_e_c;

chk_e_c(i,"LHS") = c.l(i);
chk_e_c(i,"RHS")
    = c0(i) * (sum(j, sh_x(i,j) * (p.l(j)/p0(j))**(1-sig(i)))
        + sh_v(i) * (p_va.l(i)/p_va0(i))**(1-sig(i))
    )**(1/(1-sig(i)));
display chk_e_c;

$ontext
----    444 PARAMETER chk_e_c  

            LHS         RHS

agr       1.000       1.165
man       1.000       1.089
ser       1.000       0.769

RHSの値がおかしい。RHSをよくみると、sh_x(i,j)がおかしい。正しくは
sh_x(j,i)とするべき。
$offtext

$ontext
次、p(i) のmarginal値が0にならない。

---- VAR p  財の価格

       LOWER     LEVEL     UPPER    MARGINAL

agr     1.000     1.000     1.000   -60.000      
man 1.0000E-6     1.000     +INF    -48.750      
ser 1.0000E-6     1.000     +INF    -33.750

e_p(i) をチェック。

e_p(i) .. y(i) =e= sum(j, a_x(i,j)*y(j)) + d(i);

定義は問題なく見える。中身をチェックする。
$offtext

parameter    chk_e_p(i,*);

chk_e_p(i,"LHS") = y.l(i);
chk_e_p(i,"RHS") = sum(j, a_x.l(i,j)*y.l(j)) + d.l(i);
display chk_e_p;

$ontext
----    481 PARAMETER chk_e_p  

            LHS         RHS

agr     130.000     190.000
man     300.000     348.750
ser     150.000     183.750

RHSの値がおかしい。中身を細かくチェックする。
$offtext

parameter       chk_e_p_rhs;

chk_e_p_rhs(i,j) = a_x.l(i,j)*y.l(j);
chk_e_p_rhs(i,"C") = d.l(i);
display chk_e_p_rhs;

$ontext
----    501 PARAMETER chk_e_p_rhs  

            agr         man         ser           C

agr      48.750      15.000      56.250      70.000
man      16.250      75.000      37.500     220.000
ser      16.250      60.000      37.500      70.000

+ 消費の量は問題なし。
+ 中間投入が全体的におかしい → 中身をチェック。
$offtext
display y.l, a_x.l;

$ontext
----    515 VARIABLE y.L  生産量

agr 130.000,    man 300.000,    ser 150.000

SAMにおける各部門の列和と一致。生産量は問題ない。ということは a_x(j,i)
に問題あり。a_x(j,i) の初期値は a_x0(j,i)。その a_x0(j,i) の定義は次式。

*       単位投入需要量＝投入需要量/生産量
a_x0(j,i) = x0(j,i) / v_a0(i);

ここが間違っている。正しくは

a_x0(j,i) = x0(j,i) / y0(i);

これを修正して解き直すと次の結果

----    483 PARAMETER chk_e_p  

            LHS         RHS

agr     130.000     140.000
man     300.000     300.000
ser     150.000     140.000

man の市場はいいが、まだ agr と ser の市場が均衡していない。もう一度チェッ
ク。

SAM と chk_e_p_rhsの値を比較

----    423 PARAMETER SAM  SAM data (benchmark data)

            agr         man         ser         lab         cap          hh

agr      30.000      10.000      30.000                              70.000
man      10.000      50.000      20.000                             220.000
ser      10.000      40.000      20.000                              70.000
lab      50.000      80.000      50.000
cap      30.000     120.000      30.000
hh                                          180.000     180.000

----    501 PARAMETER chk_e_p_rhs  

            agr         man         ser           C

agr      30.000      10.000      30.000      70.000
man      10.000      50.000      20.000     220.000
ser      10.000      40.000      20.000      70.000

中間投入、最終需要の部分は同じ。よって、e_pの右辺は正しい値のよう。左
辺は？
$offtext

display y.l, y0;

$ontext
y0の定義

*       生産量＝生産額/価格
y0(i) = sum(col, SAM(col,i)) / p0(i);

----    570 PARAMETER y0  生産量

agr 130.000,    man 300.000,    ser 150.000

e_pの左辺はSAMの列和で計算、e_pの右辺はSAMの行和で計算。二つが合わない。
SAMがおかしい可能性がある。それをチェック。
$offtext

parameter
    chk_row_col_sum
;
set     s_e / agr, man, ser, lab, cap, hh /;
alias(s_e, s_ee);

chk_row_col_sum(s_e,"col") = sum(s_ee, SAM(s_ee, s_e));
chk_row_col_sum(s_e,"row") = sum(s_ee, SAM(s_e, s_ee));
display chk_row_col_sum;

$ontext
----    594 PARAMETER chk_row_col_sum  

            col         row

agr     130.000     140.000
man     300.000     300.000
ser     150.000     140.000
lab     180.000     180.000
cap     180.000     180.000
hh      360.000     360.000

列和と行和が一致していない。これが問題の原因。修正方法はいろいろありう
るが、とりあえず (ser,agr) のセルを10から20に変えると、列和＝行和とな
る。そう修正して、解き直すと

----    483 PARAMETER chk_e_p  

            LHS         RHS

agr     140.000     140.000
man     300.000     300.000
ser     150.000     150.000

という結果になる。市場が均衡するようになった。

SAMを作成したら、「行和＝列和」が成立しているかあらかじめ確認しておく
べき。
$offtext

$ontext
続き

---- VAR p_f  生産要素の価格

       LOWER     LEVEL     UPPER    MARGINAL

lab 1.0000E-6     1.000     +INF   -171.250      
cap 1.0000E-6     1.000     +INF   -138.750      

次は p_f の marginal値が0ではない。e_p_fをチェックする。

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*y(i));

明らかに定義がおかしい。正しくは

e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*v_a(i));

である。このように修正して解き直すと、

---- VAR p_f  生産要素の価格

       LOWER     LEVEL     UPPER    MARGINAL

lab 1.0000E-6     1.000     +INF    -50.000      
cap 1.0000E-6     1.000     +INF    -30.000      

marginal値（の絶対値）は小さくなるが、それでもまだ0ではない。
中身をチェックする。
$offtext

parameter chk_e_p_f;
chk_e_p_f(f,"LHS") = v_bar(f);
chk_e_p_f(f,"RHS") = sum(i, a_f.l(f,i)*v_a.l(i));
display chk_e_p_f;

$ontext
----    661 PARAMETER chk_e_p_f  

            LHS         RHS

lab     130.000     180.000
cap     150.000     180.000

左辺の値がおかしい。左辺は v_bar(f) の値。その定義をチェックする。

v_bar(f) = SAM(f,"agr") + SAM(f,"man");
v_bar0(f) = v_bar(f);

ここの定義が明らかにおかしい。正しくは

v_bar(f) = SAM(f,"agr") + SAM(f,"man") + SAM(f,"ser");

もしくは

v_bar(f) = sum(i, SAM(f,i));

である。このように修正して解き直すと

---- VAR p_f  生産要素の価格

       LOWER     LEVEL     UPPER    MARGINAL

lab 1.0000E-6     1.000     +INF       .         
cap 1.0000E-6     1.000     +INF       .         

となり、生産要素市場は均衡する。
$offtext

$ontext
次
                       LOWER     LEVEL     UPPER    MARGINAL

---- VAR u               .      360.000     +INF       .         
---- VAR m               .      360.000     +INF    -36.000      

  u  効用水準
  m  所得

m のmarginal値がおかしい。e_m をチェックする。

e_m .. m =e= sum(f, p_f(f)*v_bar(f))
             + sum(i, t_c(i)*p(i)*d(i))
             + sum((f,i), t_f(f,i)*p_f(f)*a_f(f,i)*v_a(i));

e_m の定義は特に問題なさそうである。そこで中身をチェックする。
$offtext

parameter chk_e_m;

chk_e_m("LHS") = m.l;
chk_e_m("RHS") =
    sum(f, p_f.l(f)*v_bar(f))
    + sum(i, t_c(i)*p.l(i)*d.l(i))
    + sum((f,i), t_f(f,i)*p_f.l(f)*a_f.l(f,i)*v_a.l(i));
display chk_e_m;

$ontext
----    722 PARAMETER chk_e_m  

LHS 360.000,    RHS 396.000

RHSの値がおかしい。もう少し細かくチェックする。
$offtext

parameter chk_e_m_rhs;

chk_e_m_rhs("要素所得") = sum(f, p_f.l(f)*v_bar(f));
chk_e_m_rhs("消費税") = sum(i, t_c(i)*p.l(i)*d.l(i));
chk_e_m_rhs("生産要素税") = sum((f,i),
    t_f(f,i)*p_f.l(f)*a_f.l(f,i)*v_a.l(i));
display chk_e_m_rhs;

$ontext
----    738 PARAMETER chk_e_m_rhs  

要素所得 360.000,    消費税    36.000

要素所得は問題ないが、初期値が0のはずの消費税収が0ではない。ここがおか
しい。消費税率をチェックする。
$offtext
display t_c;

$ontext
----    748 PARAMETER t_c  消費に対する従価税率

agr 0.100,    man 0.100,    ser 0.100

0であるはずの消費税率が0ではない。t_cの定義部分を確認。

*       税率の初期値はゼロとする。
t_c0(i) = 0.1;
t_f0(f,i) = 0;

t_c(i) = t_c0(i);

t_c0(i) に 0.1 が代入されている。ここがおかしい。t_c0(i) に0を代入して
解き直すと次の結果。

                       LOWER     LEVEL     UPPER    MARGINAL

---- VAR u               .      360.000     +INF       .         
---- VAR m               .      360.000     +INF       .         

  u  効用水準
  m  所得

さらに、solver status も model status も共に1となる。

これで全ての変数の marginal 値が0となった。これはベンチマークデータがそ
のまま均衡状態を満たしていることを意味している。
$offtext

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
* $exit

*       --------------------------------------------------------------
*       Cleanup calculation
csf_model.iterlim = 10000;
solve csf_model using mcp;

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
* $exit

*       --------------------------------------------------------------
*       ニュメレールによるチェック
p.fx("agr") = 2;
solve csf_model using mcp;
p.fx("agr") = 1;

$ontext
次にニュメレールを用いたチェックをおこなう。具体的には、ニュメレールの
価格を2にする。価格の0次同次性が成立しているのなら、価格変数、金額変数
が全て2倍になり、数量変数が不変という結果となるはず。

結果

---- VAR c  生産の単位費用

       LOWER     LEVEL     UPPER    MARGINAL

agr 1.0000E-6     1.715     +INF      0.017      
man 1.0000E-6     1.415     +INF     -0.002      
ser 1.0000E-6     1.491     +INF     -0.002      

---- VAR y  生産量

       LOWER     LEVEL     UPPER    MARGINAL

agr      .        0.003     +INF     -0.285      
man      .      542.373     +INF     -0.002      
ser      .      223.668     +INF     -0.002

価格（単位費用）は2倍になっていないし、生産量は変化してしまっている。価
格の0次同次性が満たされていない。モデルのどこかがおかしいということ。

おかしいのは次の部分

*       合成生産要素生産の単位費用
e_c_va(i) ..
    c_va(i) =e=
    c_va0(i)
    * (sum(f,
        sh_f(f,i)
        * (((1+t_f(f,i))*p_f(f))/((1+t_f0(f,i))*p_f0(f)))**(1-sig_v(i)))
    )**(1/(1+sig_v(i)));

最後の部分が 1+sig_v(i) になっている。正しくは次

e_c_va(i) ..
    c_va(i) =e=
    c_va0(i)
    * (sum(f,
        sh_f(f,i)
        * (((1+t_f(f,i))*p_f(f))/((1+t_f0(f,i))*p_f0(f)))**(1-sig_v(i)))
    )**(1/(1-sig_v(i)));

これで解き直す。

---- VAR c  生産の単位費用

       LOWER     LEVEL     UPPER    MARGINAL

agr 1.0000E-6     2.000     +INF       .         
man 1.0000E-6     2.052     +INF       .         
ser 1.0000E-6     2.003     +INF       .         

---- VAR y  生産量

       LOWER     LEVEL     UPPER    MARGINAL

agr      .       72.930     +INF       .         
man      .      345.288     +INF       .         
ser      .      164.976     +INF       .         

先程よりはましになったがまだおかしい。他の部分をチェック。

*       支出関数
e_e .. e =e=
       u * (e0/u0)
       * (sum(i, sh_c(i) * (((1+t_c(i))*p(i)) / ((1+t_c0(i))*p0(i)))**(1-sig_c))
       );

ここがおかしい。正しくは

*       支出関数
e_e .. e =e=
       u * (e0/u0)
       * (sum(i, sh_c(i) * (((1+t_c(i))*p(i)) / ((1+t_c0(i))*p0(i)))**(1-sig_c))
       )**(1/(1-sig_c));

このように修正して解き直すと、

---- VAR c  生産の単位費用

       LOWER     LEVEL     UPPER    MARGINAL

agr 1.0000E-6     2.000     +INF       .         
man 1.0000E-6     2.000     +INF       .         
ser 1.0000E-6     2.000     +INF       .         

---- VAR y  生産量

       LOWER     LEVEL     UPPER    MARGINAL

agr      .      140.000     +INF       .         
man      .      300.000     +INF       .         
ser      .      150.000     +INF       .         

となる。価格は2倍になり、生産量は不変である。価格の0次同次性が成り立っ
ている。
$offtext

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
* $exit

*       --------------------------------------------------------------
*       外生変数の比例的変化
v_bar(f) = v_bar0(f) * 2;
solve csf_model using mcp;
v_bar(f) = v_bar0(f);

$ontext
これは外生変数の比例的変化。生産要素賦存量を2倍としているので、
全ての数量変数、金額変数の値は2倍になる一方、価格変数は不変という結果
となるはず。

計算してみると実際にそれが成り立っている。
$offtext

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;
* $exit

*       --------------------------------------------------------------
*       税金の導入
t_c("agr") = 0.2;
t_f("lab","man") = 0.2;
solve csf_model using mcp;

t_c(i) = t_c0(i);
t_f(f,i) = t_f0(f,i);

$ontext
税金を導入するというシミューレションをおこなってみる。計算してみると、
モデルは正常に解けるし、ワルラス法則も満たされている。

ただし、だからと言って、モデルに全く問題がないということが証明されるわ
けではないので注意。
$offtext

chk_walras = round(p.m("agr"), 4);
abort$chk_walras "ワルラス法則が満されていません！", chk_walras;

* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
