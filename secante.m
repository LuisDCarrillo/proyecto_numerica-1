function [raiz, iter] = secante(f, x0, x1, TOL, max_iter, a_plot, b_plot)
    % Método de la Secante para encontrar raíces de funciones
    % Inputs:
    %   f: Función simbólica a resolver
    %   x0, x1: Puntos iniciales para el método
    %   TOL: Tolerancia de error aceptable
    %   max_iter: Número máximo de iteraciones permitidas
    %   a_plot, b_plot: Límites para el rango de graficación
    % Outputs:
    %   raiz: Aproximación de la raíz encontrada
    %   iter: Número de iteraciones realizadas

    syms x;
    f_handle = matlabFunction(f);  % Convertir función simbólica a función numérica
    iter = 0;                      % Inicializar contador de iteraciones
    error_rel = Inf;               % Inicializar error relativo

    % ========== CONFIGURACIÓN DE GRÁFICA ==========
    x_vals = linspace(a_plot, b_plot, 1000);  % Generar valores para el eje x
    plot(x_vals, f_handle(x_vals), 'b-', 'DisplayName', 'Función');  % Graficar función
    hold on;                                   % Mantener gráfico para superponer iteraciones
    title('Método de la Secante');             % Título del gráfico
    xlabel('x'); ylabel('f(x)'); grid on;      % Etiquetas y cuadrícula
    legend('show');                            % Mostrar leyenda

    % ========== CABECERA DE TABLA DE ITERACIONES ==========
    fprintf('%-10s %-15s %-15s %-15s\n', 'Iteración', 'x', 'f(x)', 'Error');

    % ========== BUCLE PRINCIPAL DEL MÉTODO ==========
    while iter < max_iter
        fx0 = f_handle(x0);  % Evaluar función en x0
        fx1 = f_handle(x1);  % Evaluar función en x1

        % Control de división por cero en fórmula secante
        if fx1 - fx0 == 0
            error('División por cero en la secante. Los puntos iniciales deben cumplir f(x1) ≠ f(x0)');
        end

        % ========== FÓRMULA DE LA SECANTE ==========
        x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0);  % Calcular nueva aproximación
        error_rel = abs((x2 - x1) / x2);          % Calcular error relativo

        % ========== ACTUALIZACIÓN GRÁFICA ==========
        plot(x2, f_handle(x2), 'ro', 'MarkerFaceColor', 'r');  % Marcar iteración actual
        drawnow;                % Actualizar gráfico en tiempo real

        % ========== REGISTRO DE ITERACIÓN ==========
        fprintf('%-10d %-15.6f %-15.6e %-15.6e\n', iter, x2, f_handle(x2), error_rel);

        % ========== VERIFICACIÓN DE CONVERGENCIA ==========
        if error_rel <= TOL || abs(f_handle(x2)) <= TOL
            raiz = x2;          % Almacenar raíz convergida
            iter = iter + 1;    % Contar última iteración
            break;              % Salir del bucle
        end

        % ========== ACTUALIZACIÓN DE PUNTOS ==========
        x0 = x1;    % Actualizar punto anterior
        x1 = x2;    # El nuevo punto se convierte en el actual
        iter = iter + 1;  % Incrementar contador de iteraciones
    end

    % ========== MANEJO DE RESULTADOS FINALES ==========
    if iter >= max_iter
        raiz = x2;  % Devolver mejor aproximación aunque no converja
        fprintf('Máximo de iteraciones alcanzado.\n');
    else
        fprintf('Convergencia lograda.\n');
    end

    % ========== MARCADOR DE RAÍZ FINAL ==========
    plot(raiz, f_handle(raiz), 'g*', 'MarkerSize', 10, 'DisplayName', 'Raíz');  % Destacar raíz final
    hold off;  % Liberar el gráfico para nuevas figuras
end
