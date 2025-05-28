clc;
clear;
close all;

% --- Input Section ---
f_str = input('Enter the function f(x) as a function of x (e.g. x^3 - x - 2): ','s');
f = str2func(['@(x) ' f_str]);  % Robust function handle

x0 = input('Enter the first initial guess x0: ');
x1 = input('Enter the second initial guess x1: ');
tol = input('Enter the tolerance (e.g. 1e-6): ');
max_iter = input('Enter maximum number of iterations: ');

% --- Initialization ---
iter = 0;
error = Inf;

% Store initial guesses
X = zeros(max_iter+2,1);
X(1) = x0;
X(2) = x1;

% Initialize storage for iteration data
x_nm1 = zeros(max_iter,1);
x_n = zeros(max_iter,1);
x_np1 = zeros(max_iter,1);
errors = zeros(max_iter,1);

fprintf('\nIter\t\tx0\t\t\tx1\t\t\tRoot Approx\t\tError\n');
fprintf('--------------------------------------------------------------------------------\n');

% --- Secant Method Iteration ---
while error > tol && iter < max_iter
    iter = iter + 1;
    
    fx0 = f(X(iter));
    fx1 = f(X(iter+1));
    
    % Avoid division by zero
    if fx1 == fx0
        warning('Division by zero encountered in iteration %d.', iter);
        break;
    end
    
    x_new = X(iter+1) - fx1*(X(iter+1) - X(iter)) / (fx1 - fx0);
    X(iter+2) = x_new;
    
    error = abs(x_new - X(iter+1));
    
    % Store data for table
    x_nm1(iter) = X(iter);
    x_n(iter) = X(iter+1);
    x_np1(iter) = x_new;
    errors(iter) = error;
    
    fprintf('%d\t\t%f\t%f\t%f\t%f\n', iter, X(iter), X(iter+1), x_new, error);
end

% Trim arrays to iteration count
x_nm1 = x_nm1(1:iter);
x_n = x_n(1:iter);
x_np1 = x_np1(1:iter);
errors = errors(1:iter);

% --- Display results in table ---
T = table((1:iter)', x_nm1, x_n, x_np1, errors, ...
    'VariableNames', {'Iteration', 'x_n_minus_1', 'x_n', 'x_n_plus_1', 'Error'});

disp(' ');
disp('Results Table:');
disp(T);

% --- Plot Section ---
figure;
hold on;

% Determine plotting range safely
plot_x_min = min(X(1:iter+2)) - 1;
plot_x_max = max(X(1:iter+2)) + 1;
if plot_x_min == plot_x_max
    plot_x_min = plot_x_min - 1;
    plot_x_max = plot_x_max + 1;
end

% Use arrayfun instead of fplot for compatibility
x_vals = linspace(plot_x_min, plot_x_max, 500);
y_vals = arrayfun(f, x_vals);
plot(x_vals, y_vals, 'b-', 'LineWidth', 1.5);

% Plot root approximations as red circles
plot(X(1:iter+2), zeros(iter+2,1), 'ro-', 'LineWidth', 2, 'MarkerSize', 6);

% Plot secant lines for each iteration
for k = 1:iter
    x_sec = linspace(X(k), X(k+1), 100);
    y_sec = f(X(k)) + (f(X(k+1)) - f(X(k))) / (X(k+1) - X(k)) * (x_sec - X(k));
    plot(x_sec, y_sec, 'g--', 'LineWidth', 1);
end

xlabel('x');
ylabel('f(x)');
title('Secant Method Root Finding');
grid on;
legend('f(x)', 'Root Approximations', 'Secant Lines', 'Location', 'Best');
hold off;
