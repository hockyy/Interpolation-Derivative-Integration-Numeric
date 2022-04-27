function [c, v] = no4()
  
  # reuse coefficient from no3
  [x0, y0, x, y, c, v] = no3();
  newX = 2030; newY = y(newX);
  x0 = [x0 newX];
  y0 = [y0 newY];
  # ans
  # c = newtdd(x0, y0, 8);
  [n, n] = size(v);
  newRow = [newY zeros(1, n-1)];
  v(n+1, :) = newRow;
  newCol = zeros(n+1, 1);
  v(:, n+1) = newCol;
  n+=1;
  
  # menambahkan diagonal baru pada newton divided difference table
  j=1;
  for i=n:-1:2
    printf("i: %d, j: %d\n", i, j);
    v(i-1, j+1) = (v(i, j) - v(i-1, j)) / (newX - x0(i-1));
    #printf("v(%d,%d) = %d\n", i-1, j+1, v(i-1, j+1));
    j+=1;
  endfor
  
  c = zeros(1, n);
  for i=1:n
    c(i) = v(1, i);
  endfor
  
  y = nest(6, c, x, x0);
  y(2030)
  plot(x0,y0,'o', x , y(x));
  xlim([1960 2020]);
  ylim([50, 300]);
endfunction