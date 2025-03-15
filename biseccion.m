function [raiz, iter] = biseccion(f, a, b, TOL, max_iter, a_plot, b_plot)
    syms x;
    f_handle = matlabFunction(f);
    iter = 0;
    fa = f_handle(a);
    fb = f_handle(b);

    if fa * fb >= 0
        error('La función no cambia de signo en el intervalo [a, b].');
    end

    % Configurar gráfica
    x_vals = linspace(a_plot, b_plot, 1000);
    plot(x_vals, f_handle(x_vals), 'b-', 'DisplayName', 'Función');
    hold on;
    title('Método de Bisección');
    xlabel('x'); ylabel('f(x)'); grid on;
    legend('show');

    fprintf('%-10s %-15s %-15s %-15s\n', 'Iteración', 'c', 'f(c)', 'Error');

    while iter < max_iter
        c = (a + b) / 2;
        fc = f_handle(c);
        error_actual = (b - a) / 2;

        % Graficar punto
        plot(c, fc, 'ro', 'MarkerFaceColor', 'r');
        drawnow;

        fprintf('%-10d %-15.6f %-15.6e %-15.6e\n', iter, c, fc, error_actual);

        if error_actual <= TOL || abs(fc) <= TOL
            raiz = c;
            iter = iter + 1;
            break;
        end

        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
        iter = iter + 1;
    end

    if iter >= max_iter
        raiz = (a + b) / 2;
        fprintf('Máximo de iteraciones alcanzado.\n');
    else
        fprintf('Convergencia lograda.\n');
    end

    plot(raiz, f_handle(raiz), 'g*', 'MarkerSize', 10, 'DisplayName', 'Raíz');
    hold off;
end
