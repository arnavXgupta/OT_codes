clear all;
close all; 
clc
%% Initialinsing LPP
A=[1 1; 3 -1; 1 0; 0 1];
B=[1;-3;0;0];
constr=[1;1];
c=[1 1];
n=size(A,1);
P=max(B);x=0:0.001:P;
objective=1;
%
%%Plotting the const
for i=1:n-2
    if A(i,2)~=0
        lines(i,:)=(B(i)-A(i,1)*x)/A(i,2);
    else
        lines(i,:)=x;
    end
end
%% Plotting ii
for i=1:n-2
    if A(i,2)~=0
        plot(x,max(lines(i,:),0))
        hold on
        %drawnow 
        pause(1)
    else
        line([B(i)/A(i,1),B(i)/A(i,1)],xlim)
        hold on
        pause(1)
    end
end    

pairs=nchoosek(1:n,2);pt=[];
for i=1:size(pairs,1)
    A1=[ A(pairs(i,1),:);A(pairs(i,2),:)];
    B1=[B(pairs(i,1));B(pairs(i,2))];
    if cond(A1) > 10000000
        fprintf('Pair %d is singular or nearly singular. Skipping ', i)
        continue;
    end
    x=A1\B1; % \ is inverse
    if x >= 0
        pt=[pt x];
    end
end
pt=pt';
sol=unique(pt,'rows');
hold on;

%%Keeping only feasible points
x1=sol(:,1); x2=sol(:,2);
for i=1:size(A,1)-2
    if constr(i) > 0 % constr <=
        ind = find(A(i,:)*sol' > B(i));
        sol(ind,:)=[];
    elseif constr(i) < 0
        ind = find(A(i,:)*sol' < B(i));
        sol(ind,:)=[];
    else
        constr(i)=0;
        ind = find(A(i,:)*sol' ~= B(i));
        sol(ind,:)=[];
    end
end
if numel(sol) == 0
    fprintf('Infeasible LPP\n')
else
    obj_val = c * sol';
    if objective == 1
        [value,ind] = max(obj_val);
        fprintf("The optimum value is %f\n", value)
        fprintf('Point of optima is: (%g, %g)\n', sol(ind,:))
    else
        [value,ind] = min(obj_val);
        fprintf("The optimum value is %f\n", value)
        fprintf('Point of optima is: (%g, %g)\n', sol(ind,:))
    end
end

if numel(sol) ~= 0
    x = sol(:,1);
    y = sol(:,2);
    hold on
    if size(sol,1) == 1
        fprintf('The feasible region contains only 1 point\n')
    elseif size(sol,1) == 2
        fprintf('The feasible region is a line segment\n');
    else 
        k = convhull(x, y);
        fill(x(k), y(k), 'm', 'FaceAlpha', 0.4); % Changed color to pink ('m' for magenta)
        scatter(x, y, 'filled')
        drawnow;
        pause(1);
    end
end
