$title データを作成するためのプログラム
$ontext
Time-stamp:     <2022-01-22 23:49:57 st>
First-written:  <2014/03/15>

+ inv_model_b.gms で利用するデータを作成するプログラム。
+ chap_15_SAM_example.xlsx から chap_15_SAM_example_B.gdx を作成する。

$offtext

*       chap_15_SAM_Japan_alt の方を利用するなら、以下の行のコメントア
*       ウトをとる。
$setglobal data_name chap_15_SAM_Japan_alt

*       Dataの名前の設定
$if not setglobal data_name $setglobal data_name chap_15_SAM_Japan

*       --------------------------------------------------------------
*       集合の宣言
$include %data_name%.set

parameter
    SAM(ct,subct,ctt,subctt)    SAM;
;
*       以下は command.txt というファイルに $onecho ~ $offecho に囲まれ
*       た内容を出力するという命令。
$onecho > command.txt
i=%data_name%.xlsx
o=%data_name%.gdx
par=SAM rng=SAM_adjusted!B3:BH61 rdim=2 cdim=2
$offecho

*       以下は、command.txt の内容を引数として gdxxrw.exe を実行するとい
*       う命令。「=」付きは実行が終わるまで次の命令にはうつらないとい
*       う指定。
execute '=gdxxrw @command.txt';

* --------------------
* Local Variables:
* fill-column: 70
* coding: utf-8-dos
* End:
