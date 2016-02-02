% National Technical University of Athens
% School of Electrical and Computer Engineering
%
% Author: Ioannis Ntallas

function [ Adj ] = MakeAdjGeno( G )

genosize = size(G, 2);
Adj = zeros(genosize, genosize);

for i = 1:genosize
    Adj(i, G(i)) = 1;
    Adj(G(i), i) = 1;
end

end

