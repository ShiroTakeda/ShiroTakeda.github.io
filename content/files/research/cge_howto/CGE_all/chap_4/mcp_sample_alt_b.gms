$title MCP (Mixed complementarity problem) の解き方
$ontext
Time-stamp:     <2022-01-12 15:38:13 st>
First-written:  <2013/10/11>
$offtext

*       --------------------------------------------------------------
*       パラメータの宣言
$ontext
費用関数と効用関数のパラメータの設定．
ここでの設定では、結局次の関係が導かれる．

p = alpha + beta * s

p = gamma - epsilon * d

よって、次のように解釈できる。

+ alpha は供給曲線の切片
+ beta は供給曲線の傾き
+ gamma は需要曲線の切片
+ (-)epsilon は需要曲線の傾き

$offtext

parameter
    alpha       Parameters for cost function
    beta        Parameters for cost function
    gamma       Parameters for utility function
    epsilon     Parameters for utility function;

alpha = 0;
beta = 0.5;
gamma = 10;
epsilon = 2;
display alpha, beta, gamma, epsilon;

*       --------------------------------------------------------------
*       内生変数の宣言
*       内生変数は variables 命令で宣言
variables
    sup         Supply
    dem         Demand
    pri         Price
;
*       --------------------------------------------------------------
*       式の宣言
$ontext
式は equations 命令で宣言

式の名前は「e_ + その式に対応する変数名」としておく。
$offtext
equations
    e_sup   "FOC for profit maximization"
    e_dem   "FOC for utility maximization"
    e_pri   "Market clearing condition"
;
*       --------------------------------------------------------------
*       式の定義
$ontext
注意
+ 必ず左辺が大きくなるように定義する。例えば、e_supについて

e_sup .. 0 =l= alpha + beta * sup - pri;

という定義の仕方は数学的には同じはずだが、ここではだめということ。式に
対して下限値を付ける変数を結びつける場合には、式は必ず =g= を使って表現
する。
$offtext

e_sup .. alpha + beta * sup - pri =e= 0;

e_dem .. pri - (gamma - epsilon * dem) =e= 0;

e_pri .. sup - dem =e= 0;

*       --------------------------------------------------------------
*       モデルの宣言・定義
$ontext
モデルに含まれる式を指定することによってモデルを定義。
$offtext
model mcp_sample MCP / e_sup, e_dem, e_pri /;

*       --------------------------------------------------------------
*       変数の下限値を指定
sup.lo = 0;
dem.lo = 0;
pri.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値を指定
sup.l = 10;
dem.l = 10;
pri.l = 10;

*       --------------------------------------------------------------
*       モデルを解く
option mcp = path;
solve mcp_sample using mcp;

$exit

*       --------------------------------------------------------------
*       パラメータを変更しながら何度も解く
$ontext
+ 以下では、供給曲線の切片を表すalphaというパラメータを少しずつ変更する
  というシミュレーションをする。
+ alpha の変化によって
  + 均衡価格
  + 均衡供給量、需要量
  がどう変化するかをチェックする。

$offtext

set     itr     Index of iteration / itr1*itr21 /;
display itr;

parameter
    alpha_(itr)         Value of alpha
    alpha_i             Initial value of alpha
    alpha_f             Final value of alpha;
alpha_i = 20;
alpha_f = -20;

alpha_(itr) =
    alpha_i + (ord(itr) - 1) * (alpha_f - alpha_i)/(card(itr) - 1);
display alpha_;

parameter
    results     これは結果をまとめて表示するためのパラメータ;

*       以下でループ．
loop(itr,

    alpha = alpha_(itr);

*       モデルを解く
    solve mcp_sample using mcp;

*       計算結果をパラメータに代入．
    results(itr,"alpha") = alpha + eps;
    results(itr,"price") = pri.l + eps;
    results(itr,"supply") = sup.l + eps;
    results(itr,"demand") = dem.l + eps;
    results(itr,"s-d") = sup.l - dem.l + eps;

);

*       結果を表示．
display results;

*       results パラメータを mcp_sample.gdx ファイルに出力する．
execute_unload "mcp_sample.gdx", results;

*       mcp_sample.gdx ファイルの中身を mcp_sample.xlsx に出力する．
execute 'gdxxrw i=mcp_sample.gdx o=mcp_sample.xlsx epsout=0 par=results rng=results!A1 rdim=1 cdim=1';

* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
