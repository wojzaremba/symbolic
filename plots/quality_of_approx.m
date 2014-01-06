x = -5:0.1:5;
plot(x, exp(x), 'r', 'LineWidth', 3);
hold on
plot(x, 1 + x + x .^ 2 / 2, '-g', 'LineWidth', 2);
plot(x, 1 + x + x .^ 2 / 2 + x .^ 3 / 6, '--b', 'LineWidth', 2);
plot(x, 1 + x + x .^ 2 / 2 + x .^ 3 / 6 + x .^ 4 / 24, ':m', 'LineWidth', 2);
plot(x, 1 + x + x .^ 2 / 2 + x .^ 3 / 6 + x .^ 4 / 24 + x .^ 5 / 120, '-.c', 'LineWidth', 2);

l = legend('\fontsize{20}{0}\selectfont$e^x$', ...
           '\fontsize{20}{0}\selectfont$1 + x + \frac{x^2}{2!}$', ...
           '\fontsize{20}{0}\selectfont$1 + x + \frac{x^2}{2!} + \frac{x^3}{3!}$', ...
           '\fontsize{20}{0}\selectfont$1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + \frac{x^4}{4!}$', ...
           '\fontsize{20}{0}\selectfont$1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + \frac{x^4}{4!} + \frac{x^5}{5!}$', ...
           'Location', 'NorthWest');
set(l, 'Interpreter', 'Latex');
set(gca, 'FontSize', 20);

remove_border('/Users/wojto/symbolic/paper/img/approximations.png');