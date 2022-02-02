$title データを作成するためのプログラム
$ontext
Time-stamp:     <2022-01-21 00:32:56 st>
First-written:  <2014/03/15>

+ inv_model_b.gms で利用するデータを作成するプログラム。
+ chap_13_SAM_example.xlsx から chap_13_SAM_example_B.gdx を作成する。

$offtext

*       --------------------------------------------------------------
*       集合の宣言
set     ct      カテゴリー      / Sector, Factor, DE, Goods, Other, Agent /
        i 財の集合              / agr, man, ser /
        f 生産要素の集合        / lab, cap /
        subct                   / agr, man, ser, lab, cap, con, inv, hh, row /
;
*       alias の作成
alias(i,j), (i,ii), (f,ff);
display i, j, f;

alias (ct,ctt), (subct, subctt);

parameter
    SAM(ct,subct,ctt,subctt)    SAM;
;
*       以下は command.txt というファイルに $onecho ~ $offecho に囲まれ
*       た内容を出力するという命令。
$onecho > command.txt
i=chap_13_SAM_example.xlsx
o=chap_13_SAM_example_B.gdx
par=SAM rng=SAM_13_B!B3:R19 rdim=2 cdim=2
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
