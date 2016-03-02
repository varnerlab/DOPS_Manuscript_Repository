# Script to plot the panels of Fig 6 in the DOPS manuscript -
# Author: J.Varner

using MAT
using Debug
using PyPlot

# Load the 10D and 300D Rastrigin data -
# data_rastrigin_10D_dds = readdlm("./10D/Rastrigin/DDS/DDS_error_iter25.txt");
# data_rastrigin_10D_de = readdlm("./10D/Rastrigin/DE/DE_error_iter25.txt");
# data_rastrigin_10D_pso = readdlm("./10D/Rastrigin/PSO/PSO_error_iter25.txt");
# data_rastrigin_10D_sa = readdlm("./10D/Rastrigin/SA/SA_error_iter25.txt");
#
# data_rastrigin_300D_dds = readdlm("./300D/Rastrigin/DDS/DDS_error_iter25.txt");
# data_rastrigin_300D_de = readdlm("./300D/Rastrigin/DE/DE_error_iter25.txt");
# data_rastrigin_300D_pso = readdlm("./300D/Rastrigin/PSO/PSO_error_iter25.txt");
# data_rastrigin_300D_sa = readdlm("./300D/Rastrigin/SA/SA_error_iter25.txt");


function scale_trajectory_array(data_array)

  # Size -
  (number_of_trials,number_of_iterations) = size(data_array);

  scale_factor = mean(data_array);

  # Initiale the scaled array -
  scaled_array = zeros(number_of_trials,number_of_iterations);

  # Scale -
  for trial_index in collect(1:number_of_trials)

    for iteration_index in collect(1:number_of_iterations)

      value = (data_array[trial_index,iteration_index])/scale_factor;
      scaled_array[trial_index,iteration_index] = value;
    end
  end

  # return -
  return scaled_array;
end

function analyze_rastrigin_10D_data()

  data_dds = readdlm("./10D/Rastrigin/DDS/DDS_error_iter25.txt");
  data_de = readdlm("./10D/Rastrigin/DE/DE_error_iter25.txt");
  data_pso = readdlm("./10D/Rastrigin/PSO/PSO_error_iter25.txt");
  data_sa = transpose(readdlm("./10D/Rastrigin/SA/SA_error_iter25.txt"));
  data_dops = load_dops_data("./10D/Rastrigin/DOPS")

  # Calculate the maximum over all the trials for all data -
  initial_array = [data_dds[:,1] ; data_de[:,1] ; data_pso[:,1] ; data_sa[:,1]; data_dops[:,1]];
  max_initial_error = maximum(initial_array);

  # Scale the initial data point with the max_initial_error -
  scaled_dds = (1.0/max_initial_error).*data_dds;
  scaled_de = (1.0/max_initial_error).*data_de;
  scaled_pso = (1.0/max_initial_error).*data_pso;
  scaled_sa = (1.0/max_initial_error).*data_sa;
  scaled_dops = (1.0/max_initial_error).*data_dops;


  # Build data array that we will return -
  data_dictionary = Dict();

  # Calculte the performance for each method -
  performance_dds = analysis_logic(scaled_dds);
  performance_de = analysis_logic(scaled_de);
  performance_pso = analysis_logic(scaled_pso);
  performance_sa = analysis_logic(scaled_sa);
  performance_dops = analysis_logic(scaled_dops);

  # pack -
  data_dictionary["performance_sa"] = performance_sa;
  data_dictionary["performance_dds"] = performance_dds;
  data_dictionary["performance_de"] = performance_de;
  data_dictionary["performance_pso"] = performance_pso;
  data_dictionary["performance_dops"] = performance_dops;

  # return -
  return (data_dictionary);
end


function analyze_rastrigin_300D_data()

  data_dds = readdlm("./300D/Rastrigin/DDS/DDS_error_iter25.txt");
  data_de = readdlm("./300D/Rastrigin/DE/DE_error_iter25.txt");
  data_pso = readdlm("./300D/Rastrigin/PSO/PSO_error_iter25.txt");
  data_sa = transpose(readdlm("./300D/Rastrigin/SA/SA_error_iter25.txt"));
  data_dops = load_dops_data("./300D/Rastrigin/DOPS")

  # Calculate the maximum over all the trials for all data -
  initial_array = [data_dds[:,1] ; data_de[:,1] ; data_pso[:,1] ; data_sa[:,1]; data_dops[:,1]];
  max_initial_error = maximum(initial_array);

  # Scale the initial data point with the max_initial_error -
  scaled_dds = (1.0/max_initial_error).*data_dds;
  scaled_de = (1.0/max_initial_error).*data_de;
  scaled_pso = (1.0/max_initial_error).*data_pso;
  scaled_sa = (1.0/max_initial_error).*data_sa;
  scaled_dops = (1.0/max_initial_error).*data_dops;


  # Build data array that we will return -
  data_dictionary = Dict();

  # Calculte the performance for each method -
  performance_dds = analysis_logic(scaled_dds);
  performance_de = analysis_logic(scaled_de);
  performance_pso = analysis_logic(scaled_pso);
  performance_sa = analysis_logic(scaled_sa);
  performance_dops = analysis_logic(scaled_dops);

  # pack -
  data_dictionary["performance_sa"] = performance_sa;
  data_dictionary["performance_dds"] = performance_dds;
  data_dictionary["performance_de"] = performance_de;
  data_dictionary["performance_pso"] = performance_pso;
  data_dictionary["performance_dops"] = performance_dops;

  # return -
  return (data_dictionary);
