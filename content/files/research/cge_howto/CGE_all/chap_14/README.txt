
First-written:	<2017/03/03>
Time-stamp:	<2017-03-30 11:47:03 st>

--------------------------------------------------------------------------

* ファイルの説明

+ README.txt: 
  + このファイルです。

+ Part_14_SAM_example.xlsx
  + SAM のデータのファイルです。
  + gov_model_A.gms と gov_model_A.gms で使う SAM が入っています。

+ Part_14_SAM_example.gdx

+ data_create.gms
  + データを作成するためのプログラムです。
  + gov_model_A.gms、gov_model_B.gms を実行する前にこれを実行してください。

+ gov_model_A.gms
  + 政府を考慮したモデルです。

+ gov_model_B.gms
  + 基本的に gov_model_A.gms と同じですが、分析している政策が違います。

+ export_excel.gms
  + 計算結果を part_14_results.xlsx に出力するためのプログラムです。

+ part_14_results.xlsx
  + 計算結果を出力する先です。


* 実行方法

** Step 1

+ まず、data_create.gms を実行して、エクセルファイルからGDX ファイルを作成します。

** Step 2

+ シミュレーションのプログラムである。
  + gov_model_A.gms
  + gov_model_B.gms
  を実行します。

** Step 3

+ 結果をエクセルファイルに出力するには export_excel.gms を実行します。
+ 結果は part_14_results.xlsx に出力されます。






--------------------
Local Variables:
mode: org
coding: utf-8
fill-column: 80
End:
