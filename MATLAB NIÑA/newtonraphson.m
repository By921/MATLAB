clc;
clear;
close all;

% --- User Input ---
f_str = input('Enter the function f(x) = ', 's');          % e.g. 'x^3 - x - 2'
df_str = input('Enter the derivative f''(x) = ', 's');     % e.g. '3*x^2 - 1'

x0 = input('Enter initial guess x0 = ');                   % e.g. 1.5
tol = input('Enter tolerance (e.g. 1e-6) = ');
max_iter = input('Enter maximum number of iterations = ');

% Convert strings to function handles
f = str2func(['@(x) ' f_str]);
df = str2func(['@(x) ' df_str]);

% Initialize variables
x = x0;
iter = 0;
error = inf;

% Prepare table data
results = [];

fprintf('\nIter\t x_n\t\t f(x_n)\t\t Error\n');
fprintf('---------------------------------------------\n');

while error > tol && iter < max_iter
    iter = iter + 1;
    fx = f(x);
    dfx = df(x);
    
    if dfx == 0
        disp('Derivative zero. Stopping iteration.');
        break;
    end
    
    x_new = x - fx/dfx;
    error = abs(x_new - x);
    
    results = [results; iter, x, fx, error];
    
    fprintf('%d\t %.6f\t %.6f\t %.6e\n', iter, x, fx, error);
    
    x = x_new;
end

% Create a table for display
T = array2table(results, 'VariableNames', {'Iteration', 'x_n', 'f_xn', 'Error'});

fprintf('\nRoot approximation: %.8f\n', x);

% Plotting
figure;
hold on;
grid on;
title('Newton-Raphson Method');
xlabel('x');
ylabel('f(x)');

% Plot function
x_vals = linspace(x-2, x+2, 400);
plot(x_vals, f(x_vals), 'b-', 'LineWidth', 2);

% Plot iterations: tangent lines and points
for k = 1:iter
    xk = results(k, 2);
    fxk = results(k, 3);
    dfxk = df(xk);
    
    % Tangent line: y = f(xk) + f'(xk)*(x - xk)
    tangent_x = linspace(xk - 1, xk + 1, 100);
    tangent_y = fxk + dfxk*(tangent_x - xk);
    
    plot(tangent_x, tangent_y, 'r--');
    plot(xk, fxk, 'ko', 'MarkerFaceColor', 'k'); % iteration points on curve
end

plot(x, 0, 'gp', 'MarkerSize', 15, 'MarkerFaceColor', 'g'); % final root approx

legend('f(x)', 'Tangent lines', 'Iterations points', 'Root approx');

hold off;

% Display the table
disp('Iteration Table:');
disp(T);
