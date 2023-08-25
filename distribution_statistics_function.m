function [results_distribution, normalized_results, anova_results, anova_rejected, filtered_ttest, filtered_correlation, results_names] = distribution_statistics_function(directory,names,channel_selection,time_limit,b_length)

counter_loop = 0;
results_distribution = struct;

% Pre-allocate
results_distribution.RDS.duration.ripple_2 = cell(size(names,2),1);
results_distribution.RDS.duration.ripple_3 = cell(size(names,2),1);
results_distribution.RDS.RMS.ripple_2 = cell(size(names,2),1);
results_distribution.RDS.RMS.ripple_3 = cell(size(names,2),1);
results_distribution.RDS.PEAK.ripple_2 = cell(size(names,2),1);
results_distribution.RDS.PEAK.ripple_3 = cell(size(names,2),1);
results_distribution.RDS.FREQ.ripple_2 = cell(size(names,2),1);
results_distribution.RDS.FREQ.ripple_3 = cell(size(names,2),1);

% Time limit to consider in minutes
time_limit = time_limit * 60 / b_length;

for ii = 1:size(names,1)
    for jj = 1:size(names,2)

        %% Ripple features by day - ignoring animal identities

        % RIPPLE
        filename = fullfile(directory,'ripple',char(names{ii,jj}));
        load(filename,'ripple_result_block_2','ripple_result_block_3','duration','RMS','PEAK','FREQ')
        time_select_2 = find(ripple_result_block_2(:,1) <= time_limit);
        time_select_3 = find(ripple_result_block_3(:,1) <= time_limit);

        % Get the results
        results_distribution.RDS.duration.ripple_2{jj,1} = [results_distribution.RDS.duration.ripple_2{jj,1}; duration.ripple_2(time_select_2)];
        results_distribution.RDS.duration.ripple_3{jj,1} = [results_distribution.RDS.duration.ripple_3{jj,1}; duration.ripple_3(time_select_3)];
        results_distribution.RDS.RMS.ripple_2{jj,1} = [results_distribution.RDS.RMS.ripple_2{jj,1}; RMS.ripple_2(time_select_2)'];
        results_distribution.RDS.RMS.ripple_3{jj,1} = [results_distribution.RDS.RMS.ripple_3{jj,1}; RMS.ripple_3(time_select_3)'];
        results_distribution.RDS.PEAK.ripple_2{jj,1} = [results_distribution.RDS.PEAK.ripple_2{jj,1}; PEAK.ripple_2(time_select_2)];
        results_distribution.RDS.PEAK.ripple_3{jj,1} = [results_distribution.RDS.PEAK.ripple_3{jj,1}; PEAK.ripple_3(time_select_3)];
        results_distribution.RDS.FREQ.ripple_2{jj,1} = [results_distribution.RDS.FREQ.ripple_2{jj,1}; FREQ.ripple_2(time_select_2)'];
        results_distribution.RDS.FREQ.ripple_3{jj,1} = [results_distribution.RDS.FREQ.ripple_3{jj,1}; FREQ.ripple_3(time_select_3)'];

    end
end
%% Organize results to anova

% Get every single results field
results_names = fieldnamesr(results_distribution,'prefix');
% Loop for each result
for ii = 1:length(results_names)
    for jj = 1:size(names,2)
        % Get a vector with group indexing for anova
        command1 = sprintf('%s{jj,2} = jj*ones(length(%s{jj,1}),1);',results_names{ii},results_names{ii});
        eval(command1)
        command2 = sprintf('organized_%s = vertcat(%s{:,1});',results_names{ii},results_names{ii});
        eval(command2)
        command3 = sprintf('group_%s = vertcat(%s{:,2});',results_names{ii},results_names{ii});
        eval(command3)
    end
end

%% Run anova
% Get every single results field
results_names = fieldnamesr(organized_results_distribution,'prefix');
group_values = fieldnamesr(group_results_distribution,'prefix');
% Create a table for anova results
anova_results = cell(length(results_names),1);

for ii = 1:length(results_names)

    % execute command
    eval(sprintf("[anova_results{ii,1},anova_results{ii,2},anova_results{ii,3}] = anova1(%s,%s,'off');",results_names{ii},group_values{ii}))

end

% Get the results names
anova_results = [anova_results results_names];

% Get the comparisons which wielded a p-value < 0.05
rejected = find([anova_results{:,1}] < 0.05);
anova_rejected = {results_names{rejected}; anova_results{rejected,1}; anova_results{rejected,2}; anova_results{rejected,3}}';

end