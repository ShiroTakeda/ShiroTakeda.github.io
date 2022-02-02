$ontext
Time-stamp:     <2022-01-23 11:43:03 st>
First-written:  <2017/03/24>
$offtext

*       外生変数の初期化
q_inv_bar = q_inv_bar0;
q_gov_bar = q_gov_bar0;
end_hh(i) = end_hh0(i);
ts_bar = ts_bar0;
v_bar(f) = v_bar0(f);

rt_c(i) = rt_c0(i);
rt_f(f,j) = rt_f0(f,j);
rt_inc(f) = rt_inc0(f);
rt_m(i) = rt_m0(i);
rt_y(j) = rt_y0(j);

p_d.fx("agr") = p_d0("agr");

if(c_scn("bnch"),

* 何もなし

);

if(c_scn("nume"),

    p_d.fx("agr") = p_d0("agr") * 1.1;

);

if(c_scn("prop"),

    q_inv_bar = q_inv_bar0 * 1.05;
    q_gov_bar = q_gov_bar0 * 1.05;
    end_hh(i) = end_hh0(i) * 1.05;
    ts_bar = ts_bar0 * 1.05;
    v_bar(f) = v_bar0(f) * 1.05;

);

if(c_scn("labi"),

    v_bar("LAB") = v_bar0("LAB") * 1.05;

);

if(c_scn("prop_"),

    q_inv_bar = q_inv_bar0 * 1.05;
    q_gov_bar = q_gov_bar0 * 1.05;
    end_hh(i) = end_hh0(i) * 1.05;
    ts_bar = ts_bar0 * 1.05;
    v_bar(f) = v_bar0(f) * 1.05;

);

if(c_scn("ftrd"),

    rt_m(i) = 0;

);

if(c_scn("cont"),

    rt_c(i) = 0.05;

);

if(c_scn("linc"),

    rt_inc("LAB") = 0.4;

);

if(c_scn("rmtx"),

    rt_c(i) = 0;
    rt_f(f,j) = 0;
    rt_inc(f) = 0;
    rt_m(i) = 0;
    rt_y(j) = 0;

);

if(c_scn("prdt"),

    rt_y(j) = rt_y0(j) * 1.2;

);

if(c_scn("elyt"),

    rt_y(j)$s_ely(j) = rt_y0(j)$s_ely(j) * 1.2;

);

display q_inv_bar, q_gov_bar, end_hh, ts_bar, v_bar;

display rt_c, rt_f, rt_inc, rt_m, rt_y;



* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* coding: utf-8-dos
* End:

