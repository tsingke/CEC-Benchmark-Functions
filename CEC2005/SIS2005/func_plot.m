% function function_plot
% clear;close all
global initial_flag

% Xmin=[-100,-100,-100,-100,-100,-100,0,-32,-5,-5,-0.5,-pi,-3,-100,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,2];
% Xmax=[100,100,100,100,100,100,600,32,5,5,0.5,pi,1,100,5,5,5,5,5,5,5,5,5,5,5];

for func_num=6:6
x=-5:0.1:5; y=x;%[-5,5]
% 
initial_flag=0;
L=length(x);
f=[];

for i=1:L
for j=1:L
f(i,j)=SIS_novel_func([x(i),y(j)],func_num);
end
end


figure(func_num)
surfc(x,y,f);


% benchmark_func([0,0;1,1],func_num)
end

