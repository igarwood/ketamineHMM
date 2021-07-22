% Compare beta distributions within a single model

% % If loading an estimated model:
% file = [];
% model = load(['./model_output',file]);

% If loading from models published in Garwood, Chakravarty, et al, 2020
% Choose which model to load:
human = 0;
subjects = 1;
sessions = 1:4;
model = loadmodel_GC(human, subjects, sessions,1);

% Plot results?
suppressfigs = 0;

% Extract beta parameters:
beta_a = model.beta_a;
beta_b = model.beta_b;

[prob_diff, ks_dist] = beta_compare(beta_a,beta_b);

if ~suppressfigs
    plotBeta_compare(prob_diff);
end