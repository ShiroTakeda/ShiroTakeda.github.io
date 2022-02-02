$title 一般均衡モデル（双対アプローチによる表現）
$ontext
Time-stamp:     <2021-02-19 17:06:03 st>
First-written:  <2013/10/24>
$offtext

*       --------------------------------------------------------------
*       集合の宣言
set     i 財の集合              / agr, man, ser /
        f 生産要素の集合                / lab, cap /
;
*       aliasの作成
alias(i,j), (i,ii), (f,ff);
display i, j, f;

*       --------------------------------------------------------------
*       生産関数・効用関数のパラメータ
$ontext
生産関数、効用関数内のウェイトパラメータの宣言。
$offtext
parameter
    alpha_x(j,i)        生産関数のウェイトパラメータ
    alpha_v(i)          生産関数のウェイトパラメータ
    beta_v(f,i)         生産関数のウェイトパラメータ
    gamma(i)            効用関数のウェイトパラメータ
;

$ontext
table命令
+ table命令はパラメータを定義する命令の一種。
+ 二次元のパラメータを定義するときにはtable命令を利用するとわかりやす
　い。

以下の命令によって
t_alpha("agr","agr") = 0.045918367;
t_alpha("man","agr") = 0.005102041;
...
としたのと同じようになる。
$offtext
table t_alpha(*,i) alpha_xの値
                    agr            man            ser
agr         0.045918367    0.001111111           0.04
man         0.005102041    0.027777778    0.017777778
ser         0.020408163    0.017777778    0.017777778
v           0.326530612    0.444444444    0.284444444
;
$ontext
さらに、t_beta_vも同様に定義。
$offtext
table t_beta_v(f,i) beta_vの値
                 agr     man         ser
lab         0.390625    0.16    0.390625
cap         0.140625    0.36    0.140625
;
display t_alpha, t_beta_v;

*       t_alphaの値 → alpha_x & alpha_vに代入
alpha_x(j,i) = t_alpha(j,i);
alpha_v(i) = t_alpha("v",i);

*       alphaの値をチェック
display alpha_x, alpha_v;

*       betaについても同様
beta_v(f,i) = t_beta_v(f,i);
display beta_v;

*       gammaの値の設定
gamma("agr") = 0.037808642;
gamma("man") = 0.37345679;
gamma("ser") = 0.037808642;
display gamma;

*       --------------------------------------------------------------
*       代替の弾力性パラメータ
$ontext
+ 生産関数、効用関数の中の代替の弾力性 (elasticity of substitution,
  EOS) も外生的に設定する。
+ 1と0（つまり、Cobb-DouglasとLeontief型）には設定できないので注意。

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
*       外生変数
$ontext
+ モデルの外生変数は生産要素の賦存量。
$offtext
parameter
    v_bar(f)    生産要素の賦存量（外生的）
    v_bar0(f)   生産要素の賦存量（外生的）;
v_bar(f) = 180;
v_bar0(f) = v_bar(f);
display v_bar;

parameter
    t_c(i)      消費に対する従価税率
    t_f(f,i)    生産要素の投入に対する従価税率
;
*       税率の初期値はゼロとする。
t_c(i) = 0;
t_f(f,i) = 0;

*       --------------------------------------------------------------
*       変数の宣言
variables
    y(i)        生産量
    v_a(i)      合成生産要素
    a_x(j,i)    単位投入需要
    x(j,i)      投入需要
    a_v(i)      単位合成生産要素需要
    a_f(f,i)    単位生産要素需要
    vf(f,i)     生産要素需要
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
    e_y(i)      生産における利潤最大化条件
    e_v_a(i)    生産要素合成における利潤最大化条件
    e_a_x(j,i)  単位投入需要
    e_x(j,i)    投入需要
    e_a_v(i)    単位合成生産要素需要
    e_a_f(f,i)  単位生産要素需要
    e_vf(f,i)   生産要素需要
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

*       生産における利潤最大化条件
e_y(i) .. (sum(j, alpha_x(j,i)**sig(i) * p(j)**(1-sig(i)))
            + alpha_v(i)**sig(i) * p_va(i)**(1-sig(i)))**(1/(1-sig(i)))
            - p(i) =e= 0;

*       生産要素合成における利潤最大化条件
e_v_a(i) .. (sum(f, beta_v(f,i)**sig_v(i)
              * ((1+t_f(f,i))*p_f(f))**(1-sig_v(i))))**(1/(1-sig_v(i)))
              - p_va(i) =e= 0;
            
