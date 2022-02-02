$title  A sample MPSGE program including technological change:
$ontext
Time-stamp: 	<2009-12-01 21:40:15 Shiro Takeda>
First-written:	<2006/07/17>

[Two experiments]
Case 1 -> Reference quantity の生産性パラメータを上昇
Case 2 -> Reference quantity & price の生産性パラメータを上昇

Case 2 が適切に技術進歩を考慮したケース。

[Results]
Case 1 と case 2 で生産量の伸び率が異なってくる。
Case 1 の場合、Cobb-Doublas 型関数であるのに、要素の投入シェアが変わってしまう。

$offtext

*	Set definition:
set	f	Index of factor	/ k, l /;
display f;

*	Parameter definition:
parameter
    q0		Reference output
    x0(f)	Reference input
    p0		Reference price of output
    pf0(f)	Reference price of factors
    end0(f)	Endowment of factors

    lambda_q(f)	Efficiency parameter
    lambda_p(f)	Efficiency parameter
;
q0 = 100;
x0("k") = 0.3 * q0;
x0("l") = q0 - x0("k");
p0 = 1;
pf0(f) = 1;
end0(f) = x0(f);
lambda_q(f) = 1;
lambda_p(f) = 1;
display q0, x0, p0, pf0, end0, lambda_q, lambda_p;

*	----------------------------------------------------------------------
*	MPSGE code:
$ontext
$model:sample

$sectors:
    q 		! Output

$commodities:
    p 		! Output price
    pf(f)	! Price of primary factor

$consumers:
    ra 		! Representative agent

$prod:q		s:1
    o:p		q:q0
    i:pf(f)	q:(x0(f)/lambda_q(f))	p:(pf0(f)*lambda_p(f))

$report:
    v:x(f)	i:pf(f)		prod:q 	! Quantity of input

$demand:ra
    d:p		q:q0
    e:pf(f)	q:end0(f)

$offtext

$sysinclude mpsgeset sample

parameter
    result	Compare two results;

*	----------------------------------------------------------------------
*	Benchmark replication.
sample.iterlim = 0;
$include sample.gen
solve sample using mcp;
result("Bench","q") = q.l;
result("Bench","Sh_k") = pf.l("k") * x.l("k") / (sum(f, pf.l(f) * x.l(f)));
result("Bench","Sh_l") = pf.l("l") * x.l("l") / (sum(f, pf.l(f) * x.l(f)));
result("Bench","v_k") = pf.l("k") * x.l("k") / p.l;
result("Bench","v_l") = pf.l("l") * x.l("l") / p.l;
sample.iterlim = 9000;

*	----------------------------------------------------------------------
*	Increase only in lambda_q:
lambda_q("k") = 2;

$include sample.gen
solve sample using mcp;
result("Case1","q") = q.l;
result("Case1","Sh_k") = pf.l("k") * x.l("k") / (sum(f, pf.l(f) * x.l(f)));
result("Case1","Sh_l") = pf.l("l") * x.l("l") / (sum(f, pf.l(f) * x.l(f)));
result("Case1","v_k") = pf.l("k") * x.l("k") / p.l;
result("Case1","v_l") = pf.l("l") * x.l("l") / p.l;

*	----------------------------------------------------------------------
*	Increase both in lambda_q and lambda_p:
lambda_q("k") = 2;
lambda_p("k") = 2;

sample.iterlim = 9000;
$include sample.gen
solve sample using mcp;
result("Case2","q") = q.l;
result("Case2","Sh_k") = pf.l("k") * x.l("k") / (sum(f, pf.l(f) * x.l(f)));
result("Case2","Sh_l") = pf.l("l") * x.l("l") / (sum(f, pf.l(f) * x.l(f)));
result("Case2","v_k") = pf.l("k") * x.l("k") / p.l;
result("Case2","v_l") = pf.l("l") * x.l("l") / p.l;

display result;

* --------------------
* Local Variables:
* mode: gams
* fill-column: 90
* End:
