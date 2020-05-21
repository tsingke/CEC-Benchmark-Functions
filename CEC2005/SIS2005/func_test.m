% SIS novel composition functions 
% Including six composition functions 
% reference: 
% J. J. Liang, P. N. Suganthan and K. Deb, "Novel Composition Test Functions for Numerical Global Optimization", submitted to IEEE International Swarm Intelligence Symposium, 2005.

clear;close all
global initial_flag
ps=20;
me=2500;
FES=ps*me;
Xmin=[-5,-5,-5,-5,-5,-5];
Xmax=-Xmin;
D=10;
for func_num=1:6
for jjj=1:30 %run's number
initial_flag=0;
func_num
jjj
[PSO_gbest,PSO_gbestval,PSO_fitcount]= PSO_func('SIS_novel_func',me,FES,ps,D,-5,5,func_num);
PSO_gbestval


PSO_fitcount_res(func_num,jjj)=PSO_fitcount;PSO_gbestval_res(func_num,jjj)=PSO_gbestval;PSO_gbest_res(func_num,jjj,:)=PSO_gbest;

end
end

for func_num=1:6
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
func_num
disp('PSO'),mean(PSO_gbestval_res(func_num,:)'),std(PSO_gbestval_res(func_num,:)')
end
