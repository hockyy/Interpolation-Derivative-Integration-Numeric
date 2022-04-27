%% Initialize Data

dataPenduduk = [1960, 97.02; 1970, 119.21; 1980, 147.49; 1990, 179.38; 2000, 206.26; 2010, 237.63; 2020, 270.20];
x = dataPenduduk(1:n, 1);
y = dataPenduduk(1:n, 2);
%% Compute Using Newton's Method Divided Difference

coefficients = dividedDifference(x, y);
getValue(2030, coefficients, x);
xtilde = 1960:1:2030;
ytilde = zeros(size(xtilde));
for i=1:size(xtilde')
    ytilde(i) = getValue(xtilde(i), coefficients, x);
end
plot(xtilde, ytilde, '-.r');
%% Get Value of a Newton Basis
% This will need the array of coefficients $c$ as the parameter, and the array 
% $x$ as the initial $x$'s data. This will compute the value of interpolation 
% at the point $p$.

function y = getValue(p, c, x)
    [n, ~] = size(x);
    y = 0;
    disp(x'); disp(c');
    for i=n:-1:1
        y = y * (p - x(i));
        y = y + c(i);
    end
end
%% Divided Difference

function coefficients = dividedDifference(x, y)
    [n, ~] = size(x);
    % Divided difference table contains a column of x, appended with
    % a square square matrix with size x computing the coefficients
    divTable = [y, zeros(n, n - 1)];
    disp(x);
    disp(divTable);
    for j=2:n
       for i=1:n-j+1
           % This computes the interval of f[x(i), x(i + j - 1)]
           divTable(i, j) = (divTable(i + 1, j - 1) - divTable(i, j - 1)) / (x(i + j - 1) - x(i));
       end
    end
    disp(divTable);
    disp(divTable(1:1, 1:n));
    coefficients = divTable(1:1, 1:n)';
    disp(coefficients);
end