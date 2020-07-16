# CEC-benchmark-functions
CEC-国际进化计算会议-测试函数


其他测试标准函数：

 https://www.ntu.edu.sg/home/EPNSugan/
 
 https://github.com/P-N-Suganthan
 
 
 ```matlab
% 绘制各种常见的函数图像
% function function_plot
% clear;close all
global initial_flag

% Xmin=[-100,-100,-100,-100,-100,-100,0,-32,-5,-5,-0.5,-pi,-3,-100,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,2];
% Xmax=[100,100,100,100,100,100,600,32,5,5,0.5,pi,1,100,5,5,5,5,5,5,5,5,5,5,5];

%绘制函数图像
for func_num=1:11
    
    if func_num==1 x=-100:5:100;y=x; %[-100,100]
    elseif func_num==2 x=-100:5:100; y=x;%[-10,10]
    elseif func_num==3 x=-100:5:100; y=x;%[-100,100]
    elseif func_num==4 x=-100:2:0; y=x+100;%[-100,100]
    elseif func_num==5 x=-200:20:200;y=x; %[-5,5]
    elseif func_num==6 x=78:0.05:82; y=-51.3:0.05:-47.3;%[-3,1]
    elseif func_num==7 x=-350:2:-250; y=-100:2:0;%[-600,600]
    elseif func_num==8 x=-32:1:32; y=x;%[-32,32]
    elseif func_num==9 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==10 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==11 x=-0.5:0.01:0.5; y=x;%[-0.5,0.5]
    elseif func_num==12 x=-3:0.1:3; y=x;%[-pi,pi]
    elseif func_num==13 x=-2:0.02:-1; y=x;%[-3,1]
    elseif func_num==14 x=-90:0.2:-50; y=-40:0.2:0;%[-100,100]
    elseif func_num==15 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==16 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==17 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==18 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==19 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==20 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==21 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==22 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==23 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==24 x=-5:0.1:5; y=x;%[-5,5]
    elseif func_num==25 x=-5:0.1:5; y=x;%[-5,5]
    end
    
    initial_flag=0;
    L=length(x);
    f=[];
    
    for i=1:L
        for j=1:L
            f(i,j)=benchmark_func([x(i),y(j)],func_num);
        end
    end
    
    figure(func_num)% 生成函数图像画布
    
    surfc(x,y,f);   % 生成函数图像(带有等高线)
    
    filename=strcat('D:\map\','F',num2str(func_num));
    saveas(gcf,filename,'png');
    close;
    
end


 
 
 ```
 
 
