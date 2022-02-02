$ontext
Time-stamp:     <2022-01-21 15:15:57 st>
First-written:  <2016/03/29>

+ gov_model_A.gms と gov_model_B.gms の結果を excel ファイルに出力する
  ためのプログラム

$offtext

*       gov_model_a 用
$onecho > command.txt
i=gov_model_A.gdx o=chap_14_results.xlsx epsout=0
par=results rng=results_A!A1 rdim=2 cdim=1
par=results_pc rng=results_pc_A!A1 rdim=2 cdim=1
$offecho
$call '=gdxxrw @command.txt';

*       gov_model_b 用
$onecho > command.txt
i=gov_model_B.gdx o=chap_14_results.xlsx epsout=0
par=results rng=results_B!A1 rdim=2 cdim=1
par=results_pc rng=results_pc_B!A1 rdim=2 cdim=1
$offecho
$call '=gdxxrw @command.txt';

$call 'del command.txt';

* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:

