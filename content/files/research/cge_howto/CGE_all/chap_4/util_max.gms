$title Utility Maximization
$ontext
Time-stamp:     <2022-01-26 15:12:00 st>
First-written:  <2013/10/11>

$offtext
*       --------------------------------------------------------------
*       パラメータの宣言
parameter
    gamma       効用関数のパラメータ
    epsilon     効用関数のパラメータ
;
gamma = 40;
epsilon = 2;
display gamma, epsilon;

parameter
    pri         価格;
pri = 10;

*       --------------------------------------------------------------
*       内生変数の宣言
$ontext
内生変数はvariables命令で宣言
$offtext
variables
    dem         Demand
;
*       --------------------------------------------------------------
*       式の宣言
$ontext
式はequations命令で宣言
式の名前は「e_ + その式に対応する変数名」としておく。
$offtext
equations
    e_dem       "Demand function (FOC for utility maximization)"
;
*       --------------------------------------------------------------
*       式の定義
$ontext
注意
・必ず左辺が大きくなるように定義する。例えば、e_supについて

e_sup .. 0 =l= alpha + beta * sup - pri;

　という定義の仕方はだめということ。下限値を付ける変数を結び
　つける場合には、式は必ず =g= を使って表現する。

$offtext

e_dem .. pri - (gamma - epsilon * dem) =g= 0;

*       --------------------------------------------------------------
*       モデルの宣言・定義
$ontext
モデルに含まれる式を指定することによってモデルを定義。
$offtext
model um_sample Utility maximization / e_dem.dem /;

*       --------------------------------------------------------------
*       変数の下限を指定
dem.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値を指定
dem.l = 10;

*       --------------------------------------------------------------
*       モデルを解く
option mcp = path;
solve um_sample using mcp;

*       --------------------------------------------------------------
*       パラメータを変更しながら何度も解く
$ontext
パラメータの値を変更し何回も解き、均衡価格、均衡需要量・供給量がどのよ
うに変化するかを確認する。

繰り返しようの集合 itr を宣言する。
$offtext

set     itr     Index of iteration / itr1*itr41 /;
display itr;

parameter
    pri_(itr)           Value of price
    pri_i               Initial value of pri
    pri_f               Final value of pri;
pri_i = 50;
pri_f = 0;

pri_(itr) =
    pri_i + (ord(itr) - 1) * (pri_f - pri_i)/(card(itr) - 1);
display pri_;

parameter
    results     結果をまとめて表示するためのパラメータ;

*       以下でループ．
loop(itr,

    pri = pri_(itr);

*       モデルを解く
    solve um_sample using mcp;
    
*       計算結果をパラメータに代入．
    results(itr,"price") = pri + eps;
    results(itr,"demand") = dem.l + eps;

);

*       結果を表示．
display results;

execute_unload "util_max.gdx", results;

execute 'gdxxrw i=util_max.gdx o=util-profit_max.xlsx epsout=0 par=results rng=util_max!A1 rdim=1 cdim=1';


* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
