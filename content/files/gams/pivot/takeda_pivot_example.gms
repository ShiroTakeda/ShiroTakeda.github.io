$title pivotdata.gms ���g���āApivot�e�[�u���쐬�p�̃f�[�^���o�͂���R�[�h
display "com: pivotdata.gms ���g���āApivot�e�[�u���쐬�p�̃f�[�^���o�͂���R�[�h";
$ontext
Time-stamp: 	<2011-09-17 21:56:40 Shiro Takeda>
First-written:	<2011/09/17>
$offtext

*	�C���f�b�N�X�̒�`
set	t	Time index	/ 2000*2100 /
	tfst(t)	
	s	Sector index	/ ind, ser, agr /
	k	Variable type	/ output, price /;
tfst(t)$(ord(t) eq 1)  = yes;
display t, tfst, s, k;

*	�T���v���̃p�����[�^���`
parameter
    a(t,s,k)
    coeff(s,k)		Coefficient
    alpha(s,k) 		Drift parameter
    sigma(s,k)		Variance
    epsilon(t,s,k)	Stochastic variable with normal distribution
;
coeff(s,k) = 1;
coeff("ind","price") = 0.9;
coeff("ser","price") = 0.9;
coeff("agr","price") = 0.8;
alpha(s,k) = uniform(0,0.05);
sigma(s,k) = uniform(0,0.5);
epsilon(t,s,k) = normal(0,1);
display coeff, alpha, sigma, epsilon;

a(t,s,k)$tfst(t) = 1e-6;
loop(t$(not tfst(t)),
    a(t,s,k)= coeff(s,k)*a(t-1,s,k) + alpha(s,k) + sigma(s,k)*epsilon(t,s,k);
);
display a;

*	----------------------------------------------------------------------
*	�f�[�^���o�͂���G�N�Z���t�@�C���̖��O���w��

*	�܂��A�f�[�^���o�͂���G�N�Z���t�@�C���̖��O���w�肷��B���O��
*	workbook �Ƃ����ϐ��ɓ���� (pivotdata.gms �ł������܂��Ă���)�B���̗�
*	�ł́Asample_excel.xlsx �Ƃ������O�̃t�@�C���ɏo�͂����B
*
*	���X�� pivotdata.gms �ł�
*
*	$setglobal workbook sample_excel
*
*	�Ƃ����g���q�Ȃ��̌`���Ŏw�肷��̂����A�K�� sample_excel.xls �Ƃ�����
*	�O�ŕۑ�����Ă��܂��̂ŁA�g���q���݂Ŏw�肷��悤�� pivotdata.gms ��
*	�C�������B����Ȃ� xlsx �Ƃ����g���q�̃t�@�C���ɂ��o�͉\�B

$setglobal workbook sample_excel.xlsx


*	----------------------------------------------------------------------
*	�G�N�Z���t�@�C���ɏo�͂��閽��

*	������
*
*	$batinclude pivotdata parameter_name index_a [index_b index_c ...]
*
*	parameter_name �ɏo�͂���p�����[�^���w��B�c��̓G�N�Z���t�@�C����1�s
*	�ڂŃC���f�b�N�X�Ƃ��Ďg���镶������w��B
*	Parameter �̒l�ɑ΂���C���f�b�N�X�ɂ͏�� "value" ���g����B

$batinclude pivotdata a year sector type


* --------------------
* Local Variables:
* mode: gams
* fill-column: 80
* End:
