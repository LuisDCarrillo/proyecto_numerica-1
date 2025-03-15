function [raiz, iter] = secante(f, x0, x1, TOL, max_iter, a_plot, b_plot)
    syms x;
    f_handle = matlabFunction(f);
    iter = 0;
    error_rel = Inf;

    % Configurar gráfica
    x_vals = linspace(a_plot, b_plot, 1000);
    plot(x_vals, f_handle(x_vals), 'b-', 'DisplayName', 'Función');
    hold on;
    title('Método de la Secante');
    xlabel('x'); ylabel('f(x)'); grid on;
    legend('show');

    fprintf('%-10s %-15s %-15s %-15s\n', 'Iteración', 'x', 'f(x)', 'Error');

    while iter < max_iter
        fx0 = f_handle(x0);
        fx1 = f_handle(x1);

        if fx1 - fx0 == 0
            error('División por cero en la secante.');
        end

        x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0);
        error_rel = abs((x2 - x1) / x2);

        % Graficar punto
        plot(x2, f_handle(x2), 'ro', 'MarkerFaceColor', 'r');
        drawnow;

        fprintf('%-10d %-15.6f %-15.6e %-15.6e\n', iter, x2, f_handle(x2), error_rel);

        if error_rel <= TOL || abs(f_handle(x2)) <= TOL
            raiz = x2;
            iter = iter + 1;
            break;
        end

        x0 = x1;
        x1 = x2;
        iter = iter + 1;
    end

    if iter >= max_iter
        raiz = x2;
        fprintf('Máximo de iteraciones alcanzado.\n');
    else
        fprintf('Convergencia lograda.\n');
    end

    plot(raiz, f_handle(raiz), 'g*', 'MarkerSize', 10, 'DisplayName', 'Raíz');
    hold off;
end
