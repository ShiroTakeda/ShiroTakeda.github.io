$title Profit Maximization
$ontext
Time-stamp:     <2022-01-26 15:12:19 st>
First-written:  <2013/10/11>

$offtext
*       --------------------------------------------------------------
*       パラメータの宣言
parameter
    alpha       費用関数のパラメータ
    beta        費用関数のパラメータ
;
alpha = 20;
beta = 0.5;
display alpha, beta;

parameter
    pri         価格;
pri = 10;

*       --------------------------------------------------------------
*       内生変数の宣言
$ontext
内生変数はvariables命令で宣言
$offtext
variables
    sup         Supply
;
*       --------------------------------------------------------------
*       式の宣言
$ontext
式はequations命令で宣言
式の名前は「e_ + その式に対応する変数名」としておく。
$offtext
equations
    e_sup       "Supply function (FOC for profit maximization)"
;
*       --------------------------------------------------------------
*       式の定義

e_sup .. alpha + beta * sup - pri =g= 0;

*       --------------------------------------------------------------
*       モデルの宣言・定義
$ontext
モデルに含まれる式を指定することによってモデルを定義。
$offtext
model pm_sample Profit Maximization / e_sup.sup /;

*       --------------------------------------------------------------
*       変数の下限を指定
sup.lo = 0;

*       --------------------------------------------------------------
*       変数の初期値を指定
sup.l = 10;

*       --------------------------------------------------------------
*       モデルを解く
option mcp = path;
solve pm_sample using mcp;

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
    solve pm_sample using mcp;
    
*       計算結果をパラメータに代入．
    results(itr,"price") = pri + eps;
    results(itr,"supply") = sup.l + eps;

);

*       結果を表示．
display results;

execute_unload "profit_max.gdx", results;

execute 'gdxxrw i=profit_max.gdx o=util-profit_max.xlsx epsout=0 par=results rng=profit_max!A1 rdim=1 cdim=1';



* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
