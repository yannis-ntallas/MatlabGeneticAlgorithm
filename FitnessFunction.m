% National Technical University of Athens
% School of Electrical and Computer Engineering
%
% Author: Ioannis Ntallas

function [ CS, QS ] = FitnessFunction(adj, comp, r)

components = size(comp, 2);
CS = 0;

for i = 1 : components
    
   submatrix = subgraph(adj, comp{i});
   QS = PowerMean(submatrix, r) * SubmatrixVolume(submatrix);
   
   CS = CS + QS;
end

end

