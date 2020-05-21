%**************************************************************************************************
 
%  cfPSO
%  Writer: Chen Xu
%  Date: 2014/02/24
%**************************************************************************************************


clc;
clear all; 


format long;
 
benchmark_cec2014 = str2func('cec14_func'); 
fun = benchmark_cec2014;

for problem = 1:1 
    
    D = 30;
    problem_range; 
    Xmin = lu(1,:);
    Xmax = lu(2,:); 
    
    Number = 1;
    runNumber = 1;  % The total number of runs 

    while Number <= runNumber

        tic 
        rand('seed', sum(100 * clock)); 
        
        D = 30; 
        problem_range; 
        Xmin = lu(1,:);
        Xmax = lu(2,:); 
   
        popsize = 40; 
        w=0.7298;
        c1=1.49618;   c2=1.49618;   %加速系数 

        % Initialize the main population
        X = repmat(Xmin, popsize, 1) + rand(popsize, n) .* (repmat(Xmax-Xmin, popsize, 1));
        val_X = (fun(X',problem))';  

        pBest = X; val_pBest = val_X;
        [~,indexG] = min(val_pBest);
        gBest = pBest(indexG,:); val_gBest = val_pBest(indexG,:);  
         

        Vmax = (Xmax - Xmin)*0.5;        %最大最小速度
        Vmin = -Vmax;
        V = repmat(Vmin,popsize,1) + rand(popsize,D).*repmat(Vmax-Vmin,popsize,1);
        
        outcome = [];  % record the best results 
        FES = 0;
        while   FES < D * 10000
  
 
                for i = 1:popsize    
                    %粒子i速度更新
                    V(i,:) = w*V(i,:) + c1*rand(1,D).*(pBest(i,:)-X(i,:))+c2*rand(1,D).*(gBest-X(i,:) );              %注意repmat的使用
 
                    %粒子i位置更新
                    X(i,:) = boundConstraint_reflect(X(i,:)+V(i,:),Xmin,Xmax);   

                    val_X(i,:) = (fun(X(i,:)',problem))';
                    
                    FES = FES+1;

                    %----------------- 更新 pBest，
                    if val_X(i,:) < val_pBest(i,:)
                        val_pBest(i,:) = val_X(i,:);
                        pBest(i,:) = X(i,:);
                    end
                     
                    %----------------- 更新 gBest ----------------
                    if val_X(i,:) < val_gBest
                        val_gBest = val_X(i,:);
                        gBest = X(i,:); 
                    end

                end 
                
    
                FES
                val_gBest
                outcome = [outcome; val_gBest*ones(popsize,1)]; 


        end

        Number, FES
        val_gBest


%       记录每一次运行的输出
        eval(['record.outcome',num2str(Number),'=','outcome',';']);
        record.FES(Number) = FES;
        record.time(Number) = toc;

        Number = Number + 1; 


    end

%     保存数据
    filename = strcat( 'out_cec2014_f', num2str(problem),'_CFPSO');  
    save(filename, 'record');
 
end
 