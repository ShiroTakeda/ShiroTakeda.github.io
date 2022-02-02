$title  Normalization of benchmark prices:
display "com: Normalization of benchmark prices:";
$ontext
Time-stamp: 	<2009-12-01 20:30:16 Shiro Takeda>
$Id$
Author: 	Shiro Takeda <shiro.takeda@gmail.com>
First-written:	<2008/10/22>

This is a program to show that results of the simulation (% changes in
variables) do not depend on the way of normalization of benchmark prices.

[Two cases]

Case 1: All benchmark prices are normalized to unity.

Case 2: Benchmark prices are not normalized to unity:

$offtext

*	----------------------------------------------------------------------
*	Parameters for benchmark data:
display "com: Parameters for benchmark data:";

*	SAM data:
table sam       "Sample SAM (Social Accounting Matrix)"
          x        y        u        h
px      140      -40     -100
py      -20      240     -220
r       -40     -120               160
w       -60      -80               140
pu                        320     -320
tk	-20                         20
;
display sam;

*	Parameters for benchmark value:
parameter
    v_o_x0	Benchmark value of output of x
    v_o_y0	Benchmark value of output of y
    v_i_xy0	Benchmark value of input of x in sector y
    v_i_yx0	Benchmark value of input of y in sector x
    v_k_x0	Benchmark value of input of capital in sector x
    v_k_y0	Benchmark value of input of capital in sector y
    v_l_x0	Benchmark value of input of labor in sector x
    v_l_y0	Benchmark value of input of labor in sector y
    v_c_x0	Benchmark value of consumption of x
    v_c_y0	Benchmark value of consumption of y
    v_u0	Benchmark value of utility
    v_k0	Benchmark value of capital endowment
    v_l0	Benchmark value of labor endowment
    v_h0	Benchmark value of household income
    v_tk_x0	Benchmark value of tax on capital in sector x
    v_t0	Benchmark value of tax revenue
;
v_o_x0 = sam("px","x");
v_o_y0 = sam("py","y");
v_i_xy0 = - sam("px","y");
v_i_yx0	= - sam("py","x");
v_k_x0 = - sam("r","x");
v_k_y0 = - sam("r","y");
v_l_x0 = - sam("w","x");
v_l_y0 = - sam("w","y");
v_c_x0 = - sam("px","u");
v_c_y0 = - sam("py","u");
v_tk_x0 = - sam("tk","x");

v_u0 = v_c_x0 + v_c_y0;
v_k0 = v_k_x0 + v_k_y0;
v_l0 = v_l_x0 + v_l_y0;
v_h0 = v_u0;

display v_o_x0, v_o_y0, v_i_xy0, v_i_yx0, v_k_x0, v_k_y0, v_l_x0, v_l_y0,
	v_c_x0, v_c_y0, v_u0, v_k0, v_l0, v_h0;

*	Parameters for benchmark price:
parameter
    p_x0	Benchmark price of x
    p_y0	Benchmark price of y
    r0		Benchmark price of capital
    w0		Benchmark price of labor
    p_u0	Benchmark price of utility
;
parameter
    tk0		Benchmark tax rate on capital in sector x;

*	Parameters for benchmark quantity:
parameter
    q_x0	Benchmark output of x
    q_y0	Benchmark output of y
    int_yx0	Benchmark input of y in sector x
    int_xy0	Benchmark input of x in sector y
    k_x0	Benchmark input of k in sector x
    k_y0	Benchmark input of k in sector y
    l_x0	Benchmark input of l in sector x
    l_y0	Benchmark input of l in sector y
    c_x0	Benchmark consumption of x
    c_y0	Benchmark consumption of y
    u0		Benchmark utility

    k0		Benchmark capital endowment
    l0		Benchmark labor endowment
;

*	EOS parameters in production and utility functions:
parameter
    sig_va	EOS: capital vs labor in production
    sig_u	EOS: consumption of x and y in utility
;
sig_va = 0.5;
sig_u = 1;

*	Tax rate and other parameters:
parameter
    tk		Tax rate on capital in sector x
    scale_k	Scale factor for capital
    scale_l	Scale factor for labor
;
scale_k = 1;
scale_l = 1;
display scale_k, scale_l;

