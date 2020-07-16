# CEC-benchmark-functions
CEC-国际进化计算会议-测试函数


其他测试标准函数：

 https://www.ntu.edu.sg/home/EPNSugan/
 
 https://github.com/P-N-Suganthan
 
 
 ### 绘制测试函数图像
 
 ```matlab
 % plot_function.m
% 脚本功能：绘制所有测试函数图像
% clear;close all

% 1.二维空间绘图时，生成多个自变量
for func_num =1:16
    
    if func_num==1 x=-100:5:100;y=x; %sphere_func
    elseif func_num==2 x=-100:5:100; y=x;%schwefel_102
    elseif func_num==3 x=-10:0.5:10; y=x;%schwefel_102_noise_func
    elseif func_num==4 x=-100:5:100; y=x;%schwefel_2_21
    elseif func_num==5 x=-10:0.5:10; y=x;%schwefel_2_22
    elseif func_num==6 x=-200:10:200;y=x; %high_cond_elliptic_func
    elseif func_num==7 x=-10:0.5:10; y=x; % step_func
    elseif func_num==8 x=-500:10:500; y=x;%Schwefel_func(multimodal)
    elseif func_num==9 x=-2.048:0.05:2.048; y=x;%rosenbrock_func
    elseif func_num==10 x=-1.28:0.05:1.28;y=x; %Quartic function
    elseif func_num==11 x=-600:30:600; y=x;%griewank_func
    elseif func_num==12 x=-32:1:32; y=x;% ackley_func
    elseif func_num==13 x=-5:0.1:5; y=x;% rastrigin_func
    elseif func_num==14 x=-5:0.1:5; y=x;% rastrigin_noncont                                                                                                                 astrigin_noncont
    elseif func_num==15 x=-5:0.1:5; y=x;% weierstrass
    elseif func_num==16 x=-10:0.2:10;y=x;% schaffer
    else
       break;
    end
    
    L=length(x);
    f=[];
    
    %2. 由自变量生成网格点，并计算各个网格点的函数值f(x,y)
    for i=1:L
        for j=1:L
            f(i,j)=benchmark_func([x(i),y(j)],func_num); % 一个点对应一个数值
        end
    end
    
    % 3. 根据网格点绘制空间图形
    figure(func_num)% 生成一份图形画布
    surfc(x,y,f);   % 在图形画布上绘制函数图像(带有等高线)surfC（X,Y,Z）
    
    xlabel('x'); 
    ylabel('y');
    zlabel('f(x,y)');
    
    % 4.输出并保存函数图像到指定路径下面
    filename=strcat('F:\6_张庆科\2_AlgorithmDesign\TestFunctionsMap\','F',num2str(func_num));
    saveas(gcf,filename,'png');
    close;% 关闭当前的输出
    
end

 ```
 
 
 ---
 
 
 ### 测试函数完整形式
 
 benchmark_func.m
 
 ```matlab
 function fitnessvalue=benchmark_func(x,func_num)
% Simple benchmark functions
% benchmark_func.m is the main function of selected minimize problems
% e.g. f=benchmark_func(x,func_num)
% x is the variable, f is the function value

%% Test Functions

% Unimodal function
if func_num==1 fhd=str2func('sphere_func'); %等价价于语句 fhd =@spher_func 
elseif func_num==2 fhd=str2func('schwefel_102'); %
elseif func_num==3 fhd=str2func('schwefel_102_noise_func'); %
elseif func_num==4 fhd= str2func('schwefel_2_21');
elseif func_num==5 fhd= str2func('schwefel_2_22');
elseif func_num==6 fhd=str2func('high_cond_elliptic_func'); %
elseif func_num==7 fhd=str2func('step_func'); 
    
% Multimodal function
elseif func_num==8 fhd=str2func('Schwefel_func'); %
elseif func_num==9 fhd=str2func('rosenbrock_func'); %
elseif func_num==10 fhd=str2func('quartic'); %
    

elseif func_num==11 fhd=str2func('griewank_func'); %
elseif func_num==12 fhd=str2func('ackley_func');
elseif func_num==13 fhd=str2func('rastrigin_func');
elseif func_num==14 fhd=str2func('rastrigin_noncont');
elseif func_num==15 fhd=str2func('weierstrass');

 % Fixed dimensions  function
elseif func_num ==16 fhd=str2func('schaffer');
    
end

fitnessvalue=feval(fhd,x);
% 这里的x均为行向量ps行，D列，D为x的维度数值

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% 1.Unimodal function %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 以下均为子函数

%% 	1.Sphere Function
function f=sphere_func(x)
% [ps,D]=size(x);
f=sum(x.^2,2);   


%% 	2.Schwefel's Problem 1.2
function f=schwefel_102(x)
[ps,D]=size(x);

f=0;
for i=1:D
    f=f+sum(x(:,1:i),2).^2;
end


%% 3.Schwefel's Problem 1.2 with Noise 
function f=schwefel_102_noise_func(x)
[ps,D]=size(x);

f=0;
for i=1:D
    f=f+sum(x(:,1:i),2).^2;
end
f=f.*(1+0.4.*abs(normrnd(0,1,ps,1)));

%% 	4.Schwefel's Problem 2.21
function f=schwefel_2_21(x)
[ps,D]=size(x);

f= max(abs(x));

%% 	5.Schwefel's Problem 2.22
function f=schwefel_2_22(x)
[ps,D]=size(x);

f= sum(abs(x)) + prod(abs(x));

%% 	6.High Conditioned Elliptic Function
function f=high_cond_elliptic_func(x)
[ps,D]=size(x);

a=1e+6;
f=0;
for i=1:D
    f=f+a.^((i-1)/(D-1)).*x(:,i).^2;
end

%% 	7.Step Function
function f=step_func(x)

% [ps,D]=size(x);

f= sum(floor(x+0.5).^2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% 2.Multimodal多峰函数%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 	8.Schwefel Function
function f= Schwefel_func(x)
[ps,D]=size(x);

f=418.982887272433799*D -sum(x.*sin(sqrt(abs(x))));


%% 	9.Rosenbrock's Function
function f=rosenbrock_func(x)
[ps,D]=size(x);

f=sum(100.*(x(:,1:D-1).^2-x(:,2:D)).^2+(x(:,1:D-1)-1).^2,2);


%% 10.Quartic函数（最小处位置很浅，很难高精确度找到）
function f= quartic(x) 
[ps,D]=size(x);

v=1:D;
xq =x.^4;

f = sum(v.*xq);
%% 11. Griewank's Function
function f=griewank_func(x)

[ps,D]=size(x);

f=1;
for i=1:D
    f=f.*cos(x(:,i)./sqrt(i));
end
f=sum(x.^2,2)./4000-f+1;

%% 12.Ackley's Function
function f=ackley_func(x)

[ps,D]=size(x);

f=sum(x.^2,2);
f=20-20.*exp(-0.2.*sqrt(f./D))-exp(sum(cos(2.*pi.*x),2)./D)+exp(1);

%% 13.Rastrign's Function
function f=rastrigin_func(x)
% [ps,D]=size(x);

f=sum(x.^2-10.*cos(2.*pi.*x)+10,2);
%% 14.Rastrign's noncontinue Function
function f=rastrigin_noncont(x)
% [ps,D]=size(x);

x=(abs(x)<0.5).*x+(abs(x)>=0.5).*(round(x.*2)./2);

f=sum(x.^2-10.*cos(2.*pi.*x)+10,2);

%% 	15.Weierstrass Function
function f=weierstrass(x)
[ps,D]=size(x);
x=x+0.5;
a = 0.5;
b = 3;
kmax = 20;
c1(1:kmax+1) = a.^(0:kmax);
c2(1:kmax+1) = 2*pi*b.^(0:kmax);

f=0;
%
c=-w(0.5,c1,c2);

for i=1:D
    f=f+w(x(:,i)',c1,c2);
end
f=f+c*D;


function y = w(x,c1,c2)
y = zeros(length(x),1);
for k = 1:length(x)
    y(k) = sum(c1 .* cos(c2.*x(:,k)));
end
%--------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% 3.固定维度的特殊峰函数%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 16. schaffer函数(强烈震荡)
function f=schaffer(x)
[ps,D]=size(x);

if D==2
    
    f = 0.5 + (sin(sqrt(x(1)^2 + x(2)^2))-0.5)/(1+0.001*(x(1)^2 + x(2)^2))^2;
else
    disp("the value of D must be 2 for schaffer funtion");
    pause;
    
    
end



 
 ```
 
 
