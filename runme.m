clc
clear
close

b_lo = [-10 -10];
b_up = [10 10];

S = 30;

max_run = 20;

res = myPSO(b_lo, b_up, S, max_run);