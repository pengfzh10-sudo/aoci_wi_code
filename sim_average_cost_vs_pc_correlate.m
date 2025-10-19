function sim_average_cost_vs_pc_correlate(resolution,total_time,num_sample_path,num_G)
%% ----------------------------------------------------------------------
%% ----------------Offline Simulation------------------------------------
%% ----------Simulations about Average cost versus lambda---------------------
%% ----------------------------------------------------------------------


%% Common Parameters, Channel and Policy Definition
channel = ['exp', 'const', 'nomal', 'logn', 'bursty', 'correlate'];
policy = ['aoci_whittle','aoi_whittle','maf_zw','macf_zw'];
if(nargin ~= 4)
    resolution = 0.05 ;
    total_time = 3000 ;
    num_sample_path = 500 ;
    num_G = 5000;
end
rand_seed = 100 ;
rng(rand_seed);
N = 4;
L = 2;
pr = 1/4 ;
lambda = 1;
C = 10;
lambda_set = 0:0.1:1;

var_x = lambda_set;
avg_cost_aoci_wi_correlate    = zeros(1,length(var_x));
avg_cost_aoi_wi_correlate     = zeros(1,length(var_x));
avg_cost_maf_zw_correlate     = zeros(1,length(var_x));
avg_cost_macf_zw_correlate    = zeros(1,length(var_x));

%% Evaluation of Policies
parfor ii = 1:length(var_x)
    ii
    lambda = var_x(ii);
    avg_cost_aoci_wi_correlate(ii) = offline_policy_evaluation('aoci_whittle',num_sample_path, 'correlate',num_G,lambda,N,L,pr,C,resolution,total_time);
    avg_cost_aoi_wi_correlate(ii) = offline_policy_evaluation('aoi_whittle',num_sample_path, 'correlate',num_G,lambda,N,L,pr,C,resolution,total_time);
    avg_cost_maf_zw_correlate(ii) = offline_policy_evaluation('maf_zw',num_sample_path, 'correlate',num_G,lambda,N,L,pr,C,resolution,total_time);
    avg_cost_macf_zw_correlate(ii) = offline_policy_evaluation('macf_zw',num_sample_path, 'correlate',num_G,lambda,N,L,pr,C,resolution,total_time);
end

%% Plot Result

    figure
    set(gcf, 'Position', [100, 100, 500, 500]);
    pbaspect([1 1 1])
    hold on, grid on, box on
     xticks(0:0.2:1);
    yticks(20:10:70);
%     ylim([75 175]);
    plot(var_x,avg_cost_aoci_wi_correlate,'r-',...
         var_x,avg_cost_aoi_wi_correlate,'b-.',...
         var_x,avg_cost_maf_zw_correlate,'k--',...
         var_x,avg_cost_macf_zw_correlate,'g:',...
         'linewidth',2)
    legend('AoCI','AoI','MAF-ZW','MACF-ZW','Location','Best','FontSize', 18)
    xlabel('$p_c$','Interpreter', 'Latex','FontSize',18)
    ylabel('Average Cost','Interpreter', 'Latex','FontSize',18)
    set(gca,'FontSize',18)




end
