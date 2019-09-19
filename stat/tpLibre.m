clear;
close all;

%timedFct(@expWithLoop, 1000000)
%timedFct(@expNoLoop, 1000000)
%timedFct(@expNoLoopWithSum, 1000000);

function res = timedFct(fct,N)
  tic
  res = fct(N);
  toc
endfunction

% appel timedFct, example : timedFct(@expWithLoop, 10)

function res = expWithLoop(N)
  res=0;
  for i=1:N
    res = res + exp(-0.5 * i);
  endfor
endfunction

function res = expNoLoop(N)
  res = exp( -0.5 * (1:N) ) * ones(N,1);
endfunction

function res = expNoLoopWithSum(N)
  res = sum(exp(-0.5 * (1:N)));
endfunction

%rgb2gray !!








