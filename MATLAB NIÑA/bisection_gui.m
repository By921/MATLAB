function bisection_method_r2015a()
    clc;
    clear;

    % --- Get user input
    func_str = input('Enter the function in terms of x (e.g., x^3 - x - 2): ', 's');

    % --- Auto-convert operators for elementwise support
    func_str = strrep(func_str, '^', '.^');
    func_str = strrep(func_str, '*', '.*');
    func_str = strrep(func_str, '/', './');

    % --- Try converting to function
    try
        f = eval(['@(x)', func_str]);  % use eval() instead of str2func for R2015a
    catch
        error('Invalid function. Please make sure it is a valid expression in terms of x.');
    end

    % --- Get numerical input
    a = input('Enter the lower bound (a): ');
    b = input('Enter the upper bound (b): ');
    tol = input('Enter the tolerance (e.g., 1e-5): ');
    max_iter = input('Enter the maximum number of iterations: ');

    % --- Check if signs are opposite
    if f(a) * f(b) > 0
        error('f(a) and f(b) must have opposite signs.');
    end

    a0 = a; b0 = b;  % Save original bounds for plot
    iter = 0;
    tableData = [];

    fprintf('\n%-6s %-12s %-12s %-12s %-12s\n', 'Iter', 'a', 'b', 'xr', 'f(xr)');

    % --- Bisection loop
    while iter < max_iter
        xr = (a + b)/2;
        fxr = f(xr);
        iter = iter + 1;

        % Store data
        tableData(end+1, :) = [iter, a, b, xr, fxr]; %#ok<AGROW>
        fprintf('%-6d %-12.6f %-12.6f %-12.6f %-12.6f\n', iter, a, b, xr, fxr);

        % Check stopping condition
        if abs(fxr) < tol || abs(b - a)/2 < tol
            break;
        end

        if f(a) * fxr < 0
            b = xr;
        else
            a = xr;
        end
    end

    % --- Plot
    figure('Name', 'Bisection Method (R2015a Compatible)', 'NumberTitle', 'off');
    subplot(2,1,1);
    x_vals = linspace(a0 - 1, b0 + 1, 500);
    y_vals = arrayfun(f, x_vals);
    plot(x_vals, y_vals, 'b', 'LineWidth', 1.5); hold on;
    plot(xr, fxr, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot(xlim, [0 0], 'k--');  % horizontal y = 0 line
    grid on;
    xlabel('x'); ylabel('f(x)');
    title('Function Plot with Approximate Root');
    legend('f(x)', 'Root', 'Location', 'best');

    % --- Table
    subplot(2,1,2);
    columnNames = {'Iter', 'a', 'b', 'xr', 'f(xr)'};
    uitable('Data', tableData, 'ColumnName', columnNames, ...
        'Units', 'normalized', 'Position', [0 0 1 0.4]);

    % --- Final root
    fprintf('\nApproximate root: %.8f\n', xr);
end
