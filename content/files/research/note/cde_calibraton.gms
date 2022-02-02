$title  Calibraton of parameters of CDE function.
display "@ Calibraton of parameters of CDE function.";
$ontext
First-written:	<2006/06/07>
Time-stamp: 	<2012-12-05 18:42:12 >

$offtext

*	If you want to use MCP solver
$setglobal solve_mcp 1
*	If you want to use NLP solver
$setglobal solve_nlp 1

set	i Index of goods / 1, 2, 3, 4 /;
alias(ii,i);
set	first(i);
first("2") = yes;
display i, ii, first;

parameter u0, e0, c0(i), p0(i), gamma(i), sigma(i) ;

p0("1") = 1.05;
p0("2") = 1.1;
p0("3") = 0.95;
p0("4") = 0.8;

c0("1") = 50;
c0("2") = 20;
c0("3") = 90;
c0("4") = 60;
e0 = sum(i, p0(i)*c0(i));
u0 = e0 * 2;
display p0, c0, e0, u0;

gamma("1") = 0.3;
gamma("2") = 0.4;
gamma("3") = 0.5;
gamma("4") = 0.6;

sigma("1") = 0.6;
sigma("2") = 0.9;
sigma("3") = 0.7;
sigma("4") = 0.6;

* gamma("1") = 1;
* gamma("2") = 1;
* gamma("3") = 1;
* sigma("1") = 2;
* sigma("2") = 2;
* sigma("3") = 2;

display gamma, sigma;

variable
    beta(i)
    dummy_obj;

equations
    e_beta(i)
    e_dummy_obj;

e_beta(i) ..

    (1 - sum(ii, beta(ii)**(sigma(ii)) * u0**((1-sigma(ii))*gamma(ii))
	* (p0(ii)/e0)**(1-sigma(ii))))$first(i)
    + ( c0(i) -
	( beta(i)**sigma(i) * u0**((1-sigma(i)) * gamma(i)) * (1-sigma(i))
	    * (p0(i)/e0)**(-sigma(i)) )
	/ sum(ii,
	    beta(ii)**sigma(ii) * u0**((1-sigma(ii)) * gamma(ii)) * (1-sigma(ii))
	    * (p0(ii)/e0)**(1-sigma(ii)) )
    )$(not first(i))
    =e= 0;

e_dummy_obj ..

    dummy_obj =e= 1;

model calib_mcp calibraton / e_beta.beta /;
model calib_nlp calibraton / e_beta, e_dummy_obj /;
option nlp = conopt;

parameter
    chk_beta
    chk_res;

if(%solve_mcp%,
*	----------------------------------------------------------------------
    display "@ MCP";

    beta.lo(i) = 1e-6;
    beta.l(i) = 0.01;
    dummy_obj.l = 1;

    solve calib_mcp using mcp;

    chk_beta(i,"mcp") = beta.l(i);

    chk_res(i,"mcp") =
	( beta.l(i)**sigma(i) * u0**((1-sigma(i)) * gamma(i)) * (1-sigma(i))
	    * (p0(i)/e0)**(-sigma(i)) )
	    / sum(ii,
		beta.l(ii)**sigma(ii) * u0**((1-sigma(ii)) * gamma(ii)) * (1-sigma(ii))
		* (p0(ii)/e0)**(1-sigma(ii)) );

    chk_res("u","mcp")
	= sum(i, beta.l(i)**(sigma(i)) * u0**((1-sigma(i))*gamma(i))
	    * (p0(i)/e0)**(1-sigma(i))) - 1;

    chk_res("e","mcp") = sum(i, p0(i) * chk_res(i,"mcp"));

);

if(%solve_nlp%,
*	----------------------------------------------------------------------
    display "@ NLP";

    beta.lo(i) = 1e-6;
    beta.l(i) = 0.01;
    dummy_obj.l = 1;

    solve calib_nlp using nlp minimizing dummy_obj;

    chk_beta(i,"nlp") = beta.l(i);

    chk_res(i,"nlp") =
	( beta.l(i)**sigma(i) * u0**((1-sigma(i)) * gamma(i)) * (1-sigma(i))
	    * (p0(i)/e0)**(-sigma(i)) )
	    / sum(ii,
		beta.l(ii)**sigma(ii) * u0**((1-sigma(ii)) * gamma(ii)) * (1-sigma(ii))
		* (p0(ii)/e0)**(1-sigma(ii)) );

    chk_res("u","nlp")
	= sum(i, beta.l(i)**(sigma(i)) * u0**((1-sigma(i))*gamma(i))
	    * (p0(i)/e0)**(1-sigma(i))) - 1;

    chk_res("e","nlp") = sum(i, p0(i) * chk_res(i,"mcp"));
);

display chk_beta;
display chk_res;

* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* End:
