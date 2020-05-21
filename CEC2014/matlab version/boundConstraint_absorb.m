function vn = boundConstraint_absorb(vi, low, up);

[NP, D] = size(vi);  % the population size and the problem's dimension


vn = vi;

% for i = 1:NP
%     I = [];
%     I = vi(i,:) > up | vi(i,:) < low;
%     vn(i,I) = low(I) + rand(1,sum(I)).*(up(I)-low(I));
% end
    
    
for i = 1:NP    
    for j = 1:D 
        if vi(i,j) > up(j) 
            vn(i,j) = up(j);
        elseif  vi(i,j) < low(j)
            vn(i,j) = low(j);
        else
            vn(i,j) = vi(i,j);
        end  
    end
end  