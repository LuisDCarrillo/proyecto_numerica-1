function [raiz, iter] = biseccion(f, a, b, TOL, max_iter, a_plot, b_plot)
    % Método de Bisección para encontrar raíces de funciones
    % Inputs:
    %   f: Función simbólica a resolver
    %   a, b: Límites del intervalo inicial [a, b]
    %   TOL: Tolerancia de error aceptable
    %   max_iter: Número máximo de iteraciones permitidas
    %   a_plot, b_plot: Límites para el rango de graficación
    % Outputs:
    %   raiz: Aproximación de la raíz encontrada
    %   iter: Número de iteraciones realizadas

    syms x;
    f_handle = matlabFunction(f);  % Convertir función simbólica a numérica
    iter = 0;                      % Inicializar contador de iteraciones
    fa = f_handle(a);              % Evaluar función en extremo inferior
    fb = f_handle(b);              % Evaluar función en extremo superior

    % ========== VERIFICACIÓN INICIAL ==========
    if fa * fb >= 0
        error('La función no cambia de signo en [%.2f, %.2f]. Revisar Teorema de Bolzano.', a, b);
    end

    % ========== CONFIGURACIÓN DE GRÁFICA ==========
    x_vals = linspace(a_plot, b_plot, 1000);    % Generar rango de visualización
    plot(x_vals, f_handle(x_vals), 'b-', 'DisplayName', 'Función');  % Graficar función
    hold on;                         % Mantener gráfico para superponer iteraciones
    title('Método de Bisección');    % Título del gráfico
    xlabel('x'); ylabel('f(x)');     % Etiquetas de ejes
    grid on;                         % Activar cuadrícula
    legend('show');                  % Mostrar leyenda

    % ========== CABECERA DE TABLA DE ITERACIONES ==========
    fprintf('%-10s %-15s %-15s %-15s\n', 'Iteración', 'c', 'f(c)', 'Error');

    % ========== BUCLE PRINCIPAL DEL MÉTODO ==========
    while iter < max_iter
        c = (a + b) / 2;            % Calcular punto medio del intervalo
        fc = f_handle(c);           % Evaluar función en punto medio
        error_actual = (b - a)/2;   % Error absoluto máximo posible

        % ========== ACTUALIZACIÓN GRÁFICA ==========
        plot(c, fc, 'ro', 'MarkerFaceColor', 'r');  % Marcar punto medio actual
        drawnow;                     % Actualizar gráfico en tiempo real

        % ========== REGISTRO DE ITERACIÓN ==========
        fprintf('%-10d %-15.6f %-15.6e %-15.6e\n', iter, c, fc, error_actual);

        % ========== VERIFICACIÓN DE CONVERGENCIA ==========
        if error_actual <= TOL || abs(fc) <= TOL
            raiz = c;               % Almacenar raíz convergida
            iter = iter + 1;        % Contar última iteración
            break;                  % Salir del bucle
        end

        % ========== ACTUALIZACIÓN DE INTERVALO ==========
        if fa * fc < 0              % La raíz está en subintervalo izquierdo
            b = c;                  % Actualizar extremo derecho
            fb = fc;                % Conservar evaluación de función
        else                        % La raíz está en subintervalo derecho
            a = c;                  % Actualizar extremo izquierdo
            fa = fc;                % Conservar evaluación de función
        end
        iter = iter + 1;            % Incrementar contador de iteraciones
    end

    % ========== MANEJO DE RESULTADOS FINALES ==========
    if iter >= max_iter
        raiz = (a + b)/2;           % Devolver mejor aproximación disponible
        fprintf('Máximo de iteraciones alcanzado.\n');
    else
        fprintf('Convergencia lograda.\n');
    end

    % ========== MARCADOR DE RAÍZ FINAL ==========
    plot(raiz, f_handle(raiz), 'g*', 'MarkerSize', 10, 'DisplayName', 'Raíz');  % Destacar raíz final
    hold off;     % Liberar el gráfico
end
