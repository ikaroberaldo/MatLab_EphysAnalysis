%% Complete Routine

% directory = str(base directory name)
directory = 'E:\Barnes Maze - Mestrad\dados matlab\blocked_data';
% names = cell(names of each subdirectory separetelly)
names = {'B1_D1','B1_D2','B1_D3','B1_D4','B1_D5','B2_D1','B2_D2','B2_D3','B2_D4','B2_D5',...
    'B3_D1','B3_D2','B3_D3','B3_D4','B3_D5',...
    'B4_D1','B4_D2','B4_D3','B4_D4','B4_D5','B6_D1','B6_D2','B6_D3','B6_D4','B6_D5'};
% names2 = cell(matrix with each subdirectory separatelly
names2 = {'B1_D1','B1_D2','B1_D3','B1_D4','B1_D5';'B2_D1','B2_D2','B2_D3','B2_D4','B2_D5';...
    'B3_D1','B3_D2','B3_D3','B3_D4','B3_D5';...
    'B4_D1','B4_D2','B4_D3','B4_D4','B4_D5';'B6_D1','B6_D2','B6_D3','B6_D4','B6_D5'};

% disp('PSD and Bands')
get_psd_and_band_function(directory,names)
disp('Plot PSD and Bands')
plot_psds_function(directory,names2)
plot_psds_compare_days_function(directory,names2)
plot_bands_throughout_days_function(directory,names,5)
disp('Sleep parameters')
% % FALTANDO
get_sleep_parameters_function(directory,names)
% disp('Spectral coherence')
% getspectralcoherence_function(directory,names)
disp('Phase coherence')
getphasecoherence_function(directory,names)
disp('Plot Spectral and Phase coherence')
% Retirar o plot dos outros 3 dias
% Refazer os plots com base nos diferentes canais de CA1
plot_spectral_phase_coherence_function(directory,names2)
close all
disp('Ripples')
% Faltando o notchfilter
detect_ripples_block_by_block_function(directory,names)
extract_RDS_info(directory,names)
disp('Delta')
% Faltando detect_Delta_Naty_algorithm_rem
detect_delta_block_by_block_function(directory,names)
detect_delta_block_by_block_CA1_function(directory,names)
disp('Spindle')
% Faltando eegfilt2
detect_spindle_block_by_block_function(directory,names)
disp('Detect RDS coupling')
detect_RDS_block_by_block_function(directory,names,names2)    
disp('Modulation Index')
get_mi_for_each_channel_function(directory, names)
get_MI_delta_degree_amplitude(directory,names2,time_limit,10)
get_MI_delta_degree_amplitude_epoch_is_N(directory,names2,time_limit,10)

% disp('Statistics')
channel_selection = [3 3 3 2 3];
time_limit = 180;
[results, normalized_results, anova_results, anova_rejected, filtered_ttest, filtered_correlation, results_names] = statistics_function(directory,names2,channel_selection,time_limit,10);
[results_distribution, normalized_results, anova_results, anova_rejected, filtered_ttest, filtered_correlation, results_names] = distribution_statistics_function(directory,names2,channel_selection,time_limit,10);

% Create prism files for the new results
dir_to_save = 'E:\Barnes Maze - Mestrad\dados matlab\PrismResults';
create_prism_files_for_results(results_names, normalized_results, dir_to_save,5)
create_prism_files_for_results(results_names([172;173;176;177]), normalized_results, dir_to_save,4)
create_prism_files_for_results(results_names([174;175;178;179;180]), results, dir_to_save,0)

