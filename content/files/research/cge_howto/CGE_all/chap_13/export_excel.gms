$ontext
Time-stamp:     <2022-01-21 00:36:01 st>
First-written:  <2016/03/29>

結果を excel ファイルに出力
$offtext

*       inv_model_a 用
$onecho > command.txt
i=inv_model_A.gdx o=chap_13_results.xlsx epsout=0
par=results rng=results_A!A1 rdim=2 cdim=1
par=results_pc rng=results_pc_A!A1 rdim=2 cdim=1
$offecho
$call '=gdxxrw @command.txt';

*       inv_model_b 用
$onecho > command.txt
i=inv_model_B.gdx o=chap_13_results.xlsx epsout=0
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

