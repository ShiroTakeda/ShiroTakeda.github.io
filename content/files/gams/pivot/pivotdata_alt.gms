$hidden	Syntax:	$batinclude pivotdata item s1 s2 s3 ...
$if not defined  pivotids  file pivotids /%gams.scrdir%pivotids.scr/;
$if setglobal workbook $set workbook %workbook%
$if not set   workbook $set workbook pivotdata
$if "%1"=="" $exit
$if exist 'pivotdata.gdx' $abort "Invalid: pivotdata.gdx must be deleted."
$setargs item s1 s2 s3 s4 s5 s6 s7 s8 s9 s10
put pivotids, 'set ids /'/'"%s1%"'/;
$if not "%s2%"=="" put '"%s2%"'/;
$if not "%s3%"=="" put '"%s3%"'/;
$if not "%s4%"=="" put '"%s4%"'/;
$if not "%s5%"=="" put '"%s5%"'/;
$if not "%s6%"=="" put '"%s6%"'/;
$if not "%s7%"=="" put '"%s7%"'/;
$if not "%s8%"=="" put '"%s8%"'/;
$if not "%s9%"=="" put '"%s9%"'/;
$if not "%s10%"=="" put '"%s10%"'/;
put '"value"'/'/;'/"execute_unload 'pivotdata.gdx',ids;"/;
put "execute 'gdxxrw i=pivotdata.gdx o=%workbook% set=ids rng=%item%!a1 rdim=0 values=nodata';"/;
putclose;
$if not "%s1%"=="" execute 'gams %gams.scrdir%pivotids.scr o=nul';
execute_unload 'pivotdata.gdx',%item%;
execute 'gdxxrw i=pivotdata.gdx o=%workbook% par=%item% rng=%item%!a2 cdim=0';
execute 'rm pivotdata.gdx';

