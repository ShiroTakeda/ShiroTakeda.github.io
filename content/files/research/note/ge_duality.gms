$title  A sample GAMS program.
display "com: A sample GAMS program.";
$ontext
Copyright (C)   2004 Shiro Takeda
Time-stamp: 	<2011-02-17 15:19:14 Shiro Takeda>
First-written:	<2004/10/26>
$offtext


parameter
    fl_alt_dual	Non-zero if the alternative dual approach;
fl_alt_dual = 0;

*	----------------------------------------------------------------------
*	Set definitions:
set	i	Index of goods and sectors	/ 1, 2 /;
display i;

*	----------------------------------------------------------------------
*	Parameter definitions:
parameter
    phi(i)	Scale parameter in production functions
    psi		Scale parameter in utility function
    alpha(i)	Share of capital in production functions
    beta(i)	Share parameter in utility function
;
alpha("1") = 0.4;
alpha("2") = 0.6;
beta("1") = 2/3;
beta("2") = 1 - beta("1");
display alpha, beta;

phi("1") = 200 / ((80)**(alpha("1")) * (120)**(1-alpha("1")));
phi("2") = 100 / ((60)**(alpha("2")) * (40)**(1-alpha("2")));
display phi;

psi = 300 / ((200)**(beta("1")) * (100)**(beta("2")));
display psi;

*	----------------------------------------------------------------------
*	Declare exogenous variables
parameter
    end_l	Labor endowment		/ 160 /
    end_k	Capital endowment	/ 180 /;
display end_l, end_k;

*	----------------------------------------------------------------------
*	Declare variables
variables
*	Variables for traditional approach
    q(i)	Output
    k(i)	Capital input
    l(i)	Labor input
    p(i)	Goods prices
    r		Rental price
    w		Wage rate
    m		Income

*	Variables for dual approach
    q_(i)	Output
    c_(i)	Unit cost
    a_k_(i)	Unit demand for capital
    a_l_(i)	Unit demand for labor
    u_		"Utility (output of utility production)"
    c_u_	"Unit expenditure (unit cost for utility production)"
    a_c_(i)	Unit demand for consumption
    m_		Income
    p_(i)	Goods prices
    r_		Rental price
    w_		Wage rate

*	Additional variables for alternative dual approach:
    p_u_	Price of utility
;
*	----------------------------------------------------------------------
*	Declare equations
equations
*	Equations for traditional approach
    e_q(i)	Output
    e_k(i)	Capital input
    e_l(i)	Labor input
    e_p(i)	Goods price
    e_r		Rental price
    e_w		Wage rate
    e_m		Income

*	Equations for dual approach
    e_q_(i)	Output
    e_c_(i)	Unit cost
    e_a_k_(i)	Unit demand for capital
    e_a_l_(i)	Unit demand for labor
    e_u_	"Utility (output of utility production)"
    e_c_u_	"Unit expenditure (unit cost for utility production)"
    e_a_c_(i)	Unit demand for consumption
    e_m_	Income
    e_p_(i)	Goods prices
    e_r_	Rental price
    e_w_	Wage rate

*	Additional equations for alternative dual approach:
    e_p_u_	Price of utility
    e_u_alt	"Utility (output of utility production)"
;

*	----------------------------------------------------------------------
*	Definitions of equations for traditional approach:

*	Production function:
e_q(i) ..

    phi(i) * (k(i))**(alpha(i)) * (l(i))**(1-alpha(i)) =e= q(i);

*	FOC of profit maximization w.r.t captial:
e_k(i) ..

    r =e= p(i) * phi(i) * alpha(i) * (l(i)/k(i))**(1-alpha(i));

*	FOC of profit maximization w.r.t labor:
e_l(i) ..

    w =e= p(i) * phi(i) * (1-alpha(i)) * (k(i)/l(i))**(alpha(i));

*	Income:
e_m ..

    r * end_k + w * end_l =e= m;

*	Market for capital:
e_r ..

    end_k =e= sum(i, k(i));

*	Market for labor:
e_w ..

    end_l =e= sum(i, l(i));

*	Market for goods:
e_p(i) ..

    q(i) =e= beta(i) * m / p(i);

*	----------------------------------------------------------------------
*	Model declaration for traditional approach:
model ge_trad Traditional approach /
      e_q.q, e_k.k, e_l.l, e_m.m, e_r.r, e_w.w, e_p.p /;

*	----------------------------------------------------------------------
*	Definitions of equations for dual approach:

*	FOC of profit maximization:
e_q_(i) ..

    c_(i) =e= p_(i);

*	Unit cost function:
e_c_(i) ..

    c_(i) =e= (1/phi(i))
    * (r_ / alpha(i))**(alpha(i)) * (w_ / (1-alpha(i)))**(1-alpha(i));

*	Unit demand for capital:
e_a_k_(i) ..

    a_k_(i) =e= alpha(i) * c_(i) / r_;

*	Unit demand for labor:
e_a_l_(i) ..

    a_l_(i) =e= (1-alpha(i)) * c_(i) / w_;

*	Utility maximization:
e_u_ ..

    (c_u_ * u_ - m_)$(not fl_alt_dual)
    + (c_u_ - p_u_)$fl_alt_dual =e= 0;

*	Unit expenditure function:
e_c_u_ ..

    c_u_ =e= (1/psi) * prod(i, (p_(i)/beta(i))**(beta(i)));

*	Unit consumption demand:
e_a_c_(i) ..

    a_c_(i) =e= beta(i) * c_u_ / p_(i);

*	Income:
e_m_ ..

    r_ * end_k + w_ * end_l =e= m_;

