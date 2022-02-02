$title 支出最小化
$ontext
Time-stamp:     <2021-02-19 17:02:56 st>
First-written:  <2013/10/11>

$offtext
*       --------------------------------------------------------------
*       集合の宣言・定義
set     i       Index of goods /
                agr     Agricultural goods
                man     Manufacturing goods
                ser     Services /;
*       iの中身を表示
display i;

*       iと同じ中身を持つjを宣言
alias(i,j);
display j;

*       --------------------------------------------------------------
*       パラメータの宣言
$ontext
外生変数である価格と所得を表すパラメータ。
$offtext
parameter
    p(i)        Goods price
    u           Utility
;
p("agr") = 1;
p("man") = 2;
p("ser") = 3;
u = 17.45047590;
display p, u;

$ontext
外生的に与える値。
$offtext
parameter
    gamma(i)    Weight parameter
    sigma       Elasticity of substitution
;
*       gammaに値を代入
gamma(i) = 1;
gamma(i) = gamma(i)/sum(j, gamma(j));
display gamma;

sigma = 0.5;
display sigma;

*       --------------------------------------------------------------
*       内生変数の宣言
$ontext
内生変数はvariables命令で宣言
$offtext
variables
    h(i)        Demand
    mu          Lagrange multiplier
;
*       --------------------------------------------------------------
*       式の宣言
$ontext
式はequations命令で宣言

式の名前は「e_ + その式に対応する変数名」としておく。
$offtext
equations
    e_h(i)      "1st order condition for d(i)"
    e_mu        "1st order condition for mu"
;
*       --------------------------------------------------------------
*       式の定義

e_h(i) .. p(i) - mu * (sum(j, gamma(j)*(h(j))**((sigma-1)/sigma))**(1/(sigma-1))
          * gamma(i) * (h(i))**(-1/sigma)) =e= 0;

e_mu .. - (sum(i, gamma(i)*(h(i))**((sigma-1)/sigma))**(sigma/(sigma-1)) - u) =e= 0;

*       --------------------------------------------------------------
*       モデルの宣言・定義
$ontext
モデルに含まれる式を指定することによってモデルを定義。

「式の名前.式に対応する変数名」という形式で指定。

    e_h.h

というのは、「e_h」という式に対して、「h」という変数を対応させるという
こと。

$offtext
model expenditure_min Expenditure minimization / e_h.h, e_mu.mu /;

*       --------------------------------------------------------------
*       変数の下限を指定
$ontext
「変数名.lo」が変数の下限を表す。
$offtext
h.lo(i) = 0;
mu.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値を指定
$ontext
「変数名.l」が変数のその時点における値を表す。この後、すぐにモデルを解
くので、ここで指定した値が初期値として利用されることになる。
$offtext
h.l(i) = 10;
mu.l = 10;

*       --------------------------------------------------------------
*       モデルを解く
$ontext
solve命令でモデルを解く。
$offtext
option mcp = path;
solve expenditure_min using mcp;

parameter
    results     結果をまとめて表示するためのパラメータ
;
results(i,"price") = p(i);
results("/","income") = 0;
results(i,"demand") = h.l(i);
results("/","mu") = mu.l;
results("/","1/mu") = mu.l**(-1);
results(i,"exp") = p(i)*h.l(i);
results("sum","exp") = sum(i, results(i,"exp"));
results("/","utility") = u;

$ontext
utility_max.gmsにおける解と比較し、チェックする
チェックする項目
+ 需要量 → 同じ水準になっているか？
+ 「こちらの支出＝utility_maxの所得」が成り立っているか？
+ 「こちらのmu＝utility_maxの1/lambda」が成り立っているか？

$offtext
display results;

* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
