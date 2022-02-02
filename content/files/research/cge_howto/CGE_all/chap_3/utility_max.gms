$title 効用最大化問題
$ontext
Time-stamp:     <2022-01-19 12:50:36 st>
First-written:  <2013/10/11>
$offtext
*       --------------------------------------------------------------
*       集合の宣言・定義
set     i       Index of goods /
                agr     Agricultural goods
                man     Manufacturing goods
                ser     Services /;
*       i の中身を表示
display i;

*       alias 命令によって i と同じ中身を持つ j を宣言
alias(i,j);
display j;

*       --------------------------------------------------------------
*       パラメータの宣言
$ontext
外生変数である価格と所得を表すパラメータ。
$offtext
parameter
    p(i)        Goods price
    m           Income
;
p("agr") = 1;
p("man") = 2;
p("ser") = 3;
m = 100;
display p, m;

$ontext
その他に外生的に与える値。
$offtext
parameter
    gamma(i)    Weight parameter
    sigma       Elasticity of substitution
;
*       gamma に値を代入
gamma(i) = 1;
gamma(i) = gamma(i)/sum(j, gamma(j));
display gamma;

sigma = 0.5;
display sigma;

*       --------------------------------------------------------------
*       内生変数の宣言
$ontext
内生変数は variables 命令で宣言
$offtext
variables
    d(i)        Demand
    lambda      Lagrange multiplier
;
*       --------------------------------------------------------------
*       式の宣言
$ontext
式は equations 命令で宣言

式の名前は「e_ + その式に対応する変数名」としておく。
$offtext
equations
    e_d(i)      "1st order condition for d(i)"
    e_lambda    "1st order condition for lambda"
;
*       --------------------------------------------------------------
*       式の定義

e_d(i) .. (sum(j, gamma(j)*(d(j))**((sigma-1)/sigma)))**(1/(sigma-1))
          * gamma(i) * (d(i))**(-1/sigma) - lambda * p(i) =e= 0;

e_lambda .. - (sum(i, p(i)*d(i)) - m) =e= 0;

*       --------------------------------------------------------------
*       モデルの宣言・定義
$ontext
モデルに含まれる式を指定することによってモデルを定義。

「式の名前.式に対応する変数名」という形式で指定。例えば

    e_d.d

というのは、「e_d」という式に対して、「d」という変数を対応させるという
ことを意味する。

$offtext
model utility_max Utility maximization / e_d.d, e_lambda.lambda /;

*       --------------------------------------------------------------
*       変数の下限値を指定
$ontext
「変数名.lo」が変数の下限値を表す。
$offtext
d.lo(i) = 0;
lambda.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値を指定
$ontext
「変数名.l」が変数のその時点における値を表す。この後、すぐにモデルを解くので、こ
こで指定した値がモデルを解く際の初期値として利用されることになる。
$offtext
d.l(i) = 10;
lambda.l = 10;

*       --------------------------------------------------------------
*       モデルを解く
$ontext
solve 命令でモデルを解く。
$offtext
option mcp = path;
solve utility_max using mcp;

parameter
    results     結果をまとめて表示するためのパラメータ
;
results(i,"price") = p(i);
results("/","income") = m;
results(i,"demand") = d.l(i);
results("/","lambda") = lambda.l;
results("/","1/lambda") = 1/lambda.l;
results(i,"exp") = p(i)*d.l(i);
results("sum","exp") = sum(i, results(i,"exp"));
results("/","utility") =
    (sum(i, gamma(i)*(d.l(i))**((sigma-1)/sigma)))**(sigma/(sigma-1));

display results;


*--------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
