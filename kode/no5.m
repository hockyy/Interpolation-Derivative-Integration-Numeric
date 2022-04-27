5;
%Program 3.5 Calculation of spline coefficients
%Calculates coefficients of cubic spline
%Input: x,y vectors of data points
% plus two optional extra data v1, vn
%Output: matrix of coefficients b1,c1,d1;b2,c2,d2;
%%
function coeff = spline(x, y)
    n = length(x);
    v1 = 0;
    vn = 0;
    A=zeros(n, n); % matrix A is nxn
    r=zeros(n, 1);
    for i=1:n-1 % define the deltas
        dx(i) = x(i + 1) - x(i);
        dy(i) = y(i + 1) - y(i);
    end
    for i=2:n-1 % load the A matrix
        A(i, i-1:i+1) = [dx(i-1), 2 * (dx(i-1) + dx(i)), dx(i)];
        r(i) = 3 * (dy(i) / dx(i) - dy(i - 1) / dx(i - 1)); % right-hand side
    end
    
    % Set endpoint conditions
    % Use only one of following 5 pairs:
    
    A(1, 1) = 1; % natural spline conditions
    A(n, n) = 1;
    
    %A(1, 1) = 2; r(1) = v1; % curvature-adj conditions
    %A(n, n) = 2; r(n) = vn;
    
    %A(1, 1:2) = [2 * dx(1) dx(1)]; r(1) = 3 * (dy(1) / dx(1) - v1); %clamped
    %A(n, n-1:n) = [dx(n-1) 2 * dx(n-1)]; r(n) = 3 * (vn - dy(n - 1)/dx(n - 1));
    %A(1, 1:2)=[1 -1]; % parabol-term conditions, for n>=3
    %A(n, n-1:n)=[1 -1];

    %A(1, 1:3) = [dx(2) -(dx(1) + dx(2)) dx(1)]; % not-a-knot, for n>=4
    %A(n, n-2:n) = [dx(n - 1) - (dx(n - 2) + dx(n - 1)) dx(n - 2)];
    
    coeff = zeros(n, 3);
    
    coeff(:,2) = A \ r; % solve for c coefficients
    for i=1:n-1 % solve for b and d
        coeff(i, 3) = (coeff(i+1, 2) - coeff(i, 2)) / (3 * dx(i));
        coeff(i, 1) = dy(i) / dx(i) - dx(i) * (2 * coeff(i, 2) + coeff(i+1, 2)) / 3;
    end
    coeff = coeff(1:n-1, 1:3);
end

%Program 3.6 Cubic spline plot
%Computes and plots spline from data points
%Input: x,y vectors of data points, number k of plotted points
% per segment
%Output: x1, y1 spline values at plotted points
function [x1, y1] = splineplot(x, y, k)
    n = length(x);
    coeff = spline(x, y);
    x1 = []; y1 = [];
    for i=1:n-1
        xs = linspace(x(i), x(i+1), k+1);
        dx = xs - x(i);
        ys = coeff(i, 3) * dx; % evaluate using nested multiplication
        ys = (ys + coeff(i, 2)) .* dx;
        ys = (ys + coeff(i, 1)) .* dx + y(i);
        x1 = [x1; xs(1:k)'];
        y1 = [y1; ys(1:k)'];
    end
    x1 = [x1; x(end)];
    y1 = [y1; y(end)];
    plot(x, y, 'o', x1, y1)
end

function y = getValue(splines, x, base)
  splines
  x
  n = length(splines)
  y = 0;
  for i=n:-1:1
    y = y * (x - base);
    y = y + splines(i);
  end
  y
end

function normalPlot(a, step, b, x, splines)
  splines
  x
  n = length(x)
  X = a:step:b;
  for i=1:length(X)
    for j=2:n
      if(x(j) > X(i) || j == n)
        fprintf("Using %d %d\n", j - 1, X(i));
        Y(i) = getValue(splines(j - 1, :), X(i), x(j - 1))
        break;
      end
    end
  end
  plot(X, Y, '.-r')
  hold on
end

%% Initialize Data

dataPenduduk = [1960, 97.02; 1970, 119.21; 1980, 147.49; 1990, 179.38; 2000, 206.26; 2010, 237.63; 2020, 270.20];
[n, ~] = size(dataPenduduk);
x = dataPenduduk(1:n, 1);
y = dataPenduduk(1:n, 2);
%%
coeff = spline(x, y)

plotX = [x] %% Append to inf
plotCoeff = [y(1:n-1), coeff]
normalPlot(1950, 2, 2040, plotX, plotCoeff)
plot(x, y, 'b* ')

% splineplot(x, y, 1)
%% Make Cubic Spline From Data
