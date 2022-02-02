$ontext
Time-stamp:     <2022-01-23 21:09:22 st>
First-written:  <2016/03/29>

+ gov_model_A.gms と gov_model_B.gms の結果を excel ファイルに出力する
  ためのプログラム

$offtext

$onecho > command.txt
i=japan_model_default.gdx o=chap_15_results.xlsx epsout=0
par=results rng=default!A1 rdim=1 cdim=1
par=results_pc rng=default_pc!A1 rdim=1 cdim=1
par=results_y rng=default_y!A1 rdim=1 cdim=1
par=results_y_pc rng=default_y_pc!A1 rdim=1 cdim=1
$offecho
$call '=gdxxrw @command.txt';

$onecho > command.txt
i=japan_model_csf.gdx o=chap_15_results.xlsx epsout=0
par=results rng=csf!A1 rdim=1 cdim=1
par=results_pc rng=csf_pc!A1 rdim=1 cdim=1
par=results_y rng=csf_y!A1 rdim=1 cdim=1
par=results_y_pc rng=csf_y_pc!A1 rdim=1 cdim=1
$offecho
$call '=gdxxrw @command.txt';

$onecho > command.txt
i=japan_model_normalized.gdx o=chap_15_results.xlsx epsout=0
par=results rng=normalized!A1 rdim=1 cdim=1
par=results_pc rng=normalized_pc!A1 rdim=1 cdim=1
par=results_y rng=normalized_y!A1 rdim=1 cdim=1
par=results_y_pc rng=normalized_y_pc!A1 rdim=1 cdim=1
$offecho
$call '=gdxxrw @command.txt';

$onecho > command.txt
i=japan_model_normalized_csf.gdx o=chap_15_results.xlsx epsout=0
par=results rng=normalized_csf!A1 rdim=1 cdim=1
par=results_pc rng=normalized_csf_pc!A1 rdim=1 cdim=1
par=results_y rng=normalized_csf_y!A1 rdim=1 cdim=1
par=results_y_pc rng=normalized_csf_y_pc!A1 rdim=1 cdim=1
$offecho
$call '=gdxxrw @command.txt';

$call 'del command.txt';

* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:

