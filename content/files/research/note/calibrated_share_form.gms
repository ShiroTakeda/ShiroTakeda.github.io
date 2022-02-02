$title  Calibrated share form�ɂ��CES�֐��̕\��
display "com: Calibrated share form�ɂ��CES�֐��̕\��";
$ontext
Copyright (C)   2012 Shiro Takeda
Time-stamp: 	<2012-07-16 21:22:17 Shiro Takeda>
Author: 	Shiro Takeda <zbc08106@park.zero.ad.jp>
First-written:	<2012/07/16>

�������f����

* Normal form��CES�֐�
* Calibrated share form��CES�֐�

�̗�����p���ċL�q����B

�ǂ���������ł��邱�Ƃ��m�F����B


�����́A���c�j�Y�A�uCES�֐���calibrated share form�v���Q�ƁB

$offtext

$ontext
Time-stamp: 	<2010-04-01 19:46:14 Shiro Takeda>
First-written:	<2010/03/12>

�� SAM (�x���`�}�[�N�f�[�^)
           |         Sectors         |  Consumers 
Commoditiy |          (����)         |   (�����)
   (��)    |    x       y        u   |    cons
-----------------------------------------------------
       px  |  100             -100   |
       py  |          100     -100   |
       pu  |                   200   |    -200
       pl  |  -25     -75            |     100
       pk  |  -75     -25            |     100
-----------------------------------------------------


�� ���Y�֐�

+ x�����y��������{�ƘJ���݂̂𗘗p����B
+ x�����CES�֐��Ay�����Cobb-Douglas�֐��Ƃ���B

x����
         x
        / \ <- sig_x
       /   \
      /     \
     k      l

�E��ւ̒e�͐�sig_x��CES�֐��B

y����
         y
        / \ <- 1
       /   \
      /     \
     k      l

�ECobb-Douglas�֐��D

���p�֐�
         y
        / \ <- sig_u
       /   \
      /     \
     k      l

�E��ւ̒e�͐�sig_u��CES�֐�

$offtext

*	----------------------------------------------------------------------
*	�x���`�}�[�N�E�f�[�^:
display "com: �x���`�}�[�N�E�f�[�^:";

table	sam	�x���`�}�[�N�f�[�^
          x       y        u     cons
px      100             -100    
py              100     -100    
pu                       200     -200
pl      -25     -75               100
pk      -75     -25               100
;
display sam;

parameter
    px0		x ���̃x���`�}�[�N�s�ꉿ�i
    py0		y ���̃x���`�}�[�N�s�ꉿ�i
    pu0		u ���̃x���`�}�[�N�s�ꉿ�i
    pk0		���{�̃x���`�}�[�N�s�ꉿ�i
    pl0		�J���̃x���`�}�[�N�s�ꉿ�i
;

px0 = 1;
py0 = 1;
pu0 = 1;
pk0 = 1;
pl0 = 1;
display px0, py0, pu0, pk0, pl0;

parameter
    x0		x ���̃x���`�}�[�N���Y��
    y0		y ���̃x���`�}�[�N���Y��
    kx0		x ����ɂ����鎑�{�̃x���`�}�[�N������
    ky0		y ����ɂ����鎑�{�̃x���`�}�[�N������
    lx0		x ����ɂ�����J���̃x���`�}�[�N������
    ly0		y ����ɂ�����J���̃x���`�}�[�N������
;

x0 = sam("px","x") / px0;
y0 = sam("py","y") / py0;
kx0 = - sam("pk","x") / pk0;
ky0 = - sam("pk","y") / pk0;
lx0 = - sam("pl","x") / pl0;
ly0 = - sam("pl","y") / pl0;

display x0, y0, kx0, ky0, lx0, ly0;

parameter
    u0		�x���`�}�[�N�̌��p����
    cx0		x ���̃x���`�}�[�N�����
    cy0		y ���̃x���`�}�[�N�����
;
u0 = sam("pu","u") / pu0;
cx0 = - sam("px","u") / px0;
cy0 = - sam("py","u") / py0;

display u0, cx0, cy0;

parameter
    end_l	�J���̕�����
    end_k	���{�̕�����
    inc0	�x���`�}�[�N����
;
end_l = sam("pl","cons") / pl0;
end_k = sam("pk","cons") / pk0;
inc0 = - sam("pu","cons");

display end_l, end_k, inc0;

*	----------------------------------------------------------------------
*	���̑��̃p�����[�^�D
display "com: ���̑��̃p�����[�^�D";

parameter
    sig_x	EOS: ���� x �ɂ����鎑�{�E�J���� EOS	/ 0.5 /
    sig_u	EOS: ���p�֐����� EOS			/ 2.0 /
;
display sig_x;

parameter
    s_l		�J�������ʂ̃X�P�[���t�@�N�^�[	/ 1.0 /
    s_k		���{�����ʂ̃X�P�[���t�@�N�^�[	/ 1.0 /
;
display s_l, s_k;

*	======================================================================
*	Normal form�́iCalibrated share form�𗘗p���Ȃ��j�L�q
*	======================================================================
$ontext

�֐��`

x = (alpha_k_x*k_x**((sig_x-1)/sig_x) + alpha_l_x*l_x**((sig_x-1)/sig_x))**(sig_x/(sig_x-1))

y = phi_y * (k_y**(sh_k_y) * l_y**(sh_l_y))

u = (alpha_x_u*x**((sig_u-1)/sig_u) + alpha_y_u*y**((sig_u-1)/sig_u))**(sig_u/(sig_u-1))

$offtext

parameter
    sh_k_x	x����̐��Y�֐��̃E�F�C�g�p�����[�^
    sh_l_x	x����̐��Y�֐��̃E�F�C�g�p�����[�^
    sh_x_u	���p�֐��̃E�F�C�g�p�����[�^
    sh_y_u	���p�֐��̃E�F�C�g�p�����[�^

    alpha_k_x	x����̐��Y�֐��̃E�F�C�g�p�����[�^
    alpha_l_x	x����̐��Y�֐��̃E�F�C�g�p�����[�^

    phi_y	y����̐��Y�֐��̃X�P�[��
    sh_k_y	y����̐��Y�֐��̃V�F�A�p�����[�^
    sh_l_y	y����̐��Y�֐��̃V�F�A�p�����[�^

    alpha_x_u	���p�֐��̃E�F�C�g�p�����[�^
    alpha_y_u	���p�֐��̃E�F�C�g�p�����[�^
;
$ontext
�_����(5)���𗘗p���āA�E�F�C�g�p�����[�^�����߂�B
����ɂ́A�x���`�}�[�N�̃V�F�A���K�v�ɂȂ�̂ŁA���߂Ă����B
$offtext

sh_k_x = pk0*kx0 / (pk0*kx0 + pl0*lx0);
sh_l_x = pl0*lx0 / (pk0*kx0 + pl0*lx0);

sh_k_y = pk0*ky0 / (pk0*ky0 + pl0*ly0);
sh_l_y = pl0*ly0 / (pk0*ky0 + pl0*ly0);

sh_x_u = px0*cx0 / (px0*cx0 + py0*cy0);
sh_y_u = py0*cy0 / (px0*cx0 + py0*cy0);

display sh_k_x, sh_l_x, sh_k_y, sh_l_y, sh_x_u, sh_y_u;

*	�E�F�C�g�p�����[�^��calibration (�_��5��)
alpha_k_x = sh_k_x * (kx0/x0)**((1-sig_x)/sig_x);
alpha_l_x = sh_l_x * (lx0/x0)**((1-sig_x)/sig_x);

alpha_x_u = sh_x_u * (cx0/u0)**((1-sig_u)/sig_u);
alpha_y_u = sh_y_u * (cy0/u0)**((1-sig_u)/sig_u);

display alpha_k_x, alpha_l_x, alpha_x_u, alpha_y_u;

*	Cobb-Double�֐��̃X�P�[���p�����[�^��calibration�i�_����14���j
phi_y = y0 / (ky0**sh_k_y * ly0**sh_l_y);

display phi_y;

*	----------------------------------------------------------------------
*	�ϐ��̐錾

variables
    c_x		x����̒P�ʔ�p
    c_y		y����̒P�ʔ�p
    c_u		���p����̒P�ʔ�p
;

variables
    a_k_x	x�����k�ւ̒P�ʎ��v
    a_l_x	x�����l�ւ̒P�ʎ��v
    a_k_y	y�����k�ւ̒P�ʎ��v
    a_l_y	y�����l�ւ̒P�ʎ��v
    a_x_u	x���ւ̒P�ʏ�����v
    a_y_u	y���ւ̒P�ʏ���ʎ��v
;

variables
    x		x����̐��Y
    y		y����̐��Y
    u		���p����̐��Y�i���p�����j
;

variables
    px		x���̉��i
    py		x���̉��i
    pu		���p�̉��i
    pk		���{�̉��i
    pl		�J���̉��i
;

variables
    inc		�ƌv�̏���
;

*	----------------------------------------------------------------------
*	���̐錾

equations
    e_c_x	x����̒P�ʔ�p
    e_c_y	y����̒P�ʔ�p
    e_c_u	���p����̒P�ʔ�p
;

equations
    e_a_k_x	x�����k�ւ̒P�ʎ��v
    e_a_l_x	x�����l�ւ̒P�ʎ��v
    e_a_k_y	y�����k�ւ̒P�ʎ��v
    e_a_l_y	y�����l�ւ̒P�ʎ��v
    e_a_x_u	x���ւ̒P�ʏ�����v
    e_a_y_u	y���ւ̒P�ʏ���ʎ��v
;

equations
    e_x		x����̐��Y
    e_y		y����̐��Y
    e_u		���p����̐��Y�i���p�����j
;

equations
    e_px	x���̉��i
    e_py	x���̉��i
    e_pu	���p�̉��i
    e_pk	���{�̉��i
    e_pl	�J���̉��i
;

equations
    e_inc	�ƌv�̏���
;

*	�P�ʔ�p�i�_����2���j
e_c_x .. c_x =e= (alpha_k_x**sig_x * pk**(1-sig_x) + alpha_l_x**sig_x * pl**(1-sig_x))**(1/(1-sig_x));

*	�������Cobb-Douglas�֐��Ȃ̂ŁA�_����12��
e_c_y .. c_y =e= (1/phi_y) * (pk/sh_k_y)**(sh_k_y) * (pl/sh_l_y)**(sh_l_y);

e_c_u .. c_u =e= (alpha_x_u**sig_u * px**(1-sig_u) + alpha_y_u**sig_u * py**(1-sig_u))**(1/(1-sig_u));


*	�P�ʎ��v

*	�_����3��
e_a_k_x .. a_k_x =e= (alpha_k_x*c_x/pk)**(sig_x);

e_a_l_x .. a_l_x =e= (alpha_l_x*c_x/pl)**(sig_x);

*	�_����13��
e_a_k_y .. a_k_y =e= sh_k_y*c_y/pk;

e_a_l_y .. a_l_y =e= sh_l_y*c_y/pl;

e_a_x_u .. a_x_u =e= (alpha_x_u*c_u/px)**(sig_u);

e_a_y_u .. a_y_u =e= (alpha_y_u*c_u/py)**(sig_u);

*	�[����������

e_x .. c_x =e= px;

e_y .. c_y =e= py;

e_u .. c_u =e= pu;

*	�s��ύt����

e_px .. x =e= a_x_u*u;

e_py .. y =e= a_y_u*u;

e_pu .. pu*u =e= inc;

e_pk .. end_k =e= a_k_x*x + a_k_y*y;

e_pl .. end_l =e= a_l_x*x + a_l_y*y;

*	�����̒�`��

e_inc .. inc =e= pk*end_k + pl*end_l;


*	----------------------------------------------------------------------
*	���f���̐錾

model model_normal Model in normal form CES /

		   e_c_x.c_x, e_c_y.c_y, e_c_u.c_u, e_a_k_x.a_k_x,
		   e_a_l_x.a_l_x, e_a_k_y.a_k_y, e_a_l_y.a_l_y, e_a_x_u.a_x_u,
		   e_a_y_u.a_y_u, e_x.x, e_y.y, e_u.u, e_px.px, e_py.py,
		   e_pu.pu, e_pk.pk, e_pl.pl, e_inc.inc

		   /;

c_x.l = 1;
c_y.l = 1;
c_u.l = 1;
a_k_x.l = kx0/x0;
a_l_x.l = lx0/x0;
a_k_y.l = ky0/y0;
a_l_y.l = ly0/y0;
a_x_u.l = cx0/u0;
a_y_u.l = cy0/u0;
x.l = x0;
y.l = y0;
u.l = u0;
px.l = 1;
py.l = 1;
pu.l = 1;
pk.l = 1;
pl.l = 1;
inc.l = inc0;

c_x.lo = 1e-6;
c_y.lo = 1e-6;
c_u.lo = 1e-6;
a_k_x.lo = 0;
a_l_x.lo = 0;
a_k_y.lo = 0;
a_l_y.lo = 0;
a_x_u.lo = 0;
a_y_u.lo = 0;
x.lo = 0;
y.lo = 0;
u.lo = 0;
px.lo = 1e-6;
py.lo = 1e-6;
pu.lo = 1e-6;
pk.lo = 1e-6;
pl.lo = 1e-6;
inc.lo = 1e-6;

*	----------------------------------------------------------------------
*	Benchmark replication.

model_normal.iterlim = 0;
solve model_normal using mcp;

*	----------------------------------------------------------------------
*	Cleanup calculation.

model_normal.iterlim = 10000;
solve model_normal using mcp;

parameter
    report_level
;

report_level("Utility","bau") = u.l;
report_level("Output of x","bau") = x.l;
report_level("Price of x","bau") = px.l/pu.l;

*	======================================================================
*	Calibrated share form�𗘗p����L�q
*	======================================================================

*	----------------------------------------------------------------------
*	�ϐ��̐錾

variables
    c_x_	x����̒P�ʔ�p
    c_y_	y����̒P�ʔ�p
    c_u_	���p����̒P�ʔ�p
;

variables
    a_k_x_	x�����k�ւ̒P�ʎ��v
    a_l_x_	x�����l�ւ̒P�ʎ��v
    a_k_y_	y�����k�ւ̒P�ʎ��v
    a_l_y_	y�����l�ւ̒P�ʎ��v
    a_x_u_	x���ւ̒P�ʏ�����v
    a_y_u_	y���ւ̒P�ʏ���ʎ��v
;

variables
    x_		x����̐��Y
    y_		y����̐��Y
    u_		���p����̐��Y�i���p�����j
;

variables
    px_		x���̉��i
    py_		x���̉��i
    pu_		���p�̉��i
    pk_		���{�̉��i
    pl_
;

variables
    inc_	�ƌv�̏���
;

*	----------------------------------------------------------------------
*	���̐錾

equations
    e_c_x_	x����̒P�ʔ�p
    e_c_y_	y����̒P�ʔ�p
    e_c_u_	���p����̒P�ʔ�p
;

equations
    e_a_k_x_	x�����k�ւ̒P�ʎ��v
    e_a_l_x_	x�����l�ւ̒P�ʎ��v
    e_a_k_y_	y�����k�ւ̒P�ʎ��v
    e_a_l_y_	y�����l�ւ̒P�ʎ��v
    e_a_x_u_	x���ւ̒P�ʏ�����v
    e_a_y_u_	y���ւ̒P�ʏ���ʎ��v
;

equations
    e_x_	x����̐��Y
    e_y_	y����̐��Y
    e_u_	���p����̐��Y�i���p�����j
;

equations
    e_px_	x���̉��i
    e_py_	x���̉��i
    e_pu_	���p�̉��i
    e_pk_	���{�̉��i
    e_pl_	�J���̉��i
;

equations
    e_inc_	�ƌv�̏���
;

*	�P�ʔ�p

*	�_����8���i�������Areference price��1�ł���̂ŏȗ����Ă���j
e_c_x_ .. c_x_ =e= (sh_k_x*pk_**(1-sig_x) + sh_l_x*pl_**(1-sig_x))**(1/(1-sig_x));

*	�_��16��
e_c_y_ .. c_y_ =e= pk_**(sh_k_y) * pl_**(sh_l_y);

e_c_u_ .. c_u_ =e= (sh_x_u*px_**(1-sig_u) + sh_y_u*py_**(1-sig_u))**(1/(1-sig_u));


*	�P�ʎ��v

*	�_��10��
e_a_k_x_ .. a_k_x_ =e= (kx0/x0)*(c_x_/pk_)**(sig_x);

e_a_l_x_ .. a_l_x_ =e= (lx0/x0)*(c_x_/pl_)**(sig_x);

e_a_k_y_ .. a_k_y_ =e= (ky0/y0)*c_y_/pk_;

e_a_l_y_ .. a_l_y_ =e= (ly0/y0)*c_y_/pl_;

e_a_x_u_ .. a_x_u_ =e= (cx0/u0)*(c_u_/px_)**(sig_u);

e_a_y_u_ .. a_y_u_ =e= (cy0/u0)*(c_u_/py_)**(sig_u);

*	�[����������

e_x_ .. c_x_ =e= px_;

e_y_ .. c_y_ =e= py_;

e_u_ .. c_u_ =e= pu_;

*	�s��ύt����

e_px_ .. x_ =e= a_x_u_*u_;

e_py_ .. y_ =e= a_y_u_*u_;

e_pu_ .. pu_*u_ =e= inc_;

e_pk_ .. end_k =e= a_k_x_*x_ + a_k_y_*y_;

e_pl_ .. end_l =e= a_l_x_*x_ + a_l_y_*y_;


*	�����̒�`��

e_inc_ .. inc_ =e= pk_*end_k + pl_*end_l;


*	----------------------------------------------------------------------
*	���f���̐錾

model model_csf Model in calibrated share form CES /

		   e_c_x_.c_x_, e_c_y_.c_y_, e_c_u_.c_u_, e_a_k_x_.a_k_x_,
		   e_a_l_x_.a_l_x_, e_a_k_y_.a_k_y_, e_a_l_y_.a_l_y_, e_a_x_u_.a_x_u_,
		   e_a_y_u_.a_y_u_, e_x_.x_, e_y_.y_, e_u_.u_, e_px_.px_, e_py_.py_,
		   e_pu_.pu_, e_pk_.pk_, e_pl_.pl_, e_inc_.inc_

		   /;

c_x_.l = 1;
c_y_.l = 1;
c_u_.l = 1;
a_k_x_.l = kx0/x0;
a_l_x_.l = lx0/x0;
a_k_y_.l = ky0/y0;
a_l_y_.l = ly0/y0;
a_x_u_.l = cx0/u0;
a_y_u_.l = cy0/u0;
x_.l = x0;
y_.l = y0;
u_.l = u0;
px_.l = 1;
py_.l = 1;
pu_.l = 1;
pk_.l = 1;
pl_.l = 1;
inc_.l = inc0;

c_x_.lo = 1e-6;
c_y_.lo = 1e-6;
c_u_.lo = 1e-6;
a_k_x_.lo = 0;
a_l_x_.lo = 0;
a_k_y_.lo = 0;
a_l_y_.lo = 0;
a_x_u_.lo = 0;
a_y_u_.lo = 0;
x_.lo = 0;
y_.lo = 0;
u_.lo = 0;
px_.lo = 1e-6;
py_.lo = 1e-6;
pu_.lo = 1e-6;
pk_.lo = 1e-6;
pl_.lo = 1e-6;
inc.lo = 1e-6;

*	----------------------------------------------------------------------
*	Benchmark replication.

model_csf.iterlim = 0;
solve model_csf using mcp;

*	----------------------------------------------------------------------
*	Cleanup calculation.

model_csf.iterlim = 10000;
solve model_csf using mcp;

parameter
    report_level_
;

report_level_("Utility","bau") = u_.l;
report_level_("Output of x","bau") = x_.l;
report_level_("Price of x","bau") = px_.l/pu_.l;


*	======================================================================
*	�V�~�����[�V����
*	======================================================================
$ontext
���{�X�g�b�N��50%�̑����̃V�~�����[�V�����B

Normal form�̃��f����Calibrated share form�̃��f���ŉ��������ɂȂ邱�Ƃ��m�F��
��B
$offtext

end_k = end_k * 1.5;

*	Normal form�̃��f��
solve model_normal using mcp;

report_level("Utility","CF") = u.l;
report_level("Output of x","CF") = x.l;
report_level("Price of x","CF") = px.l/pu.l;

*	Calibrated share form�̃��f��
solve model_csf using mcp;

report_level_("Utility","CF") = u_.l;
report_level_("Output of x","CF") = x_.l;
report_level_("Price of x","CF") = px_.l/pu_.l;

*	Normal form�̃��f���̌��ʂƁACalibrated share form�̃��f���̌��ʂ��r
*	����B
display report_level, report_level_;


* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* End:

