% Save output? (Required if estimating more than one model)
save_flag = 0;

% Load simulation stats instead of recalculating
load_flag = 1;
if load_flag
    save_flag = 0; % Don't save if loading
end

% Suppress figs?
suppressfigs = 0;

% Number of simulation models to estimate:
N_sim = 100;

% Number of states to estimate:
K = 2:11;

% Info about file underlying the simulation:
% Human data: human = 1
% NHP data: human = 0
human = 1;

subject_number = 6;
session_number = 1;
pre_anesthesia = 1;

% Identify data to load
%folderpath = './data/simdata/';
folderpath = './model_output/simulations/';
if human 
    file = ['human_',num2str(subject_number)];
else
    if subject_number == 1
        file = ['NHP_MJ_',num2str(session_number)];
    else
        file = ['NHP_LM_',num2str(session_number)];
    end
end

if pre_anesthesia == 0
    file = [file,'_preA0_'];
else
    file = [file,'_'];
end

if ~load_flag
    [path_accuracy, KS_dist, A_error, pi_error] = sim_accuracy(...
        [folderpath,file,'K'], K, N_sim);
    if save_flag
        save(['./model_output/simulations/',file,'sim_accuracy_2'],...
                    'path_accuracy', 'KS_dist', 'A_error', 'pi_error');
    end
else
    load(['./model_output/simulations/',file,'sim_accuracy_2.mat']);
end

if ~suppressfigs
    figure
    boxplot(path_accuracy',K,'color','k','symbol','.')
    box off
    xlabel('Number of Simulated States')
    ylabel('Path Accuracy')

    % Panel E
    figure
    boxplot(KS_dist',K,'color','k','symbol','.')
    box off
    xlabel('Number of Simulated States')
    ylabel('Mean ks distance')

    %Panel F
    figure
    boxplot(A_error',K,'color','k','symbol','.')
    box off
    xlabel('Number of Simulated States')
    ylabel('\epsilon_{A}')

    %Panel G
    figure
    boxplot(pi_error',K,'color','k','symbol','.')
    box off
    xlabel('Number of Simulated States')
    ylabel('\epsilon_{\pi}')
end