end

function analyze_ackley_data(function_dimension)

  if (function_dimension == "10D")

    data_ackley_dds = readdlm("./10D/Ackley/DDS/DDS_error_iter25.txt");
    data_ackley_de = readdlm("./10D/Ackley/DE/DE_error_iter25.txt");
    data_ackley_pso = readdlm("./10D/Ackley/PSO/PSO_error_iter25.txt");
    data_ackley_sa = transpose(readdlm("./10D/Ackley/SA/SA_error_iter25.txt"));
    data_ackley_dops = load_dops_data("./10D/Ackley/DOPS")

  elseif (function_dimension == "300D")

    data_ackley_dds = readdlm("./300D/Ackley/DDS/DDS_error_iter25.txt");
    data_ackley_de = readdlm("./300D/Ackley/DE/DE_error_iter25.txt");
    data_ackley_pso = readdlm("./300D/Ackley/PSO/PSO_error_iter25.txt");
    data_ackley_sa = transpose(readdlm("./300D/Ackley/SA/SA_error_iter25.txt"));
    data_ackley_dops = load_dops_data("./300D/Ackley/DOPS")

  end

  # Calculate the maximum over all the trials for all data -
  initial_array = [data_ackley_dds[:,1] ; data_ackley_de[:,1] ; data_ackley_pso[:,1] ; data_ackley_sa[:,1]; data_ackley_dops[:,1]];
  max_initial_error = maximum(initial_array);

  # Scale the initial data point with the max_initial_error -
  scaled_dds = (1.0/max_initial_error).*data_ackley_dds;
  scaled_de = (1.0/max_initial_error).*data_ackley_de;
  scaled_pso = (1.0/max_initial_error).*data_ackley_pso;
  scaled_sa = (1.0/max_initial_error).*data_ackley_sa;
  scaled_dops = (1.0/max_initial_error).*data_ackley_dops;

  # Build data array that we will return -
  data_dictionary = Dict();

  # Calculte the performance for each method -
  performance_dds = analysis_logic(scaled_dds);
  performance_de = analysis_logic(scaled_de);
  performance_pso = analysis_logic(scaled_pso);
  performance_sa = analysis_logic(scaled_sa);
  performance_dops = analysis_logic(scaled_dops);

  # pack -
  data_dictionary["performance_sa"] = performance_sa;
  data_dictionary["performance_dds"] = performance_dds;
  data_dictionary["performance_de"] = performance_de;
  data_dictionary["performance_pso"] = performance_pso;
  data_dictionary["performance_dops"] = performance_dops;

  # return -
  return (data_dictionary);
end

function load_dops_data(file_path)

  number_of_trials = 25;
  data_array = zeros(number_of_trials,4000);
  for trial_index in collect(1:number_of_trials)

    # Construct the file path for the PSO phase -
    fully_qualified_path_pso = "$(file_path)/DDSPSO_strategy1_error_iter$(trial_index).mat";
    pso_file = matopen(fully_qualified_path_pso);
    pso_dict = read(pso_file);
    g_best_solution = pso_dict["g_best_solution"];
    close(pso_file)

    # Construct the file path for the DDS phase -
    fully_qualified_path_dds = "$(file_path)/DDSPSO_strategy1_errordds_iter$(trial_index).mat";
    dds_file = matopen(fully_qualified_path_dds);
    dds_dict = read(dds_file);
    bestval_dds_swarm = dds_dict["bestval_dds_swarm"];
    close(dds_file)

    # Populate the data array for this trial -
    number_of_pso_steps = length(g_best_solution);
    number_of_dds_steps = length(bestval_dds_swarm);
    global_step_counter = 1;
    for outer_pso_step in collect(1:number_of_pso_steps)

      # get the best value -
      value = g_best_solution[outer_pso_step];

      # fill in the array -
      for particle_index in collect(1:40)
        data_array[trial_index,global_step_counter] = value;
        global_step_counter+=1;
      end
    end

    for dds_step in collect(1:number_of_dds_steps)
      data_array[trial_index,global_step_counter] = bestval_dds_swarm[dds_step];
      global_step_counter+=1;
    end
  end

  return data_array;
end


function analysis_logic(scaled_data_array)

  # calculate the dds data array -
  (number_of_rows,number_of_cols) = size(scaled_data_array);
  method_array = zeros(3,2);
  method_array[1,1] = mean(scaled_data_array[:,1]);
  method_array[1,2] = std(scaled_data_array[:,1]);

  # Calculate the midpoint index, and mean/std for midpoint -
  midpoint_index = round(number_of_cols/2.0)
  midpoint_mean_dds = mean(scaled_data_array[:,midpoint_index]);
  midpoint_std_dds = std(scaled_data_array[:,midpoint_index]);
  method_array[2,1] = midpoint_mean_dds;
  method_array[2,2] = midpoint_std_dds;

  # Endpoint -
  end_index = number_of_cols;
  end_mean_dds = mean(scaled_data_array[:,end_index]);
  end_std_dds = std(scaled_data_array[:,end_index]);
  method_array[3,1] = end_mean_dds;
  method_array[3,2] = end_std_dds;

  # return -
  return method_array;
end
