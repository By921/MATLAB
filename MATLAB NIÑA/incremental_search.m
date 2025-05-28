function incremental_search()
    clc;
    clear;

    % Get function as a string and convert to anonymous function
    func_str = input('Enter the function f(x): ', 's');
    f = str2func(['@(x) ' func_str]);

    % Get parameters from user
    x0 = input('Enter initial value x0: ');
    delta = input('Enter step size ?x: ');
    max_iter = input('Enter maximum number of iterations: ');

    % Initialize
    x = x0;
    fx = f(x);
    found = false;
    iter = 0;

    % Table data: iteration, x_i, x_i+1, f(x_i), f(x_i+1)
    table_data = [];

    fprintf('\n%-10s %-15s %-15s %-15s %-15s\n', ...
        'Iter', 'x_i', 'x_i+1', 'f(x_i)', 'f(x_i+1)');

    while iter < max_iter
        x_next = x + delta;
        fx_next = f(x_next);

        iter = iter + 1;
        table_data(iter, :) = [iter, x, x_next, fx, fx_next]; %#ok<AGROW>

        fprintf('%-10d %-15.6f %-15.6f %-15.6f %-15.6f\n', ...
            iter, x, x_next, fx, fx_next);

        % Check for sign change
        if fx * fx_next < 0
            found = true;
            break;
        end

        % Update for next iteration
        x = x_next;
        fx = fx_next;
    end

    % Result message
    if found
        fprintf('\nA root lies between x = %.6f and x = %.6f\n', x, x_next);
    else
        fprintf('\nNo root found in the given range and iterations.\n');
    end

    % Plotting
figure('Name', 'Incremental Search Method');
x_vals = linspace(x0, x_next + delta, 500);
y_vals = arrayfun(f, x_vals);
plot(x_vals, y_vals, 'b-', 'LineWidth', 2);
hold on;
plot(x_vals, zeros(size(x_vals)), '--k'); % manual x-axis line
xlabel('x');
ylabel('f(x)');
title('Incremental Search Method');
grid on;

% Mark root interval
if found
    plot([x, x_next], [f(x), f(x_next)], 'ro', 'MarkerFaceColor', 'r');
    legend('f(x)', 'y = 0', 'Sign Change Interval');
end

end
