function  pBest_ind = LearnIndex(pfit,popsize,D,i,Pci);
%  exemplar index

for j = 1:D
    if rand<Pci
        ind1 = randi(popsize);
        while ind1==i, ind1 = randi(popsize);  end
        ind2 = randi(popsize); 
        while ind2==i||ind2==ind1, ind2 = randi(popsize);  end
        if pfit(ind1)<pfit(ind2)
            pBest_ind(j) = ind1;
        else
            pBest_ind(j) = ind2;
        end 
    else
        pBest_ind(j) = i;
    end 
end

if all(pBest_ind==i)    
    ind = randi(popsize);
    while ind==i, ind = randi(popsize);  end
    pBest_ind(randi(D)) = ind; 
end

