%%%%%%%%%%%%%%%%%%%
%% This package is a MATLAB/Octave source code of L-SHADE which is an improved version of SHADE 1.1.
%% Note that this source code is transferred from the C++ source code version.
%% About L-SHADE, please see following papers:
%%
%% * Ryoji Tanabe and Alex Fukunaga: Improving the Search Performance of SHADE Using Linear Population Size Reduction,  Proc. IEEE Congress on Evolutionary Computation (CEC-2014), Beijing, July, 2014.
%%
%% For this package, we downloaded JADE's source code from Dr. Q. Zhang's website (http://dces.essex.ac.uk/staff/qzhang) and modified it.
%%
%% Update
%% 9/Oct/2014: incompatibilities-fix between Octave and Matlab and bug-fix of population size reduction procedure (thanks to Dr. Elsayed)
%%%%%%%%%%%%%%%%%%%

function [memory,value]=RRSO1
global total_nfes bsf_error_val;
format long;
format compact;

max_nfes = 500000;% * problem_size;

rand('seed', sum(100 * clock));

global func 
fhd=@cec19_func;

digit_1_reach =  10^(-1);
digit_2_reach =  10^(-2);
digit_3_reach =  10^(-3);
digit_4_reach =  10^(-4);
digit_5_reach =  10^(-5);
digit_6_reach =  10^(-6);
digit_7_reach =  10^(-7);
digit_8_reach =  10^(-8);
digit_9_reach =  10^(-9);
digit_10_reach =  10^(-10);

digit_1 = 0;
digit_2 = 0;
digit_3 = 0;
digit_4 = 0;
digit_5 = 0;
digit_6 = 0;
digit_7 = 0;
digit_8 = 0;
digit_9 = 0;
digit_10 = 0;



    lu = [];
    pop_old = [];
    
    if func == 1
        problem_size = 9;
        max_region = 8192.0;
        min_region = -8192.0;
        lu = [min_region * ones(1, problem_size); max_region * ones(1, problem_size)];
    elseif func == 2
        problem_size = 16;
        max_region = 16384.0;
        min_region = -16384.0;
        lu = [min_region * ones(1, problem_size); max_region * ones(1, problem_size)];
        
    elseif func == 3
        problem_size = 18;
        max_region = 4.0;
        min_region = -4.0;
        lu = [min_region * ones(1, problem_size); max_region * ones(1, problem_size)];
        
    else
        problem_size = 10;
        max_region = 100.0;
        min_region = -100.0;
        lu = [min_region * ones(1, problem_size); max_region * ones(1, problem_size)];
    end
    
    optimum = 1.0;
    
    %% Record the best results
    outcome = [];
    memory=[];
    fprintf('\n-------------------------------------------------------\n')
    fprintf('Function = %d, Dimension size = %d\n', func, problem_size)
    
    for run_id = 1 : 20
        %%  parameter settings for L-SHADE
      pop_size=500;
      pop_sel=200;
     mu=pop_sel/2;
     weights=log(mu+1/2)-log(1:mu)';
     weights=weights/sum(weights);
     mu2=10;
       weights2=log(mu2+1/2)-log(1:mu2)';
     weights2=weights2/sum(weights2);
        
        %% Initialize the main population
        popold = repmat(lu(1, :), pop_size, 1) + rand(pop_size, problem_size) .* (repmat(lu(2, :) - lu(1, :), pop_size, 1));
        pop = popold; % the old population becomes the current population
%         popold(:,1)=1.5519604466631876*ones(500,1);
%          popold(:,2)=3.7992270681072000*ones(500,1);
%          popold(:,8)= -47.688475683186425*ones(500,1);
     %   pop(1,:)=[ 43.453613469526957 -75.117860986418009  54.110917411589753   2.189362665102863  -3.381379705896774 -30.849165427261845  78.077592575520754 -69.901998545641234  37.111456060791085 52.241020457044513]
        fitness = feval(fhd,pop',func);
        fitness = fitness';
        
        nfes = 0;
        bsf_fit_var = 1e+30;
        bsf_solution = zeros(1, problem_size);
        
        %%%%%%%%%%%%%%%%%%%%%%%% for out
        for i = 1 : pop_size
            nfes = nfes + 1;
            total_nfes=total_nfes+1;
            if fitness(i) < bsf_fit_var
                bsf_fit_var = fitness(i);
                bsf_solution = pop(i, :);
            end 
            if nfes > max_nfes; break; end
        end
      
        
        %% main loop
        while nfes < max_nfes
            pop = popold; % the old population becomes the current population
            [temp_fit, sorted_index1] = sort(fitness, 'ascend');
            
            
            preserved_value=min(fitness)
            
              if preserved_value-1<bsf_error_val
              bsf_error_val=preserved_value-1;
            end
        
            popnew=pop(sorted_index1(1:pop_sel/2),:);
             meanval1=(popnew(:,1:problem_size)'*weights)';
             stdval1=1*std(popnew);
             
             if max(fitness(1:pop_size/2))>min(fitness(pop_size/2+1:pop_size))
             
             sorted_index2=fliplr(sorted_index1);
             popnewmax=pop(sorted_index2(1:pop_sel/2),:);
              meanval2=(popnewmax(:,1:problem_size)'*weights)';
             % meanval2=mean(popnewmax);
              stdval2=1*std(popnewmax);
             else
                 meanval2=meanval1;
                % stdval2=5*rand(1,10);
                 stdval2=stdval1;
             end
               
              
              
              
%             if max(stdval)<0.01
%                stdval=max_region*rand(1,problem_size);
%             end
              for k=1:pop_size/2
                  popold(k,:)=meanval1+stdval1.*randn(1,problem_size);
                  for j=1:problem_size
                       if popold(k,j)>=100.0
                          popold(k,j)=100.0;
                       elseif popold(k,j)<=-100.0
                           popold(k,j)=-100.0;
                       end
                  end
                  
                   nfes = nfes + 1;
                   total_nfes=total_nfes+1;
              end
              
              
              
               for k=pop_size/2+1:pop_size
                  popold(k,:)=meanval2+stdval2.*randn(1,problem_size);
                  for j=1:problem_size
                       if popold(k,j)>=100.0
                          popold(k,j)=100.0;
                       elseif popold(k,j)<=-100.0
                           popold(k,j)=-100.0;
                       end
                  end
                  
                   nfes = nfes + 1;
                   total_nfes=total_nfes+1;
              end
               fitness = feval(fhd,popold',func);
               if abs(max(fitness)-preserved_value)<10^(-11)
                   break;
               end
              

    end %% end 1 run
     
               memory(run_id,:)=meanval1;
               
               value(run_id,:)=min(fitness);
               fit=min(fitness);
               
               [val,val_index]=sort(value)
    
    end