*       単位投入需要
e_a_x(j,i) ..
          a_x(j,i) =e= (alpha_x(j,i)/p(j))**(sig(i))
              * (sum(ii, alpha_x(ii,i)**sig(i) * p(ii)**(1-sig(i)))
                  + alpha_v(i)**sig(i) * p_va(i)**(1-sig(i))
              )**(sig(i)/(1-sig(i)));

*       単位合成生産要素需要
e_a_v(i) .. a_v(i) =e= (alpha_v(i)/p_va(i))**(sig(i))
              * (sum(j, alpha_x(j,i)**sig(i) * p(j)**(1-sig(i)))
                  + alpha_v(i)**sig(i) * p_va(i)**(1-sig(i))
              )**(sig(i)/(1-sig(i)));

*       単位生産要素需要
e_a_f(f,i) ..
          a_f(f,i) =e=
              (beta_v(f,i)/((1+t_f(f,i))*p_f(f)))**(sig_v(i))
              * (sum(ff, beta_v(ff,i)**sig_v(i)
                  * ((1+t_f(ff,i))*p_f(ff))**(1-sig_v(i)))
              )**(sig_v(i)/(1-sig_v(i)));

*       消費需要
e_d(i) .. d(i) =e=
          u * (gamma(i)/((1+t_c(i))*p(i)))**(sig_c)
            * (sum(j, gamma(j)**(sig_c)*((1+t_c(j))*p(j))**(1-sig_c))
            )**(sig_c/(1-sig_c)); 

*       財の市場均衡
e_p(i) .. y(i) =e= sum(j, a_x(i,j)*y(j)) + d(i);

*       合成生産要素の市場均衡
e_p_va(i) .. v_a(i) =e= a_v(i)*y(i);

*       生産要素の市場均衡
e_p_f(f) .. v_bar(f) =e= sum(i, a_f(f,i)*v_a(i));

*       支出＝所得
e_u ..    u * (sum(j, gamma(j)**(sig_c)
            * ((1+t_c(j))*p(j))**(1-sig_c)))**(1/(1-sig_c)) =e= m;

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
model ge_sample_dual 一般均衡モデル（双対アプローチ） /
                e_y.y, e_v_a.v_a, e_a_x.a_x, e_a_v.a_v, e_a_f.a_f,
                e_d.d, e_p.p, e_p_va.p_va, e_p_f.p_f, e_u.u, e_m.m,
                e_x.x, e_vf.vf
                /;

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
p.lo(i) = 1e-6;
p_va.lo(i) = 1e-6;
p_f.lo(f) = 1e-6;
u.lo = 0;
m.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値
$ontext
ここで指定した値がモデルを解く際の変数の初期値として利用される。MCPにお
いて解が求まるかどうかは、変数の初期値の与え方に強く依存する。モデルが
解けないときには、変数の初期値を変更してみるのが一つの対処方法である。
$offtext
y.l(i) = 10;
v_a.l(i) = 10;
a_x.l(j,i) = 10;
a_v.l(i) = 10;
a_f.l(f,i) = 10;
d.l(i) = 10;
x.l(j,i) = a_x.l(j,i) * y.l(i);
vf.l(f,i) = a_f.l(f,i) * v_a.l(i);
p.l(i) = 1;
p_va.l(i) = 1;
p_f.l(f) = 1;
u.l = 300;
m.l = 300;

*       --------------------------------------------------------------
*       ニュメレールの指定
$ontext
ニュメレールを指定しておかなくても解けるが（実際に下の行をコメントアウ
トして解いてみて欲しい）、一応ニュメレールを指定しておく。ここでは、
agrをニュメレールに指定する。モデルを解くという観点からは、なにをニュメ
レールに選んでもよい。

MCPタイプのモデルでは変数を固定（fix）した場合には、その変数が対応する
式はモデルから除外されることになる。この場合、p("agr") を固定しているの
で、それに対応する式 e_p("agr") がモデルから除かれることになる。つまり、
財agrの市場均衡条件がモデルから除外される。ただし、ワルラス法則
（Walrus Law）が成立しているなら、財agrの市場も自動的に均衡するはずであ
る。実際に財agrの市場が均衡しているかをチェックするのがよい。
$offtext
p.fx("agr") = 1;

*       --------------------------------------------------------------
*       モデルを解く
$ontext
MCPとしてモデルを解く。
$offtext
option mcp = path;
solve ge_sample_dual using mcp;

*       --------------------------------------------------------------
*       資本の賦存量が20%減少するシミュレーション
$ontext
+ 資本の賦存量は v_bar("cap") というパラメータの値で表されている。
+ これを20%減少させる
$offtext

v_bar("cap") = v_bar0("cap") * 0.8;

solve ge_sample_dual using mcp;

*       元の値に戻しておく。
v_bar("cap") = v_bar0("cap");


* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
