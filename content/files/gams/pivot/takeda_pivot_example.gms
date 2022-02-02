$title pivotdata.gms を使って、pivotテーブル作成用のデータを出力するコード
display "com: pivotdata.gms を使って、pivotテーブル作成用のデータを出力するコード";
$ontext
Time-stamp: 	<2011-09-17 21:56:40 Shiro Takeda>
First-written:	<2011/09/17>
$offtext

*	インデックスの定義
set	t	Time index	/ 2000*2100 /
	tfst(t)	
	s	Sector index	/ ind, ser, agr /
	k	Variable type	/ output, price /;
tfst(t)$(ord(t) eq 1)  = yes;
display t, tfst, s, k;

*	サンプルのパラメータを定義
parameter
    a(t,s,k)
    coeff(s,k)		Coefficient
    alpha(s,k) 		Drift parameter
    sigma(s,k)		Variance
    epsilon(t,s,k)	Stochastic variable with normal distribution
;
coeff(s,k) = 1;
coeff("ind","price") = 0.9;
coeff("ser","price") = 0.9;
coeff("agr","price") = 0.8;
alpha(s,k) = uniform(0,0.05);
sigma(s,k) = uniform(0,0.5);
epsilon(t,s,k) = normal(0,1);
display coeff, alpha, sigma, epsilon;

a(t,s,k)$tfst(t) = 1e-6;
loop(t$(not tfst(t)),
    a(t,s,k)= coeff(s,k)*a(t-1,s,k) + alpha(s,k) + sigma(s,k)*epsilon(t,s,k);
);
display a;

*	----------------------------------------------------------------------
*	データを出力するエクセルファイルの名前を指定

*	まず、データを出力するエクセルファイルの名前を指定する。名前は
*	workbook という変数に入れる (pivotdata.gms でそう決まっている)。↓の例
*	では、sample_excel.xlsx という名前のファイルに出力される。
*
*	元々の pivotdata.gms では
*
*	$setglobal workbook sample_excel
*
*	という拡張子なしの形式で指定するのだが、必ず sample_excel.xls という名
*	前で保存されてしまうので、拡張子込みで指定するように pivotdata.gms を
*	修正した。これなら xlsx という拡張子のファイルにも出力可能。

$setglobal workbook sample_excel.xlsx


*	----------------------------------------------------------------------
*	エクセルファイルに出力する命令

*	書き方
*
*	$batinclude pivotdata parameter_name index_a [index_b index_c ...]
*
*	parameter_name に出力するパラメータを指定。残りはエクセルファイルの1行
*	目でインデックスとして使われる文字列を指定。
*	Parameter の値に対するインデックスには常に "value" が使われる。

$batinclude pivotdata a year sector type


* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* End:
