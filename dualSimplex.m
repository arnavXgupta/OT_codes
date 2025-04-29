clc; clear all; close all;
%%
A = [-2 -1; -1 -1; 1 1];
B = [3; -2; 2];            
constr = [1; 1; 1];      
c = [-2 -3];             
objective = 1;

%%
[m, nn] = size(A);
slackSurplus = 1;
E = eye(m);
for i = 1:m
    if constr(i) == 1                              % 1 means <= constraint
        Aug(i, :) = [A(i, :) E(slackSurplus, :)];
        slackSurplus = slackSurplus + 1;
    end
end
Aug
%% Make the first simplex table
Aug = [Aug B]; [m, n] = size(Aug); 
cost = [c zeros(1, n - nn - 1)];
BV = zeros(m, 1);
optima = 0;
Aug

%%
while(optima == 0)
    for i = 1:n-1
        if(sum(Aug(:, i) == 0) == m-1 && sum(Aug(:, i) == 1) == 1)
            col = find(Aug(:, i) == 1);
            BV(col) = i;
        end
    end
    BV
    %%
    zj = cost(BV) * Aug(:, 1:n-1);
    zj_cj = zj - cost;
    obj_val = cost(BV) * Aug(:, end);
    fprintf('Correct obj value is %f\n', obj_val);

    RHS = Aug(:, end);
    if all(RHS >= 0)
        fprintf('Optimal solution found. \n');
        optima = 1;
        break;
    end

    % Step 1: Choose leaving variable (most negative RHS)
    [min_val, leave] = min(RHS);
    
    % Step 2: Compute ratio test (only for zj_cj < 0)
    ratios = inf(1, n - 1);
    for j = 1:n-1
        if Aug(leave, j) < 0
            ratios(j) = abs(zj_cj(j) / Aug(leave, j));
        end
    end
    
    [min_ratio, entry] = min(ratios);
    if isinf(min_ratio) 
        error("Dual Simplex failed: problem is infeasible");
    end

    % Pivot operation
    pivot = Aug(leave, entry);
    Aug(leave, :) = Aug(leave, :) / pivot;
    Aug(leave, entry) = 1; 

    for i = 1:m
        if i ~= leave
            multi = Aug(i, entry);
            Aug(i, :) = Aug(i, :) - multi * Aug(leave, :);
        end
    end

    BV(leave) = entry;
end

% Final check
zj = cost(BV) * Aug(:, 1:n-1);
zj_cj = zj - cost;

[value, entry] = min(zj_cj);
if value >= 0
    fprintf('Optima Reached with value %f \n', obj_val);
    optima = 1;
end

ratio = Aug(:, n) ./ Aug(:, entry);
ind = (Aug(:, entry) <= 0);  % changed to include zero case
ratio(ind) = NaN;

[min_ratio, leave] = min(ratio);
pivot = Aug(leave, entry);

Aug(leave, :) = Aug(leave, :) / pivot;
Aug(leave, entry) = 1;

for k = 1:m
    if k ~= leave
        multi = Aug(k, entry);
        Aug(k, :) = Aug(k, :) - multi * Aug(leave, :);
    end
end