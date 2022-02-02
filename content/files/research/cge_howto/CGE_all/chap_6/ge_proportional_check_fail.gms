$title 外生変数の比例変化によるチェック
$ontext
Time-stamp:     <2021-02-19 17:05:49 st>
First-written:  <2013/12/07>

外生変数の比例変化によるチェック
$offtext

*       ge_sample_dual.gmsを読み込む。
$include ge_sample_dual_alt.gms

*       --------------------------------------------------------------
*       マクロの利用
$ontext
+ 結果を results というパラメータを代入する。
$offtext

parameter
    results     結果を表示するためのパラメータ
    results_pc  変化率を表示するためのパラメータ (%)
;
*       以下はout_resultsというマクロの定義
$macro out_resutls(sc) \
*       効用水準
    results("u",sc) = u.l; \
*       生産量の水準
    results("y_agr",sc) = y.l("agr"); \
    results("y_man",sc) = y.l("man"); \
    results("y_ser",sc) = y.l("ser"); \
*       消費量の水準
    results("c_agr",sc) = d.l("agr"); \
    results("c_man",sc) = d.l("man"); \
    results("c_ser",sc) = d.l("ser"); \
*       価格の水準
    results("p_man",sc) = p.l("man"); \
    results("pf_lab",sc) = p_f.l("lab"); \
    results("m",sc) = m.l; \
*       相対価格の水準
    results("p_man-p_agr",sc) = p.l("man") / p.l("agr"); \
    results("pf_lab-p_agr",sc) = p_f.l("lab") / p.l("agr"); \
    results("m-p_agr",sc) = m.l / p.l("agr"); \
    results("p_man-pf_lab",sc) = p.l("man") / p_f.l("lab"); \
    results("pf_lab-pf_lab",sc) = p_f.l("lab") / p_f.l("lab"); \
    results("m-pf_lab",sc) = m.l / p_f.l("lab");

set var 結果表示用の集合 /
        u, y_agr, y_man, y_ser, c_agr, c_man, c_ser, p_man, pf_lab, m,
        p_man-p_agr, pf_lab-p_agr, m-p_agr, p_man-pf_lab,
        pf_lab-pf_lab, m-pf_lab /;

set     sce     計算するシナリオ /
                sce1    デフォールトの均衡
                sce2    資本の賦存量を2倍にした均衡
                sce3    資本と労動の賦存量を2倍にした均衡
                sce4    資本と労動の賦存量を0.5倍にした均衡
                /;
display sce;

*       --------------------------------------------------------------
*       SCE1: デフォールトの設定でのシミュレーション

*       モデルを解く。
solve ge_sample_dual using mcp;

*       以下はマクロの実行。
out_resutls("sce1");

*       --------------------------------------------------------------
*       SCE2: 資本の賦存量を2倍にした均衡
$ontext
+ 資本の賦存量は v_bar("cap") というパラメータの値で表されている。
+ これを2倍に（つまり、100%）増加させる。
$offtext
*       2倍に増加
v_bar("cap") = v_bar0("cap") * 2;

solve ge_sample_dual using mcp;

*       マクロの実行
out_resutls("sce2");

*       元の値に戻す。
v_bar("cap") = v_bar0("cap");

*       --------------------------------------------------------------
*       SCE3: 資本と労動の賦存量を2倍にした均衡
$ontext
+ 資本と労動の賦存量を2倍にする。
$offtext
v_bar(f) = v_bar0(f) * 2;

solve ge_sample_dual using mcp;

out_resutls("sce3");

v_bar(f) = v_bar0(f);

*       --------------------------------------------------------------
*       SCE4: 資本と労動の賦存量を0.5倍にした均衡
$ontext
+ 資本と労動の賦存量を0.5倍にする。
$offtext
v_bar(f) = v_bar0(f) * 0.5;

solve ge_sample_dual using mcp;

out_resutls("sce4");

v_bar(f) = v_bar0(f);

*       --------------------------------------------------------------
*       結果のまとめ

*       resultsパラメータの中身を表示
display results;

*       デフォールトのシナリオの値からの変化率を求める。
results_pc(var,sce)$results(var,"sce1")
    = 100 * (results(var,sce)/results(var,"sce1") - 1);

*       1e-6で数値をまるめる。
results_pc(var,sce) = round(results_pc(var,sce), 6) + eps;

*       results_pcパラメータの中身を表示
display results_pc;

execute_unload "ge_proportional_check_fail.gdx", results, results_pc;

*       $onecho ~ $offechoの間の部分をtemp.txtというファイルの中に出力
$onecho > temp.txt
i=ge_proportional_check_fail.gdx o=ge_proportional_check.xlsx epsout=0
par=results rng=results_fail!A1 rdim=1 cdim=1
par=results_pc rng=results_pc_fail!A1 rdim=1 cdim=1
$offecho

*       temp.txtの中身を引数としてgdxxrwを実行する。
execute '=gdxxrw @temp.txt';
*       temp.txtを削除
execute 'del temp.txt';

*       コントロール変数やマクロを表示する命令
$show

* --------------------
* Local Variables:
* mode: gams
* fill-column: 70
* coding: utf-8-dos
* End:
