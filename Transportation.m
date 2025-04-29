A = [6 8 10 9; 9 12 13 7; 14 9 16 5];
S = [15, 25, 10];
D = [5, 15, 20, 10];
[m, n] = size(A);
alloc = 0;
%%
ts = sum(S(:));
td = sum(D(:));
%%

if ts~=td
    if td<ts
        D(n+1) = ts - td;
        A = [A, zeros(m, 1)];
    else
        S(m+1) = td- ts;
        A = [A; zeros(1, n)];
    end
end

[m, n] = size(A);
%%
B = zeros(m, n);
Acost = A;

%%Least Allocation Loop
while alloc < m + n - 1
    Val = min(A(:));

    %locate the indices of minimum
    [r, c] = find(A==Val);
         r = r(1);
         c = c(1);

  % allocate the minimum of available indices
    B(r,c)=min(S(r),D(c));
    alloc=alloc+1;
    %Update supply demand
    S(r)=S(r)-B(r,c);
    D(c)=D(c)-B(r,c);

    %Handle degeneracy
    if S(r)==0 && D(c)==0
        A(:, c) = NaN;
        S(r) = 1e-5;
    elseif  S(r) == 0
        A(r, :) = NaN;
    else
        A(:, c) = NaN;
    end
end
disp('Allocation Matrix B:');
disp(B);
Initial_Cost = sum(sum(Acost .* B));
fprintf('Initial Transportation Cost: %d\n', Initial_Cost)