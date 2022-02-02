$title ide_howto: GAMSIDEの基礎
$ontext
Time-stamp:     <2021-02-19 17:02:22 st>
First-written:  <2013/10/13>
$offtext

set     i       Index of goods /
                agr     農産物
                man     工業製品
                ser     サービス /;
* alias(i,j);
display i, j;

paramter
    gamma(i)    ウェイトパラメータ
    sigma       代替の弾力性
;
gamma(i) = 1
gamma(i) = gamma(i)/sum(j, gamma(j));
display gamma;

sigma = 0;

gamma(i) = gamma(i) / sigma;
display sigma;


* --------------------
* Local Variables:
* fill-column: 80
* coding: utf-8-dos
* End:
