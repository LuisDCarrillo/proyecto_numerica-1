function [raiz, iter] = newton(f, x0, TOL, max_iter, a_plot, b_plot)
    % Método de Newton-Raphson para encontrar raíces de funciones
    % Inputs:
    %   f: Función simbólica a resolver
    %   x0: Punto inicial para el método
    %   TOL: Tolerancia de error aceptable
    %   max_iter: Número máximo de iteraciones permitidas
    %   a_plot, b_plot: Límites para el rango de graficación
    % Outputs:
    %   raiz: Aproximación de la raíz encontrada
    %   iter: Número de iteraciones realizadas

    syms x;
    df = diff(f, x);                % Calcular derivada simbólica
    f_handle = matlabFunction(f);    % Convertir función a numérica
    df_handle = matlabFunction(df);  % Convertir derivada a numérica

    iter = 0;            % Inicializar contador de iteraciones
    x_actual = x0;       % Establecer punto inicial
    error_rel = Inf;      % Inicializar error relativo

    % ========== CONFIGURACIÓN DE GRÁFICA ==========
    x_vals = linspace(a_plot, b_plot, 1000);  % Generar rango de graficación
    plot(x_vals, f_handle(x_vals), 'b-', 'DisplayName', 'Función');  % Graficar función original
    hold on;                % Mantener gráfico para superponer iteraciones
    title('Método de Newton');  % Título del gráfico
    xlabel('x'); ylabel('f(x)');  % Etiquetas de ejes
    grid on;                % Activar cuadrícula
    legend('show');         % Mostrar leyenda

    % ========== CABECERA DE TABLA DE ITERACIONES ==========
    fprintf('%-10s %-15s %-15s %-15s\n', 'Iteración', 'x', 'f(x)', 'Error');

    % ========== BUCLE PRINCIPAL DEL MÉTODO ==========
    while iter < max_iter
        fx = f_handle(x_actual);    % Evaluar función en punto actual
        dfx = df_handle(x_actual);  % Evaluar derivada en punto actual

        % Control de división por cero en fórmula de Newton
        if dfx == 0
            error('Derivada cero en x=%.6f. Elija nuevo punto inicial.', x_actual);
        end

        % ========== FÓRMULA DE NEWTON-RAPHSON ==========
        x_sig = x_actual - fx / dfx;           % Calcular siguiente iterado
        error_rel = abs((x_sig - x_actual)/x_sig);  % Error relativo porcentual

        % ========== ACTUALIZACIÓN GRÁFICA ==========
        plot(x_sig, f_handle(x_sig), 'ro', 'MarkerFaceColor', 'r');  % Marcar iteración actual
        drawnow;                % Actualizar gráfico en tiempo real

        % ========== REGISTRO DE ITERACIÓN ==========
        fprintf('%-10d %-15.6f %-15.6e %-15.6e\n', iter, x_actual, fx, error_rel);

        % ========== VERIFICACIÓN DE CONVERGENCIA ==========
        if error_rel <= TOL || abs(f_handle(x_sig)) <= TOL
            raiz = x_sig;       % Almacenar raíz convergida
            iter = iter + 1;    % Contar última iteración
            break;              % Salir del bucle
        end

        % ========== ACTUALIZACIÓN DEL PUNTO ==========
        x_actual = x_sig;       % Actualizar punto actual
        iter = iter + 1;        % Incrementar contador de iteraciones
    end

    % ========== MANEJO DE RESULTADOS FINALES ==========
    if iter >= max_iter
        raiz = x_actual;  % Devolver mejor aproximación
        fprintf('Máximo de iteraciones alcanzado.\n');
    else
        fprintf('Convergencia lograda.\n');
    end

    % ========== MARCADOR DE RAÍZ FINAL ==========
    plot(raiz, f_handle(raiz), 'g*', 'MarkerSize', 10, 'DisplayName', 'Raíz');  % Destacar raíz final
    legend show;    % Actualizar leyenda
    hold off;       % Liberar el gráfico
end
