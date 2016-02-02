% National Technical University of Athens
% School of Electrical and Computer Engineering
%
% Author: Ioannis Ntallas

% Genetic Algorithm
%  
% INPUT  : adj ---> Adjacency matrix of graph
%          elite -> elitism option: 0   (no elitism)
%                                   1-3 (number of elites)
%          pc ----> Crossover probability
%          pm ----> Mutation probability

function [ bestgeno ] = GeneticAlgorithm(adj, elite, pc, pm)

% Parameter initialization
t = 1;                                              % Time
MAXTIME = 30;                                       % Maximum time allowed
MAXCOUNTF = 5;                                      % Max number of iterations gmaxf remains the same.
r = 1;                                              % For Power-Mean
nodes = size(adj, 1);                               % Number of nodes
popsize = 300;                                      % Population size
genotype_list = zeros(popsize, nodes, MAXTIME);     % All genotypes over time
fitness = zeros(1, popsize);                        % Fitnesses for current time
gmaxf = 0;                                          % Global max fitness
counterf = 0;                                       % How many iterations gmaxf is the same.

% Create initial population based on random neighbour selection.
for i = 1 : popsize
    for j = 1 : nodes
        neighbours = GetNeighbours(adj, j);
        genotype_list(i, j, t) = neighbours(randi([1 size(neighbours, 2)],1,1));
    end
end

while ((t < MAXTIME) && (counterf < MAXCOUNTF))
    
    % Calculate fitness
    for i = 1 : popsize
        Gadj = MakeAdjGeno(genotype_list(i,:,t));
        comp = find_conn_comp(Gadj);
        fitness(i) = FitnessFunction(adj, comp, r);
    end
    
    % Cumulative sum of fitness
    fitness_sums = cumsum(fitness);
    
    % Check if fitness is the same for 5 times.
    maxf = 0;
    for i = 1 : popsize
        if fitness(i) > maxf
            maxf = fitness(j);
        end
    end
    if (gmaxf == maxf)
        counterf = counterf + 1;
    end
    if (gmaxf < maxf)
        gmaxf = maxf;
    end
    
    % In case of elitism
    if (elite ~= 0)
        start = 1;
        % Elites are 1 - 3
        for i = 1 : elite
            maxf = fitness(start);
            pos = start;
            for j = start : popsize
                if fitness(j) > maxf
                    maxf = fitness(j);
                    pos = j;
                end
                % Flip genotypes
                tmp = genotype_list(start, :, t);
                genotype_list(start, :, t) = genotype_list(pos, :, t);
                genotype_list(pos, :, t) = tmp;
                % and fitnesses
                tmp2 = fitness(start);
                fitness(start) = fitness(pos);
                fitness(pos) = tmp2;
            end
            start = start + 1;
        end
        % Promote genotypes
        for i = 1 : elite
            genotype_list(i, :, t + 1) = genotype_list(i, :, t);
        end
    end
    
    % Proportional selection for the rest of the genome
    for i = (elite + 1) : popsize
        x = rand;
        k = 1;
        
        while ( (k < popsize) && (x > (fitness_sums(k) / fitness_sums(popsize))) )
            k = k + 1;
        end
        
        % Update genotypes
        genotype_list(i,:,t+1) = genotype_list(k,:,t);
    end
    
    % One-point crossover
    for i = 1 : 2 : (popsize - 1)
        x = rand;
        if (x <= pc)
            pos = randi([1 (nodes - 1)],1,1);
            for k = (pos + 1) : nodes
                aux = genotype_list(i, k, t + 1);
                genotype_list(i, k, t + 1) =  genotype_list(i + 1, k, t + 1);
                genotype_list(i + 1, k, t + 1) = aux;
            end
        end
    end
    
    % Mutation
    for i = 1 : popsize
        for k = 1 : nodes
            x = rand;
            if (x < pm)
                neighbours = GetNeighbours(adj, k);
                if (size(neighbours, 2) > 1)
                    neighbours = neighbours(neighbours ~= genotype_list(i, k, t));
                end
                replacement = neighbours(randi([1 size(neighbours, 2)],1,1));
                genotype_list(i, k, t + 1) = replacement;
            end
        end
    end
    
    % Increase time
    t = t + 1;
end

% Find best genotype
bestgeno = genotype_list(1, :, t);
bestfit = fitness(1);
for i = 2 : popsize
    if (fitness(i) > bestfit)
        bestgeno = genotype_list(i, :, t);
        bestfit = fitness(i);
    end
end

end

