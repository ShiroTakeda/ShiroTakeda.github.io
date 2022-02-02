$title ワルラス法則のチェックのシミュレーション
$ontext
Time-stamp:     <2021-02-19 17:06:36 st>
First-written:  <2013/12/07>

ワルラス法則のチェックのシミュレーション
$offtext

*       ge_sample_dual.gmsを読み込む。
$include ge_sample_dual.gms

*       --------------------------------------------------------------
*       結果を代入
$ontext
マクロについては ge_sample_numeraire_check.gms の説明を参照。
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
*       ワルラス法則が成立しているかのチェック。0になればOK
    results("p_agr_m",sc) = p.m("agr"); \
    results("pf_lab_m",sc) = p_f.m("lab"); \
*       これもワルラス法則が成立しているかのチェック（全ての市場の超過
*       需要額の和を計算）。0になればOK
    results("v_ed",sc) = \
        sum(i, p.l(i)*(sum(j, a_x.l(i,j)*y.l(j)) + d.l(i) - y.l(i))) \
        + sum(f, p_f.l(f)*(sum(i, a_f.l(f,i)*v_a.l(i)) - v_bar(f))) \
        + sum(i, p_va.l(i)*(a_v.l(i)*y.l(i) - v_a.l(i))); \
*       四捨五入
    results("p_agr_m",sc) = round(results("p_agr_m",sc), 5) + eps; \
    results("pf_lab_m",sc) = round(results("pf_lab_m",sc), 5) + eps; \
    results("v_ed",sc) = round(results("v_ed",sc), 5) + eps;
   
set     sce     計算するシナリオ /
                sce1    デフォールトの均衡
                sce2    資本の賦存量を2倍にした均衡
                sce4    ニュメレールを労動に変更したときの均衡
                sce5    sce4+資本の賦存量を2倍にした均衡
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
*       SCE4: ニュメレールを労動に変更したときの均衡
$ontext
+ ニュメレールを労動に変更し、p_f.fx("lab") = 1; に変更する。
$offtext
p.up("agr") = inf;
p.lo("agr") = 0;
p_f.fx("lab") = 1;

solve ge_sample_dual using mcp;

out_resutls("sce4");

*       --------------------------------------------------------------
*       SCE5: sce4+資本の賦存量を2倍にした均衡
$ontext
+ ニュメレールを労動に変更した上でSCE2のシミュレーションをおこなう。
$offtext
p.up("agr") = inf;
p.lo("agr") = 0;
p_f.fx("lab") = 1;

v_bar("cap") = v_bar0("cap") * 2;

solve ge_sample_dual using mcp;

out_resutls("sce5");

v_bar("cap") = v_bar0("cap");

*       --------------------------------------------------------------
*       結果のまとめ

*       resultsパラメータの中身を表示
display results;

execute_unload "ge_walrus_check.gdx", results;

*       $onecho ~ $offechoの間の部分をtemp.txtというファイルの中に出力
$onecho > temp.txt
i=ge_walrus_check.gdx o=ge_walrus_check.xlsx epsout=0
par=results rng=results!A1 rdim=1 cdim=1
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
