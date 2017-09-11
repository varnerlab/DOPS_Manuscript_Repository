%for plotting results after run_DOPS

NUMBER_TRIALS=25;
%fig = figure();
hold('on');
for j=1:NUMBER_TRIALS
    semilogy(1:size([g_best_solution{j},bestval_dds_swarm{j}],2),([g_best_solution{j},bestval_dds_swarm{j}]),'kx')
end
xlabel('Iteration')
ylabel('Error')