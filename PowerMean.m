% National Technical University of Athens
% School of Electrical and Computer Engineering
%
% Author: Ioannis Ntallas

function [ MS ] = PowerMean( S, r )

rows = size(S, 1);
sum = 0;

for i = 1:rows
    tmp = (RowMeanValue(S, i)) ^ r;
    sum = sum + tmp;
end

MS = sum / rows;

end

