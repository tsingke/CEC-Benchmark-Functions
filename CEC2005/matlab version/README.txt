% Prepared by Jane J. Liang. Email: liangjing@pmail.ntu.edu.sg February 20, 2005.

benchmark_func.m is the main function for these minimization problems
f=benchmark_func(x,func_num)
x is the variable, f is the function value, func_num is the function num,
data files save the necessary information.
func_plot.m is used to plot the 2-D function map

25 functions in all, from 1 to 25, are

	Unimodal Functions (5):
1.	Shifted Sphere Function 						Bounds[-100,100]		f_bias=-450
2.	Shifted Schwefel's Problem 1.2						Bounds[-100,100]		f_bias=-450
3.	Shifted Rotated High Conditioned Elliptic Function				Bounds[-100,100]		f_bias=-450
4.	Shifted Schwefel's Problem 1.2 with Noise in Fitness 				Bounds[-100,100]		f_bias=-450
5.	Schwefel's  Problem 2.6 with Global Optimum on Bounds			Bounds[-100,100]		f_bias=-310

	Multimodal Functions (20):

	Basic Functions (7):	
6.	Shifted Rosenbrock's  Function						Bounds[-100,100]		f_bias=390 
7.	Shifted Rotated Griewank's  Function without Bounds	     		Intilization Range [0, 600]	f_bias=-180
8.	Shifted Rotated Ackley's with Global Optimum on Bounds			Bounds[-32,32]		f_bias=-140
9.	Shifted Rastrigin's  Function 						Bounds[-5,5]		f_bias=-330
10.	Shifted Rotated Rastrigin's  Function 					Bounds[-5,5]		f_bias=-330
11.	Shifted Rotated Weierstrass Function 					Bounds[-0.5,0.5]		f_bias=90
12.	Schwefel's  Problem 2.13						Bounds[-100,100]		f_bias=-460 

	Expanded Functions (2):
13.	Expanded Extended Griewank's + Rosenbrock's (F8F2)			Bounds[-3,1]		f_bias=-130
14.	Expanded Rotated Extended Scaffe's  F6 					Bounds[-100,100]		f_bias=-300

	Hybrid Composition Functions (11):
15.	Hybrid Composition Function 1					Bounds[-5,5]		f_bias= 120 
16.	Rotated Hybrid Comp. Fn 1						Bounds[-5,5]		f_bias= 120
17.	Rotated Hybrid Comp. Fn 1 with Noise in Fitness				Bounds[-5,5]		f_bias= 120
18.	Rotated Hybrid Comp. Fn 2						Bounds[-5,5]		f_bias=10 
19.	Rotated Hybrid Comp. Fn 2 with Narrow Global Optimal Basin			Bounds[-5,5]]		f_bias=10 
20.	Rotated Hybrid Comp. Fn 2 with the Global Optimum on Bounds		Bounds[-5,5]		f_bias=10
21.	Rotated Hybrid Comp. Fn 3						Bounds[-5,5]		f_bias=360 
22.	Rotated Hybrid Comp. Fn 3 with High Condition Number Matrix		Bounds[-5,5]		f_bias=360
23.	Non-Continuous Rotated Hybrid Comp. Fn 3				Bounds[-5,5]		f_bias=360 
24.	Rotated Hybrid Comp. Fn 4						Bounds[-5,5]		f_bias=260 
25.	Rotated Hybrid Comp. Fn 4 without Bounds	 			Intilization Range[-2,5]	f_bias=260 
 



***Please note:
When you use the test function, remember to set a global variable initial_flag, and make 
sure initial_flag=0 before each search. 

For details of the test functions, please read intro-2-functions.doc file

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
Files:

%~~~~~~~~~~~~~~~%
Matlab *.m files:
%~~~~~~~~~~~~~~~%
benchmark_func.m
%benchmark_func.m is the main function with all the minimization problems
%f=benchmark_func(x,func_num)
%x is the variable, f is the function value, func_num is the function number (1 to 25),

func_plot.m
%used to plot the 2-D function map

%~~~~~~~~~~~~~~~%
Matlab *.mat data files:
%~~~~~~~~~~~~~~~%

test_data.mat
% 10 points (50D each) & corresponding fitnesses given to assist verification for code translation. 
% Variables:x1,x2,x3,....x25
% Corresponding Function Values: f1,f2,f3,....f25
***Notice, for function 4,17,24,25, since they have noise, please set noise to 0 (e.g setting 0.0*N(0,1)) before test.

fbias_data.mat
% contain a 1*25 vector f_bias which are the global optimal function values.

global_optima.mat
% all 25 global optimal points (25 x 100 matrix) for the 25 test functions,
% please note, function 5,8,20 set the global optima on the bounds, so the corresponding 
% global optima are:
% if func_num==5,o(1:ceil(D/4))=-100;x(max(floor(0.75*D),1):D)=100;end
% if func_num==8,o(2.*[1:floor(D/2)]-1)=-32;end
% if func_num==20,o(1,2.*[1:floor(D/2)])=5;end

sphere_func_data.mat

schwefel_102_data.mat

high_cond_elliptic_rot_data.mat
elliptic_M_D2.mat
elliptic_M_D10.mat
elliptic_M_D30.mat
elliptic_M_D50.mat

schwefel_206_data.mat

rosenbrock_func_data.mat

griewank_func_data.mat
griewank_M_D2.mat
griewank_M_D10.mat
griewank_M_D30.mat
griewank_M_D50.mat

ackley_func_data.mat
ackley_M_D2.mat
ackley_M_D10.mat
ackley_M_D30.mat
ackley_M_D50.mat

rastrigin_func_data.mat
rastrigin_M_D2.mat
rastrigin_M_D10.mat
rastrigin_M_D30.mat
rastrigin_M_D50.mat

weierstrass_data.mat
weierstrass_M_D2.mat
weierstrass_M_D10.mat
weierstrass_M_D30.mat
weierstrass_M_D50.mat

schwefel_213_data.mat

EF8F2_func_data.mat

E_ScafferF6_func_data.mat
E_ScafferF6_M_D2.mat
E_ScafferF6_M_D10.mat
E_ScafferF6_M_D30.mat
E_ScafferF6_M_D50.mat

hybrid_func1_data.mat
hybrid_func1_M_D2.mat
hybrid_func1_M_D10.mat
hybrid_func1_M_D30.mat
hybrid_func1_M_D50.mat

hybrid_func2_data.mat
hybrid_func2_M_D2.mat
hybrid_func2_M_D10.mat
hybrid_func2_M_D30.mat
hybrid_func2_M_D50.mat

hybrid_func3_data.mat
hybrid_func3_M_D2.mat
hybrid_func3_M_D10.mat
hybrid_func3_M_D30.mat
hybrid_func3_M_D50.mat

hybrid_func4_data.mat
hybrid_func4_M_D2.mat
hybrid_func4_M_D10.mat
hybrid_func4_M_D30.mat
hybrid_func4_M_D50.mat


%%%%%%%%%%
PLEASE NOTE:
hybrid_func1_M_D......matrix data in matlab mat format contain a structure variable M, 
and M.M1,M.M2...M.M10 are ten D*D matrix