*	Market for goods:
e_p_(i) ..

    q_(i) =e= a_c_(i) * u_;

*	Market for utility:
e_p_u_$fl_alt_dual ..

    u_ =e= m_ / p_u_;

*	Market for capital:
e_r_ ..

    end_k =e= sum(i, a_k_(i) * q_(i));

*	Market for labor:
e_w_ ..

    end_l =e= sum(i, a_l_(i) * q_(i));

*	----------------------------------------------------------------------
*	Model declaration for dual approach:
model ge_dual Dual approach /
      e_q_.q_, e_c_.c_, e_a_k_.a_k_, e_a_l_.a_l_, e_u_.u_, e_c_u_.c_u_,
      e_a_c_.a_c_, e_m_.m_, e_p_.p_, e_r_.r_, e_w_.w_ /;

model ge_dual_alt Alternative dual approach /
      e_q_.q_, e_c_.c_, e_a_k_.a_k_, e_a_l_.a_l_, e_u_.u_, e_c_u_.c_u_,
      e_a_c_.a_c_, e_m_.m_, e_p_.p_, e_p_u_.p_u_, e_r_.r_, e_w_.w_ /;

*	----------------------------------------------------------------------
*	Lower bound for variables:
q.lo(i) = 1e-6;
k.lo(i) = 1e-6;
l.lo(i) = 1e-6;
p.lo(i) = 1e-6;
r.lo = 1e-6;
w.lo = 1e-6;
m.lo = 1e-6;

q_.lo(i) = 1e-6;
c_.lo(i) = 1e-6;
a_k_.lo(i) = 1e-6;
a_l_.lo(i) = 1e-6;
u_.lo = 1e-6;
c_u_.lo = 1e-6;
a_c_.lo(i) = 1e-6;
m_.lo = 1e-6;
p_.lo(i) = 1e-6;
r_.lo = 1e-6;
w_.lo = 1e-6;

p_u_.lo = 1e-6;

*	----------------------------------------------------------------------
*	Initial variables for variables:
q.l("1") = 200;
q.l("2") = 100;
k.l("1") = 80;
k.l("2") = 60;
l.l("1") = 120;
l.l("2") = 40;
l.l(i) = 1;
p.l(i) = 1;
r.l = 1;
w.l = 1;
m.l = 300;

q_.l("1") = 200;
q_.l("2") = 100;
c_.l(i) = 1;
a_k_.l("1") = 80/200;
a_k_.l("2") = 60/100;
a_l_.l("1") = 120/200;
a_l_.l("2") = 40/100;
u_.l = 300;
c_u_.l = 1;
a_c_.l("1") = 200/300;
a_c_.l("2") = 100/300;
m_.l = 300;
p_.l(i) = 1;
r_.l = 1;
w_.l = 1;

p_u_.l = 1;

*	----------------------------------------------------------------------
*	Set numeraire goods (labor):
w.fx = 1;
w_.fx = 1;

*	----------------------------------------------------------------------
*	Solve two models:
display "com: Solve two models:";

parameter
    res		Compare results from two alternative models;

*	Traditional approach:
solve ge_trad using mcp;

res("q1","trad") = q.l("1");
res("q2","trad") = q.l("2");
res("c1","trad") = beta("1") * m.l / p.l("1");
res("c2","trad") = beta("2") * m.l / p.l("2");
res("util","trad")
    = psi * (res("c1","trad"))**(beta("1")) * (res("c2","trad"))**(beta("2"));

*	Dual approach:
solve ge_dual using mcp;

res("q1","dual") = q_.l("1");
res("q2","dual") = q_.l("2");
res("c1","dual") = a_c_.l("1") * u_.l;
res("c2","dual") = a_c_.l("2") * u_.l;
res("util","dual") = u_.l;
display res;

*	Alternative dual approach:
fl_alt_dual = 1;
solve ge_dual_alt using mcp;
fl_alt_dual = 0;

res("q1","dual_") = q_.l("1");
res("q2","dual_") = q_.l("2");
res("c1","dual_") = a_c_.l("1") * u_.l;
res("c2","dual_") = a_c_.l("2") * u_.l;
res("util","dual_") = u_.l;
display res;

*	----------------------------------------------------------------------
*	Changes in factor endowments:
display "com: Changes in factor endowments:";

end_l = 1.2 * end_l;
end_k = 0.9 * end_k;
display end_l, end_k;

*	Traditional approach:
solve ge_trad using mcp;

res("q1","trad") = q.l("1");
res("q2","trad") = q.l("2");
res("c1","trad") = beta("1") * m.l / p.l("1");
res("c2","trad") = beta("2") * m.l / p.l("2");
res("util","trad")
    = psi * (res("c1","trad"))**(beta("1")) * (res("c2","trad"))**(beta("2"));

*	Dual approach:
solve ge_dual using mcp;

res("q1","dual") = q_.l("1");
res("q2","dual") = q_.l("2");
res("c1","dual") = a_c_.l("1") * u_.l;
res("c2","dual") = a_c_.l("2") * u_.l;
res("util","dual") = u_.l;
display res;


*	Alternative dual approach:
fl_alt_dual = 1;
solve ge_dual_alt using mcp;
fl_alt_dual = 0;

res("q1","dual_") = q_.l("1");
res("q2","dual_") = q_.l("2");
res("c1","dual_") = a_c_.l("1") * u_.l;
res("c2","dual_") = a_c_.l("2") * u_.l;
res("util","dual_") = u_.l;
display res;

* --------------------
* Local Variables:
* mode: gams
* fill-column: 78
* End:
