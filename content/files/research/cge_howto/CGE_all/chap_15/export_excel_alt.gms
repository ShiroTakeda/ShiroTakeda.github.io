$ontext
Time-stamp:     <2022-01-23 21:09:06 st>
First-written:  <2016/03/29>

+ gov_model_A.gms と gov_model_B.gms の結果を excel ファイルに出力する
  ためのプログラム

$offtext

$onecho > command.txt
i=japan_model_normalized_alt.gdx o=chap_15_results.xlsx epsout=0
par=results rng=alt!A1 rdim=1 cdim=1
par=results_pc rng=alt_pc!A1 rdim=1 cdim=1
par=results_y rng=alt_y!A1 rdim=1 cdim=1
par=results_y_pc rng=alt_y_pc!A1 rdim=1 cdim=1
$offecho
$call '=gdxxrw @command.txt';

$call 'del command.txt';

* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:

