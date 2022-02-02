$title 均衡価格の0次同次性（ニュメレール）についてのシミュレーション
$ontext
Time-stamp:     <2022-01-13 15:45:27 st>
First-written:  <2013/12/07>

均衡価格の0次同次性（ニュメレール）についてのシミュレーション
$offtext

*       ge_sample_dual.gmsを読み込む。
$include ge_sample_dual.gms

*       --------------------------------------------------------------
*       マクロの利用
$ontext
+ 結果をresultsというパラメータを代入する。
+ その際にマクロを利用する。
  + 以下ではout_resutlsというマクロを定義している。
  + マクロを定義するときの書式

  $macro macro_name macro_content

    とする。macro_nameがマクロの名前、macro_contentがマクロの中身である。
  + 途中での改行にはバックスラッシュを付ける。
  + マクロについて詳しくはMcCarl User Guideを参照すること。

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
                sce3    AGRの価格を2倍にした均衡
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
*       SCE3: AGRの価格を2倍にした均衡
$ontext
+ ニュメレール（価値尺度財）はAGRとしていた。
+ よって、元々は p.fx("agr") = 1; と設定している。
+ これを p.fx("agr") = 2; に変更する。

+ Part 2で説明したように、このモデルは価格について0次同次の性質が成り
　立つ。
+ AGRの価格を2倍にしたとすると、全ての名目価格が2倍に変化するだけで、
  数量変数の値は全く変化しないはず。これを確認する。 
$offtext
p.fx("agr") = 2;

solve ge_sample_dual using mcp;

out_resutls("sce3");

p.fx("agr") = 1;

*       --------------------------------------------------------------
*       SCE4: ニュメレールを労動に変更したときの均衡
$ontext
+ デフォールトではニュメレール（価値尺度財）はAGRであるが、ニュメレー
　ルの選択は任意である。
+ ニュメレールを労動に変更し、p_f.fx("lab") = 1; に変更する。
+ つまり、労動の価格を1に固定して解く。
+ 同じ均衡が実現するかどうかを確認する。
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

*       デフォールトのシナリオの値からの変化率を求める。
results_pc(var,sce)$results(var,"sce1")
    = 100 * (results(var,sce)/results(var,"sce1") - 1);

*       1e-6で数値をまるめる。
results_pc(var,sce) = round(results_pc(var,sce), 6) + eps;

*       results_pcパラメータの中身を表示
display results_pc;

execute_unload "ge_zero_h_check.gdx", results, results_pc;

*       $onecho ~ $offechoの間の部分をtemp.txtというファイルの中に出力
$onecho > temp.txt
i=ge_zero_h_check.gdx o=ge_zero_h_check.xlsx epsout=0
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
