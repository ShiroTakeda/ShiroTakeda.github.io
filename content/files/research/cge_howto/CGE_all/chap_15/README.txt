
First-written:	<2017/03/03>
Time-stamp:	<2019-11-19 23:02:23 st>

--------------------------------------------------------------------------

* ファイルの説明

+ README.txt:
  + このファイルです。

+ Part_15_SAM_example.xlsx
  + SAM のデータのファイルです。

+ Part_15_SAM_example_alt.xlsx
  + SAM のデータのファイルです。

+ data_create.gms
  + データを作成するためのプログラムです。Part_15_SAM_example.xlsx 用です。

+ data_create_alt.gms
  + データを作成するためのプログラムです。Part_15_SAM_example_alt.xlsx 用です。

+ sub_scenario_setting.gms
  + シナリオ別の設定をしているファイルです。Japan_model.gms が読み込みます。

+ Japan_model.gms
  + メインのプログラムファイルです。シミュレーションにはこれを実行します。

+ Japan_model_normalized.gms
  + Japan_model.gms と基本的に同じ。
  + ただし、内生変数の初期値が 1 になるように規準化しているモデルです。

+ Japan_model_csf.gms
  + Japan_model.gms と基本的に同じ。
  + ただし、CES 関数を calibrated share form で記述したものです。

+ Japan_model_normalized_csf.gms
  + Japan_model.gms と基本的に同じ。
  + 内生変数の初期値を1に設定 + CES 関数を calibrated share form で記述

+ Japan_model_normalized_csf.gms
  + Japan_model.gms と基本的に同じ。
  + MPSGEを用いてモデルを記述したファイル。

+ export_excel.gms
  + 結果をエクセルファイルに出力するプログラム


* 実行方法

** Step 1

+ まず、data_create_alt.gms と data_create.gms を実行して、エクセルファイルから
  GDX ファイルを作成します。

** Step 2

+ シミュレーションのプログラムである。
  + Japan_model.gms
  + Japan_model_normalized.gms
  + Japan_model_csf.gms
  + Japan_model_normalized_csf.gms
  + Japan_model_normalized_alt.gms
  を実行します。

** Step 3

+ 結果をエクセルファイルに出力するには export_excel.gms と export_excel_alt.gms
  を実行します。
+ 結果は part_15_results.xlsx に出力されます。






--------------------
Local Variables:
mode: org
coding: utf-8
fill-column: 80
End:
