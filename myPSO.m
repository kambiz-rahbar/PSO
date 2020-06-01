function [G] = myPSO(b_lo, b_up, S, max_run)

%% init
diff_b = b_up - b_lo;

dim = length(b_lo);

X = diff_b .* rand(S, dim) + b_lo;

P = X;

X_eval = evaluate(X);
[G_val, best_pos] = min(X_eval);

G = P(best_pos, :);

V = 2*diff_b .* rand(S, dim) - diff_b;

%% run

P_eval = X_eval;

P_val_hist = zeros(max_run, S);
P_val_hist(1,:) = X_eval;

G_val_hist = zeros(max_run, 1);
G_val_hist(1) = G_val;

k = 1;
termination_criterion = false;
w = 0.4;
phi_p = 0.3;
phi_g = 0.3;

while (~termination_criterion)
    k = k+1;
    r_p = rand;
    r_g = rand;
    
    V = w*V + phi_p*r_p*(P-X) + phi_g*r_g*(G-X);
    
    new_X = X + V;
    new_eval = evaluate(new_X);
    
    best_val = min(new_eval, P_eval);
    
    P(best_val == new_eval, :) = new_X(best_val == new_eval, :);
    P_eval = evaluate(P);
    
    P_val_hist(k,:) = P_eval;
    
    [G_val, best_pos] = min(P_eval);
    G = P(best_pos, :);
    
    G_val_hist(k) = G_val;
    
    X = new_X;
    %X_eval = new_eval;
    
    if k > max_run
        termination_criterion = true;
    end
    
end

%% results
disp('minimum is:');
disp(G);

figure(1);
subplot(1,2,1);
plot(log(1+P_val_hist),'b');
title('best particle evaluation');
xlabel('run');
ylabel('log(evaluation)');
grid minor;

subplot(1,2,2);
hold on;
plot(log(1+P_val_hist(:,1)),'b');
plot(log(1+G_val_hist),'r');
hold off;
title('best particle evaluation');
xlabel('run');
ylabel('log(evaluation)');
legend('best 1st local','best global');
grid minor;


