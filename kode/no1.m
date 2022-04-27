1;
%% Initialize Data
dataPenduduk = [1960, 97.02; 1970, 119.21; 1980, 147.49; 1990, 179.38; 2000, 206.26; 2010, 237.63; 2020, 270.20];
y = [97.02; 119.21; 147.49; 179.38; 206.26; 237.63; 270.20;];

%% Plotting
[n ~] = size(dataPenduduk);
x = dataPenduduk(1:n,1);
y = dataPenduduk(1:n,2);
plot(x, y, '-or', 'MarkerFaceColor','k')
grid on

%% Nomor 1

f1 = @(x) x;
f2 = @(x) x - 1970;
f3 = @(x) x - 2010;
f4 = @(x) (x - 2010)/30;

A = hitung(f1,dataPenduduk);
cond(A)
A = hitung(f2,dataPenduduk);
cond(A)
A = hitung(f3,dataPenduduk);
cond(A)
A = hitung(f4,dataPenduduk);
cond(A)

%% Plot each function

curused = f1;
A = hitung(curused,dataPenduduk);
c = A \ y;
ytilde = zeros(n, 1);
for i=1:n
    ytilde(i) = horner(x(i), curused, c);
end

format bank
A

format long
c
fprintf("Error ialah %.20f\n", norm(ytilde-y));

% format bank
% plot(x, ytilde, '-or', 'MarkerFaceColor','k')
% hold on

%% Plot with shorter interval

curused = f4;
A = hitung(curused, dataPenduduk);
c = A \ y;
xtilde = 1960:1:2030;
[~, n] = size(xtilde);
ytilde = zeros(n, 1);
for i=1:n
    ytilde(i) = horner(xtilde(i), curused, c);
end

format bank
plot(xtilde, ytilde, '-.r', 'MarkerFaceColor','k')
% hold on


%% Solving and Prediction

% Akan diselesaikan persamaan Ac = y
prediksi = 2030;
A = hitung(f4,dataPenduduk);
c = A \ y;
horner(prediksi, f4, c)

%% Functions definition

function nilai = horner(x, basis, koefisien)
    base = basis(x);
    % fprintf("%f adalah basis saat ini\n", base);
    [n, ~] = size(koefisien);
    nilai = 0;
    for i=n:-1:1
        nilai = nilai * base;
        % fprintf("%f memiliki nilai\n", nilai);
        nilai = nilai + koefisien(i);
    end
end

function A = hitung(basis, data)
  [n, ~] = size(data);
  A = zeros(n, n);
  % Akan dibuat vandermonde matrix
  for i=1:n
    for j=1:n
      if(j == 1)
        A(i, j) = 1;
        base = basis(data(i));
      else
        A(i, j) = base * A(i, j - 1);
      end
    end
  end
end

