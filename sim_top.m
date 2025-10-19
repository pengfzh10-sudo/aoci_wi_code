
%% ---------------------------------------------------------------------
%% ----------------Whittle Index and Optimal Threshold Simulation-------
%% ---------------------------------------------------------------------

sim_whittle_threshold();
  

%% --------------------------------------------------------------------
%% ----------------Offline Simulation----------------------------------
%% --------------------------------------------------------------------
resolution = 0.05 ;
total_time = 3000 ;
num_sample_path = 500 ;
num_G = 5000;

%% Simulations about Average cost versus lambda
sim_average_cost_vs_lambda(resolution,total_time,num_sample_path,num_G);

%% Simulations about Average cost versus C
sim_average_cost_vs_C(resolution,total_time,num_sample_path,num_G);   

%% Simulations about Average cost versus pr
sim_average_cost_vs_pr(resolution,total_time,num_sample_path,num_G);

%% Simulations about Average cost with correlated delay
sim_average_cost_vs_pc_correlate(resolution,total_time,num_sample_path,num_G);



%% --------------------------------------------------------------------
%% ----------------Online Simulation----------------------------------
%% --------------------------------------------------------------------

online_policy_evaluation();
