function false_position_method()
    clc; clear;

    % Input the function as a string, then convert to function handle
    func_str = input('Enter the function f(x) = ', 's');
    f = str2func(['@(x) ' func_str]);
    
    % Input interval [a,b]
    a = input('Enter the interval start a: ');
    b = input('Enter the interval end b: ');
    
    % Check if function changes sign over [a,b]
    if f(a)*f(b) > 0
        error('Function does not change sign over the interval. Choose another interval.');
    end
    
    tol = input('Enter the tolerance (e.g., 1e-6): ');
    max_iter = input('Enter maximum number of iterations: ');
    
    fprintf('\nIteration\t a\t\t b\t\t c\t\t f(c)\t\t Error\n');
    
    iter = 0;
    c_old = a;
    error_approx = inf;
    
    % Prepare arrays for plotting and table
    iter_arr = [];
    a_arr = [];
    b_arr = [];
    c_arr = [];
    fc_arr = [];
    err_arr = [];
    
    while error_approx > tol && iter < max_iter
        iter = iter + 1;
        
        % False Position formula
        c = b - (f(b)*(a - b)) / (f(a) - f(b));
        
        fc = f(c);
        
        % Store data for table and plotting
        iter_arr(end+1) = iter;
        a_arr(end+1) = a;
        b_arr(end+1) = b;
        c_arr(end+1) = c;
        fc_arr(end+1) = fc;
        
        if iter == 1
            error_approx = abs(c - c_old);
        else
            error_approx = abs(c - c_old);
        end
        err_arr(end+1) = error_approx;
        
        fprintf('%d\t\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\n', iter, a, b, c, fc, error_approx);
        
        % Update interval
        if f(a)*fc < 0
            b = c;
        else
            a = c;
        end
        
        c_old = c;
    end
    
    % Display final root approximation
    fprintf('\nApproximate root after %d iterations is: %.6f\n', iter, c);
    
    % Create table
    T = table(iter_arr', a_arr', b_arr', c_arr', fc_arr', err_arr', ...
        'VariableNames', {'Iteration', 'a', 'b', 'c', 'f_c', 'Error'});
    disp(T);
    
    % Plotting
    figure;
    % Plot the function over [a,b] extended a bit
    x_vals = linspace(min([a_arr b_arr]) - 1, max([a_arr b_arr]) + 1, 400);
    y_vals = arrayfun(f, x_vals);
    plot(x_vals, y_vals, 'b-', 'LineWidth', 1.5);
    hold on;
    
    % Plot zero line
    plot(x_vals, zeros(size(x_vals)), 'k--');
    
    % Plot root approximations c
    plot(c_arr, zeros(size(c_arr)), 'ro', 'MarkerFaceColor', 'r');
    
    xlabel('x');
    ylabel('f(x)');
    title('False Position Method Root Approximation');
    legend('f(x)', 'y=0', 'Root Approximations (c)');
    grid on;
    hold off;
end
