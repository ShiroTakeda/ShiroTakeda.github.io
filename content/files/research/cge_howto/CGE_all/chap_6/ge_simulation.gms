$title 一般均衡モデルによる政策のシミュレーション
$ontext
Time-stamp:     <2021-02-19 17:06:18 st>
First-written:  <2013/12/07>

+ ge_sample_dual.gmsのモデルを利用して政策のシミュレーション。
$offtext

*       ge_sample_dual.gmsを読み込む。
$include ge_sample_dual.gms

*       --------------------------------------------------------------
*       マクロの利用

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
                sce2    manとserに対して10%の消費税を導入するシナリオ
                sce3    労動投入に20%の課税を導入するシナリオ
                /;
display sce;

*       --------------------------------------------------------------
*       SCE1: デフォールトの設定でのシミュレーション

*       モデルを解く。
solve ge_sample_dual using mcp;

*       以下はマクロの実行。
out_resutls("sce1");

*       --------------------------------------------------------------
*       SCE2: manとserに対して10%の消費税を導入するシナリオ
$ontext
+ manとserという2つの財に対して消費税を導入する政策
+ 消費税率は t_c(i) であった。

チェック項目
+ 各財の消費、生産はどう変化するか？
+ 効用水準はどう変化するか？
$offtext

t_c("man") = 0.1;
t_c("ser") = 0.1;

solve ge_sample_dual using mcp;

out_resutls("sce2");

t_c(i) = 0;

*       --------------------------------------------------------------
*       SCE3: 労動投入に20%の課税を導入するシナリオ
$ontext
+ 労動投入に20%の課税を導入する政策
+ 労動投入への税率は t_f("lab",i)。

チェック項目
+ 各部門の生産はどう変化するか？
+ 賃金はどう変化するか？
$offtext

t_f("lab",i) = 0.2;

solve ge_sample_dual using mcp;

out_resutls("sce3");

t_f(f,i) = 0;

*       --------------------------------------------------------------
*       結果のまとめ

*       resultsパラメータの中身を表示
display results;

*       最初の均衡の値からの変化率を求める。
results_pc(var,sce)$results(var,"sce1")
    = 100 * (results(var,sce)/results(var,"sce1") - 1);

*       1e-6で数値をまるめる。
results_pc(var,sce) = round(results_pc(var,sce), 6) + eps;

*       results_pcパラメータの中身を表示
display results_pc;

execute_unload "ge_simulation.gdx", results, results_pc;

*       $onecho ~ $offechoの間の部分をtemp.txtというファイルの中に出力
$onecho > temp.txt
i=ge_simulation.gdx o=ge_simulation.xlsx epsout=0
par=results rng=results!A1 rdim=1 cdim=1
par=results_pc rng=results_pc!A1 rdim=1 cdim=1
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
