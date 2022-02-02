$ontext
Time-stamp:     <2022-01-20 22:58:49 st>
First-written:  <2016/03/29>

結果を excel ファイルに出力
$offtext

$onecho > command.txt
i=one_region.gdx o=chap_12_results.xlsx epsout=0
par=results rng=results!A1 rdim=1 cdim=1
par=results_pc rng=results_pc!A1 rdim=1 cdim=1
$offecho

$call '=gdxxrw @command.txt';

$onecho > command.txt
i=one_region_cet.gdx o=chap_12_results.xlsx epsout=0
par=results rng=cet_results!A1 rdim=1 cdim=1
par=results_pc rng=cet_results_pc!A1 rdim=1 cdim=1
$offecho

$call '=gdxxrw @command.txt';

$onecho > command.txt
i=one_region_alt.gdx o=chap_12_results.xlsx epsout=0
par=results rng=alt_results!A1 rdim=1 cdim=1
par=results_pc rng=alt_results_pc!A1 rdim=1 cdim=1
$offecho

$call '=gdxxrw @command.txt';

$onecho > command.txt
i=one_region_tot.gdx o=chap_12_results.xlsx epsout=0
par=results rng=tot_results!A1 rdim=1 cdim=1
par=results_pc rng=tot_results_pc!A1 rdim=1 cdim=1
$offecho

$call '=gdxxrw @command.txt';







* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* coding: utf-8-dos
* End:
