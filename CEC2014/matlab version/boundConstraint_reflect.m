function vn=boundConstraint_reflect(vi, low, up);

[NP, D] = size(vi);  % the population size and the problem's dimension


for i = 1:NP
    for j = 1:D 
        if vi(i,j) > up(j)
            vn(i,j) = max( 2*up(j)-vi(i,j), low(j) );
        elseif vi(i,j) < low(j)
            vn(i,j) = min( 2*low(j)-vi(i,j), up(j) );
        else
            vn(i,j) = vi(i,j);
        end  
    end
end  