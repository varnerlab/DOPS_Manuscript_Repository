% b4_test
% performs a test integration of the b4 model with nominal parameter values
% and displays the objective function value

[ydot, xinit, par] = b4(0);
objective = b4_obj(par);
disp(objective)