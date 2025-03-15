
% Script principal para ejecutar los métodos de búsqueda de raíces
pkg load symbolic;
clear;
clc;

% Menú para seleccionar el método
metodo = menu('Seleccione el método:', 'Newton', 'Bisección', 'Secante');

% Ingresar la función como string y convertir a simbólica
funcion_str = inputdlg('Ingrese la función f(x):', 'Función');
syms x;
f = sym(funcion_str{1});

% Ingresar tolerancia
TOL = str2double(inputdlg('Ingrese la tolerancia TOL: '));
max_iter = 150; % Máximo de iteraciones según el problema

% Obtener datos iniciales según el método
switch metodo
    case 1 % Newton
        x0 = str2double(inputdlg('Ingrese el punto inicial x0: '));
        a_plot = x0 - 5;
        b_plot = x0 + 5;
        tic;
        [raiz, iter] = newton(f, x0, TOL, max_iter, a_plot, b_plot);
        tiempo = toc;
        metodo_str = 'Newton';
    case 2 % Bisección
        a = str2double(inputdlg('Ingrese el límite inferior a: '));
        b = str2double(inputdlg('Ingrese el límite superior b: '));
        a_plot = a;
        b_plot = b;
        tic;
        [raiz, iter] = biseccion(f, a, b, TOL, max_iter, a_plot, b_plot);
        tiempo = toc;
        metodo_str = 'Bisección';
    case 3 % Secante
        x0 = str2double(inputdlg('Ingrese el primer punto x0: '));
        x1 = str2double(inputdlg('Ingrese el segundo punto x1: '));
        a_plot = min(x0, x1) - 5;
        b_plot = max(x0, x1) + 5;
        tic;
        [raiz, iter] = secante(f, x0, x1, TOL, max_iter, a_plot, b_plot);
        tiempo = toc;
        metodo_str = 'Secante';
end

% Comparación con fzero
f_handle = matlabFunction(f);
if metodo == 2
    fzero_raiz = fzero(f_handle, [a, b]);
else
    fzero_raiz = fzero(f_handle, raiz);
end

% Resultados
fprintf('\n--- Resultados Finales ---\n');
fprintf('Método: %s\n', metodo_str);
fprintf('Raíz aproximada: %.6f\n', raiz);
fprintf('f(raíz) = %.6e\n', f_handle(raiz));
fprintf('Iteraciones: %d\n', iter);
fprintf('Tiempo ejecución: %.4f segundos\n', tiempo);
fprintf('Raíz con fzero: %.6f\n', fzero_raiz);
fprintf('f(fzero_raiz) = %.6e\n', f_handle(fzero_raiz));
