% Script principal para ejecutar los métodos de búsqueda de raíces
% -------------------------------------------------------------------------
% Este programa permite resolver ecuaciones no lineales usando tres métodos:
% 1. Newton-Raphson   2. Bisección   3. Secante
% -------------------------------------------------------------------------

% ========================= CONFIGURACIÓN INICIAL =========================
pkg load symbolic;        % Cargar paquete para cálculos simbólicos
clear;                    % Limpiar variables del workspace
clc;                      % Limpiar consola

% ======================== SELECCIÓN DEL MÉTODO ==========================
% Crear menú interactivo para que el usuario elija el método numérico
metodo = menu('Seleccione el método:', 'Newton', 'Bisección', 'Secante');

% ======================== INGRESO DE LA FUNCIÓN =========================
% Obtener la función del usuario como cadena de texto y convertir a forma simbólica
funcion_str = inputdlg('Ingrese la función f(x):', 'Función');
syms x;                   % Declarar variable simbólica
f = sym(funcion_str{1});  % Convertir string a función simbólica

% ======================= CONFIGURACIÓN DE TOLERANCIA =====================
TOL = str2double(inputdlg('Ingrese la tolerancia TOL: '));  % Convertir entrada a número
max_iter = 150;           % Límite de iteraciones para evitar bucles infinitos

% ====================== EJECUCIÓN DEL MÉTODO SELECCIONADO ================
switch metodo
    case 1 % Método de Newton-Raphson
        x0 = str2double(inputdlg('Ingrese el punto inicial x0: '));  % Punto inicial
        a_plot = x0 - 5;  % Límite inferior para gráfico (centrado en x0 ±5)
        b_plot = x0 + 5;  % Límite superior para gráfico
        tic;              % Iniciar cronómetro
        [raiz, iter] = newton(f, x0, TOL, max_iter, a_plot, b_plot);
        tiempo = toc;     % Detener cronómetro
        metodo_str = 'Newton';

    case 2 % Método de Bisección
        % Obtener intervalo válido [a, b] (admite expresiones como pi/2)
        a = str2num(inputdlg('Ingrese el límite inferior a: '){1});  % Extraer y convertir celda
        b = str2num(inputdlg('Ingrese el límite superior b: '){1});
        a_plot = a;       % Usar intervalo ingresado para gráfico
        b_plot = b;
        tic;
        [raiz, iter] = biseccion(f, a, b, TOL, max_iter, a_plot, b_plot);
        tiempo = toc;
        metodo_str = 'Bisección';

    case 3 % Método de la Secante
        x0 = str2double(inputdlg('Ingrese el primer punto x0: '));
        x1 = str2double(inputdlg('Ingrese el segundo punto x1: '));
        a_plot = min(x0, x1) - 5;  % Ajustar rango gráfico según puntos ingresados
        b_plot = max(x0, x1) + 5;
        tic;
        [raiz, iter] = secante(f, x0, x1, TOL, max_iter, a_plot, b_plot);
        tiempo = toc;
        metodo_str = 'Secante';
end

% ===================== COMPARACIÓN CON FUNCIÓN NATIVA ====================
f_handle = matlabFunction(f);  % Convertir función simbólica a función numérica

% Usar intervalo original para bisección, raíz aproximada para otros métodos
if metodo == 2
    fzero_raiz = fzero(f_handle, [a, b]);  % Método de intervalo
else
    fzero_raiz = fzero(f_handle, raiz);    % Método de punto inicial
end

% ======================== VISUALIZACIÓN DE RESULTADOS ====================
fprintf('\n--- Resultados Finales ---\n');
fprintf('Método: %s\n', metodo_str);
fprintf('Raíz aproximada: %.6f\n', raiz);            % Raíz encontrada
fprintf('f(raíz) = %.6e\n', f_handle(raiz));         % Valor de la función en raíz
fprintf('Iteraciones: %d\n', iter);                  % Número de iteraciones
fprintf('Tiempo ejecución: %.4f segundos\n', tiempo); % Tiempo de cálculo
fprintf('Raíz con fzero: %.6f\n', fzero_raiz);       % Resultado de referencia
fprintf('f(fzero_raiz) = %.6e\n', f_handle(fzero_raiz)); % Validación final
