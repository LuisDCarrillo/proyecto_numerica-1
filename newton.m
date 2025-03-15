% Script para el metodo de newton
function[raiz,iter]=newton(f,x0,TOL,max_iter,a_plot,b_plot)
syms x;
df=diff(f,x);
f_handle= matlabFunction(f);
df_handle= matlabFunction(df);

iter=0;
x_actual=x0;
error_rel=Inf;


%Script para configurar la grafica

x_vals=linspace(a_plot,b_plot,1000);
plot(x_vals,f_handle(x_vals), 'b-', 'DisplayName', 'Función');
hold on;
title('Metodo de Newton');
xlabel('x'); ylabel('f(x)'); grid on;

fprintf('%-10s %-15s %-15s %-15s\n','Iteración','x','f(x)','Error');

% Ciclo iterativo
while iter < max_iter
  fx=f_handle(x_actual);
  dfx=df_handle (x_actual);

  %Estructura condicional de la division por 0

  if dfx==0
    error('Derivada cerox=%.6f',x_actual);
  end
x_sig = x_actual - fx / dfx;
        error_rel = abs((x_sig - x_actual) / x_sig);

        % Mostrar y graficar
        fprintf('%-10d %-15.6f %-15.6e %-15.6e\n', iter, x_actual, fx, error_rel);
        plot(x_sig, f_handle(x_sig), 'ro', 'MarkerFaceColor', 'r');
        drawnow;

        if error_rel <= TOL || abs(f_handle(x_sig)) <= TOL
            raiz = x_sig;
            iter = iter + 1;
            break;
        end

        x_actual = x_sig;
        iter = iter + 1;
    end

    if iter >= max_iter
        raiz = x_actual;
        fprintf('Máximo de iteraciones alcanzado.\n');
    else
        fprintf('Convergencia lograda.\n');
    end

    plot(raiz, f_handle(raiz), 'g*', 'MarkerSize', 10, 'DisplayName', 'Raíz');
    legend show;
    hold off;
end