*	----------------------------------------------------------------------
*	Specification of functional forms:
display "com: Specification of functional forms:";
$ontext

Production functions:

+ Production function of sector x:

  Two stage CES: the first stage is Leontief type and the second stage is CES.

                Output of sector x
               /  \  <-- Leontief
             /      \
           /          \
          y          /  \  <-- CES with elasticity sig_va
     Intermediate  /      \
     input       /          \
                K            L

  The same type of production function is applied to sector y.

+ Utility function:

                Utility
               /  \  <-- CES with elasticity sig_u
             /      \
           /          \
          x            y
     Consumtpion   Consumtpion
       of x          of y

$offtext

*	----------------------------------------------------------------------
*	Model by MPSGE:
display "com: Model by MPSGE:";

$ontext

$model:price_norm

$sectors:
    q_x		! Output of x
    q_y		! Output of y
    u		! Utility

$commodities:
    p_x		! Price of x
    p_y		! Price of y
    r		! Price of capital
    w		! Price of labor
    p_u		! Price of utility

$consumer:
    h 		! Income of a representative household

*	Production function of sector x:
$prod:q_x	s:0  va:sig_va
    o:p_x	q:q_x0		p:p_x0
    i:p_y	q:int_yx0	p:p_y0
    i:r		q:k_x0		p:((1+tk0)*r0)	a:h  t:tk  va:
    i:w		q:l_x0		p:w0  		va:

*	Production function of sector y:
$prod:q_y	s:0  va:sig_va
    o:p_y	q:q_y0		p:p_y0
    i:p_x	q:int_xy0	p:p_x0
    i:r		q:k_y0		p:r0	va:
    i:w		q:l_y0		p:w0	va:

*	Utility function:
$prod:u		s:sig_u
    o:p_u	q:u0		p:p_u0
    i:p_x	q:c_x0		p:p_x0
    i:p_y	q:c_y0		p:p_y0

*	Income:
$demand:h
    d:p_u	q:u0
    e:r		q:(scale_k*k0)
    e:w		q:(scale_l*l0)

$offtext

$sysinclude mpsgeset price_norm

parameter
    report_result	Parameter for reporting results (check that % changes in variables are the same in both two cases)
;

*	----------------------------------------------------------------------
*	Case 1: all benchmark prices are normalized to unity:
display "com: Case 1: all benchmark prices are normalized to unity:";

*	All benchmark prices are normalized to unity:
p_x0 = 1;
p_y0 = 1;
r0 = 1;
w0 = 1;
p_u0 = 1;
display p_x0, p_y0, r0, w0, p_u0;

*	Derivation of benchmark quantity:
q_x0 = v_o_x0 / p_x0;
q_y0 = v_o_y0 / p_y0;
int_yx0 = v_i_yx0 / p_y0;
int_xy0 = v_i_xy0 / p_x0;
k_x0 = v_k_x0 / r0;
k_y0 = v_k_y0 / r0;
l_x0 = v_l_x0 / w0;
l_y0 = v_l_y0 / w0;
c_x0 = v_c_x0 / p_x0;
c_y0 = v_c_y0 / p_y0;
u0 = v_u0 / p_u0;
k0 = v_k0 / r0;
l0 = v_l0/ w0;
display q_x0, q_y0, int_yx0, int_xy0, k_x0, k_y0, l_x0, l_y0, c_x0, c_y0, u0, k0, l0;

tk0 = v_tk_x0 / (r0 * k_x0);
display tk0;
tk = tk0;

*	----------------------------------------------------------------------
*	Benchmark replication.
display "com: Benchmark replication.";

*	Initialization of endogenous variables:
q_x.l = 1;
q_y.l = 1;
u.l = 1;
p_x.l = p_x0;
p_y.l = p_y0;
r.l = r0;
w.l = w0;
p_u.l = p_u0;
h.l = v_h0;

price_norm.iterlim = 0;
$include price_norm.gen
solve price_norm using mcp;

*	----------------------------------------------------------------------
*	Cleanup calculation.
display "com: Cleanup calculation.";
price_norm.iterlim = 10000;
$include price_norm.gen
solve price_norm using mcp;

