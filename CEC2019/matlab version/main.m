% This program is used to calculate 100 Digit Competition, Ver.1.0
% Modified by Geng Zhang at Sustech based on following original code
% Contributed to Matlab File Exchange Server on 5/13/2019
% Jun Steed Huang email: steedhuang@163.com     
% For more background theory, follow us on researchgate 
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

clc;
clear all;

format long;
format compact;

max_nfes = 500000;% * problem_size;
memory1=[];
vector_cpsomhs=[];
abc1=10*rand(120,1);
global vector_cpsomhs memory1 total_nfes;
rand('seed', sum(100 * clock));

global func;
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


for func = 1 : 10
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
    total_num_nfes=[];
    
    fprintf('\n-------------------------------------------------------\n')
    fprintf('Function = %d, Dimension size = %d\n', func, problem_size)
   for total_run=1:50
memory1=[];
value=[];
    for run_id = 1 : 1
        %%  parameter settings for L-SHADE
        p_best_rate = 0.11;
        arc_rate = 1.4;
        memory_size = 5;
        pop_size = 18 * problem_size;
        
        max_pop_size = pop_size;
        min_pop_size = 4.0;
        
        %% Initialize the main population
        popold = repmat(lu(1, :), pop_size, 1) + rand(pop_size, problem_size) .* (repmat(lu(2, :) - lu(1, :), pop_size, 1));
        pop = popold; % the old population becomes the current population
    
        
        fitness = feval(fhd,pop',func);
        fitness = fitness';
        
        nfes = 0;
        total_nfes=0
        bsf_fit_var = 1e+30;
        bsf_solution = zeros(1, problem_size);
        
        %%%%%%%%%%%%%%%%%%%%%%%% for out
        for i = 1 : pop_size
            nfes = nfes + 1;
            
            if fitness(i) < bsf_fit_var
                bsf_fit_var = fitness(i);
                bsf_solution = pop(i, :);
            end 
            if nfes > max_nfes; break; end
        end
        %%%%%%%%%%%%%%%%%%%%%%%% for out
        
        memory_sf = 0.5 .* ones(memory_size, 1);
        memory_cr = 0.5 .* ones(memory_size, 1);
        memory_pos = 1;
        
        archive.NP = arc_rate * pop_size; % the maximum size of the archive
        archive.pop = zeros(0, problem_size); % the solutions stored in te archive
        archive.funvalues = zeros(0, 1); % the function value of the archived solutions
        
        %% main loop
        while nfes < max_nfes
            pop = popold; % the old population becomes the current population
            [temp_fit, sorted_index] = sort(fitness, 'ascend');
            min(fitness)
            mem_rand_index = ceil(memory_size * rand(pop_size, 1));
            mu_sf = memory_sf(mem_rand_index);
            mu_cr = memory_cr(mem_rand_index);
            
            %% for generating crossover rate
            cr = normrnd(mu_cr, 0.1);
            term_pos = find(mu_cr == -1);
            cr(term_pos) = 0;
            cr = min(cr, 1);
            cr = max(cr, 0);
            
            %% for generating scaling factor
            sf = mu_sf + 0.1 * tan(pi * (rand(pop_size, 1) - 0.5));
            pos = find(sf <= 0);
            
            while ~ isempty(pos)
                sf(pos) = mu_sf(pos) + 0.1 * tan(pi * (rand(length(pos), 1) - 0.5));
                pos = find(sf <= 0);
            end
            
            sf = min(sf, 1);
            
            r0 = [1 : pop_size];
            popAll = [pop; archive.pop];
            [r1, r2] = gnR1R2(pop_size, size(popAll, 1), r0);
            
            pNP = max(round(p_best_rate * pop_size), 2); %% choose at least two best solutions
            randindex = ceil(rand(1, pop_size) .* pNP); %% select from [1, 2, 3, ..., pNP]
            randindex = max(1, randindex); %% to avoid the problem that rand = 0 and thus ceil(rand) = 0
            pbest = pop(sorted_index(randindex), :); %% randomly choose one of the top 100p% solutions
            
            vi = pop + sf(:, ones(1, problem_size)) .* (pbest - pop + pop(r1, :) - popAll(r2, :));
            vi = boundConstraint(vi, pop, lu);
            
            mask = rand(pop_size, problem_size) > cr(:, ones(1, problem_size)); % mask is used to indicate which elements of ui comes from the parent
            rows = (1 : pop_size)'; cols = floor(rand(pop_size, 1) * problem_size)+1; % choose one position where the element of ui doesn't come from the parent
            jrand = sub2ind([pop_size problem_size], rows, cols); mask(jrand) = false;
            ui = vi; ui(mask) = pop(mask);
            
            children_fitness = feval(fhd, ui', func);
            children_fitness = children_fitness';
            
            %%%%%%%%%%%%%%%%%%%%%%%% for out
            for i = 1 : pop_size
                nfes = nfes + 1;
                total_nfes=total_nfes+1;
                if children_fitness(i) < bsf_fit_var
                    bsf_fit_var = children_fitness(i);
                    bsf_solution = ui(i, :);
                end
             
                if nfes > max_nfes; break; end
                
            end
            %%%%%%%%%%%%%%%%%%%%%%%% for out
            
            dif = abs(fitness - children_fitness);
            
            
            %% I == 1: the parent is better; I == 2: the offspring is better
            I = (fitness > children_fitness);
            goodCR = cr(I == 1);
            goodF = sf(I == 1);
            dif_val = dif(I == 1);
            
            %      isempty(popold(I == 1, :))
            archive = updateArchive(archive, popold(I == 1, :), fitness(I == 1));
            
            [fitness, I] = min([fitness, children_fitness], [], 2);
            
            popold = pop;
            popold(I == 2, :) = ui(I == 2, :);
            
            num_success_params = numel(goodCR);
            
            if num_success_params > 0
                sum_dif = sum(dif_val);
                dif_val = dif_val / sum_dif;
                
                %% for updating the memory of scaling factor
                memory_sf(memory_pos) = (dif_val' * (goodF .^ 2)) / (dif_val' * goodF);
                
                %% for updating the memory of crossover rate
                if max(goodCR) == 0 || memory_cr(memory_pos)  == -1
                    memory_cr(memory_pos)  = -1;
                else
                    memory_cr(memory_pos) = (dif_val' * (goodCR .^ 2)) / (dif_val' * goodCR);
                end
                
                memory_pos = memory_pos + 1;
                if memory_pos > memory_size;  memory_pos = 1; end
            end
            
            %% for resizing the population size
            plan_pop_size = round((((min_pop_size - max_pop_size) / max_nfes) * nfes) + max_pop_size);
            
            if pop_size > plan_pop_size
                reduction_ind_num = pop_size - plan_pop_size;
                if pop_size - reduction_ind_num <  min_pop_size; reduction_ind_num = pop_size - min_pop_size;end
                
                pop_size = pop_size - reduction_ind_num;
                for r = 1 : reduction_ind_num
                    [valBest indBest] = sort(fitness, 'ascend');
                    worst_ind = indBest(end);
                    popold(worst_ind,:) = [];
                    pop(worst_ind,:) = [];
                    fitness(worst_ind,:) = [];
                end
                
                archive.NP = round(arc_rate * pop_size);
                
                if size(archive.pop, 1) > archive.NP
                    rndpos = randperm(size(archive.pop, 1));
                    rndpos = rndpos(1 : archive.NP);
                    archive.pop = archive.pop(rndpos, :);
                end
            end
             bsf_error_val = bsf_fit_var - optimum;
        
         if bsf_error_val<10^(-11)
           break; 
        end
        end
        fit3=bsf_fit_var;
       if bsf_error_val<10^(-11)
           break; 
        end
       % total_nfes=nfes;
       % for run_id = 1 : 1
        %%  parameter settings for L-SHADE
      pop_size=500;
      pop_sel=400;
     mu=pop_sel;
     weights=log(mu+1/2)-log(1:mu)';
     weights=weights/sum(weights);
        
        %% Initialize the main population
        popold = repmat(lu(1, :), pop_size, 1) + rand(pop_size, problem_size) .* (repmat(lu(2, :) - lu(1, :), pop_size, 1));
        pop = popold; % the old population becomes the current population
        fitness = feval(fhd,pop',func);
        fitness = fitness';
        
        nfes = 0;
        bsf_fit_var = 1e+30;
        bsf_solution = zeros(1, problem_size);
        
        %%%%%%%%%%%%%%%%%%%%%%%% for out
        for i = 1 : pop_size
            nfes = nfes + 1;
            
            if fitness(i) < bsf_fit_var
                bsf_fit_var = fitness(i);
                bsf_solution = pop(i, :);
            end 
            if nfes > max_nfes; break; end
        end
      
        
        %% main loop
        while nfes < max_nfes
           
            pop = popold; % the old population becomes the current population
            [temp_fit, sorted_index] = sort(fitness, 'ascend');
            preserved_value=min(fitness)
            
            if preserved_value-1<bsf_error_val
              bsf_error_val=preserved_value-1;
            end
            
            popnew=pop(sorted_index(1:pop_sel),:);
             meanval=(popnew(:,1:problem_size)'*weights)';
             stdval=1*std(popnew);
%             if max(stdval)<0.01
%                stdval=max_region*rand(1,problem_size);
%             end
              for k=1:pop_size
                  popold(k,:)=meanval+stdval.*randn(1,problem_size);
                  for j=1:problem_size
                       if popold(k,j)>= max_region
                          popold(k,j)= max_region;
                       elseif popold(k,j)<=min_region
                           popold(k,j)=min_region;
                       end
                  end
                  
                   nfes = nfes + 1;
                   total_nfes=total_nfes+1;
              end
               fitness = feval(fhd,popold',func);
               if abs(max(fitness)-preserved_value)<10^(-11)
                   break;
               end
               if abs(min(fitness)-1)<10^(-11)
                   break;
               end
        end 
         if abs(min(fitness)-1)<10^(-11)
                   break;
         end
    
        [meanvec,fit]=RRSO;
                if fit-1<bsf_error_val
                   bsf_error_val=fit-1;
                end
               memory1(1,:)=meanvec;
               value(1,:)=fit;
                memory1(2,:)=meanval;
                memory1(3,:)=bsf_solution;
               value(2,:)=min(fitness);
               value(3,:)=fit3;
               [val,val_index]=sort(value);
             if val_index(1)==1
                 %for iteration=1:20
                     [memory1,value]=RRSO1;
                      memory1(1,:)=meanvec;
               value(1,:)=fit;
                memory1(2,:)=meanval;
                memory1(3,:)=bsf_solution;
               value(2,:)=min(fitness);
               value(3,:)=fit3;
               [val,val_index]=sort(value);
                  %   memory(iteration,:)=meanvec;
                   %  value(iteration,:)=fit;
                % end
             else
                 for iteration=4:20
                      pop_size=500;
      pop_sel=400;
     mu=pop_sel;
     weights=log(mu+1/2)-log(1:mu)';
     weights=weights/sum(weights);
        
        %% Initialize the main population
        popold = repmat(lu(1, :), pop_size, 1) + rand(pop_size, problem_size) .* (repmat(lu(2, :) - lu(1, :), pop_size, 1));
        pop = popold; % the old population becomes the current population
        fitness = feval(fhd,pop',func);
        fitness = fitness';
        
        nfes = 0;
        bsf_fit_var = 1e+30;
        bsf_solution = zeros(1, problem_size);
        
        %%%%%%%%%%%%%%%%%%%%%%%% for out
        for i = 1 : pop_size
            nfes = nfes + 1;
            
            if fitness(i) < bsf_fit_var
                bsf_fit_var = fitness(i);
                bsf_solution = pop(i, :);
            end 
            if nfes > max_nfes; break; end
        end
      
        
        %% main loop
        while nfes < max_nfes
            pop = popold; % the old population becomes the current population
            [temp_fit, sorted_index] = sort(fitness, 'ascend');
            preserved_value=min(fitness)
            
            if preserved_value-1<bsf_error_val
                bsf_error_val=preserved_value-1;
            end
            
            popnew=pop(sorted_index(1:pop_sel),:);
             meanval=(popnew(:,1:problem_size)'*weights)';
             stdval=1*std(popnew);
%             if max(stdval)<0.01
%                stdval=max_region*rand(1,problem_size);
%             end
              for k=1:pop_size
                  popold(k,:)=meanval+stdval.*randn(1,problem_size);
                  for j=1:problem_size
                       if popold(k,j)>= max_region
                          popold(k,j)= max_region;
                       elseif popold(k,j)<=min_region
                           popold(k,j)=min_region;
                       end
                  end
                  
                   nfes = nfes + 1;
                   total_nfes=total_nfes+1;
              end
               fitness = feval(fhd,popold',func);
               if abs(max(fitness)-preserved_value)<10^(-11)
                   break;
               end
                if abs(min(fitness)-1)<10^(-11)
                   break;
               end
        end 
         
               if abs(min(fitness)-1)<10^(-11)
                   break;
              end
        memory1(iteration,:)=meanval;
        value(iteration,:)=min(fitness);
                 end
%              else
%                  for iteration=4:20
%                  end
             end
          if abs(min(fitness)-1)<10^(-11)
                   break;
                   
          end
             
                [val,val_index]=sort(value); 
       for ss=1:20
           abc1(ss)=val(21-ss);
       end
    %    end
        test=0;
        
       for kkk=1:200
        for dim=1:problem_size
             
               ind=ceil((-4.3)*log(rand));
        if ind>problem_size
           ind=mod(ind,problem_size);
          if ind==0
             ind=1;
         end
       end
      if ind==0
         ind=1;
      end
            vector_cpsomhs(dim)=memory1(val_index(ind),dim);
        end
         
          pop = repmat(lu(1, :), pop_size, 1) + rand(pop_size, problem_size) .* (repmat(lu(2, :) - lu(1, :), pop_size, 1));
        pop(1,:)=vector_cpsomhs;
        
           [a,b,c]=CPSO_func(fhd,700,700*10*problem_size,10,problem_size,min_region,max_region,func)
           abc1(20+k)=b;
if abc1(20+k)>abc1(20+k-1)
        abc1(20+k)=abc1(19+k);
end
if b<value(val_index(3))
for d=1:problem_size
    memory1(val_index(20),d)=a(d);
end
value(val_index(20))=b;
end

           for dup=1:20
               if sum((memory1(dup,:)-a).^2)<0.1
                  test=1;
               end
           end
           
           if b<max(value)
               if test==0
              memory1(val_index(20),:)=a;
              value(val_index(20))=b;
               end
           end
            [val,val_index]=sort(value);
           test=0;
            
           if val(1)-1<bsf_error_val
              bsf_error_val=val(1)-1;
            end
           
            if abs(val(1)-1)<10^(-11)
                   break;
               end
       end
        
      
        
bsf_error_val=min(value)-1;
        
        
        
        
        %% record digits and FEs
        if bsf_error_val <= digit_1_reach  && digit_1 == 0
            fprintf('The first digit is caught at %d', nfes); 
            digit_1 = 1;
        end
        
        if bsf_error_val <= digit_2_reach  && digit_2 == 0
            fprintf('The first digit is caught at %d', nfes); 
            digit_2 = 1;
        end
        
         if bsf_error_val <= digit_3_reach  && digit_3 == 0
            fprintf('The first digit is caught at %d', nfes); 
            digit_3 = 1;
         end
        
         if bsf_error_val <= digit_4_reach  && digit_4 == 0
            fprintf('The first digit is caught at %d', nfes); 
            digit_4 = 1;
         end
        
         if bsf_error_val <= digit_5_reach  && digit_5 == 0
            fprintf('The first digit is caught at %d', nfes); 
            digit_5 = 1;
         end
     
        %% 
           
        
        fprintf('%d th run, best-so-far error value = %1.8e\n', total_run, bsf_error_val)
       % outcome = [ outcome bsf_error_val];
    end %% end 1 run
    outcome = [ outcome bsf_error_val];
    total_num_nfes=[total_num_nfes total_nfes];
    
   end
   clear vector_cpsomhs
   dd=[1,2]
   eval(['save ' num2str(func) '_' num2str(dd(1)) '.txt outcome -ASCII'])
     eval(['save ' num2str(func) '_' num2str(dd(2)) '.txt total_num_nfes -ASCII'])
    fprintf('\n')
    fprintf('mean error value = %1.8e, std = %1.8e\n', mean(outcome), std(outcome))
end %% end 1 function runy
