% National Technical University of Athens
% School of Electrical and Computer Engineering
%
% Author: Ioannis Ntallas

function [ m ] = RowMeanValue( S, row )

columns = size(S, 2);
value_sum = 0;

for i = 1:columns
    value_sum = value_sum + S(row, i);
end

m = value_sum / columns;

end