*	----------------------------------------------------------------------
*	Counter-factual experiment: a rise in labor endowment
display "com: Counter-factual experiment: a rise in labor endowment";

scale_k = 1.03;
$include price_norm.gen
solve price_norm using mcp;
scale_k = 1.0;

report_result("q_x","Case1") = 100 * (q_x.l - 1);
report_result("q_y","Case1") = 100 * (q_y.l - 1);
report_result("u","Case1") = 100 * (u.l - 1);
report_result("p_x","Case1") = 100 * ((p_x.l/p_u.l)/(p_x0/p_u0) - 1);
report_result("p_y","Case1") = 100 * ((p_y.l/p_u.l)/(p_y0/p_u0) - 1);
report_result("w","Case1") = 100 * ((w.l/p_u.l)/(w0/p_u0) - 1);
report_result("r","Case1") = 100 * ((r.l/p_u.l)/(r0/p_u0) - 1);
report_result("h","Case1") = 100 * ((h.l/p_u.l)/(v_h0/p_u0) - 1);

*	----------------------------------------------------------------------
*	Case 2: benchmark prices are not normalized to unity:
display "com: Case 2: benchmark prices are not normalized to unity:";

*	Normalization ofbenchmark prices (not equal to unity):
p_x0 = 2;
p_y0 = 3;
r0 = 4;
w0 = 0.5;
p_u0 = 1;
display p_x0, p_y0, r0, w0, p_u0;

*	Derivation of benchmark quantity:
q_x0 = v_o_x0 / p_x0;
q_y0 = v_o_y0 / p_y0;
int_yx0 = v_i_yx0 / p_y0;
int_xy0 = v_i_xy0 / p_x0;
k_x0 = v_k_x0 / r0;
k_y0 = v_k_y0 / r0;
l_x0 = v_l_x0 / w0;
l_y0 = v_l_y0 / w0;
c_x0 = v_c_x0 / p_x0;
c_y0 = v_c_y0 / p_y0;
u0 = v_u0 / p_u0;
k0 = v_k0 / r0;
l0 = v_l0/ w0;
display q_x0, q_y0, int_yx0, int_xy0, k_x0, k_y0, l_x0, l_y0, c_x0, c_y0, u0, k0, l0;

tk0 = v_tk_x0 / (r0 * k_x0);
display tk0;
tk = tk0;

*	----------------------------------------------------------------------
*	Benchmark replication.
display "com: Benchmark replication.";

*	Initialization of endogenous variables:
q_x.l = 1;
q_y.l = 1;
u.l = 1;
p_x.l = p_x0;
p_y.l = p_y0;
r.l = r0;
w.l = w0;
p_u.l = p_u0;
h.l = v_h0;

price_norm.iterlim = 0;
$include price_norm.gen
solve price_norm using mcp;

*	----------------------------------------------------------------------
*	Cleanup calculation.
display "com: Cleanup calculation.";
price_norm.iterlim = 10000;
$include price_norm.gen
solve price_norm using mcp;

*	----------------------------------------------------------------------
*	Counter-factual experiment: a rise in labor endowment
display "com: Counter-factual experiment: a rise in labor endowment";

scale_k = 1.03;
$include price_norm.gen
solve price_norm using mcp;
scale_k = 1.0;

report_result("q_x","Case2") = 100 * (q_x.l - 1);
report_result("q_y","Case2") = 100 * (q_y.l - 1);
report_result("u","Case2") = 100 * (u.l - 1);
report_result("p_x","Case2") = 100 * ((p_x.l/p_u.l)/(p_x0/p_u0) - 1);
report_result("p_y","Case2") = 100 * ((p_y.l/p_u.l)/(p_y0/p_u0) - 1);
report_result("w","Case2") = 100 * ((w.l/p_u.l)/(w0/p_u0) - 1);
report_result("r","Case2") = 100 * ((r.l/p_u.l)/(r0/p_u0) - 1);
report_result("h","Case2") = 100 * ((h.l/p_u.l)/(v_h0/p_u0) - 1);

*	----------------------------------------------------------------------
*	Compare results in two cases:
display "com: Compare results in two cases:";
$ontext

Check that results from two experiments are identical.

$offtext
display report_result;

* --------------------
* local Variables:
* mode: gams
* fill-column: 80
* End:
