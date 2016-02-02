% National Technical University of Athens
% School of Electrical and Computer Engineering
%
% Author: Ioannis Ntallas

% INPUT  : Adjacency matrix.
% OUTPUT : List of neighbours including start node.

function neighbours = GetNeighbours( adj, n )

neighbours = [];
for i = 1:size(adj, 1)
    if (((adj(i, n) == 1) || (adj(n, i) == 1)) && (i ~= n))
        neighbours = [neighbours i];
    end
end

end

