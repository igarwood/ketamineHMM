% Compare beta distributions between two models

% % If loading an estimated model:
% file1 = [];
% file2 = [];
% model1 = load(['./model_output',file1]);
% model2 = load(['./model_output',file2]);

% If loading from models published in Garwood, Chakravarty, et al, 2020
% Choose which models to load:
human = 0;
subject1 = 1;
subject2 = 2;
sessions1 = 1:4;
sessions2 = 1:5;
model1 = loadmodel_GC(human, subject1, sessions1);
model2 = loadmodel_GC(human, subject2, sessions2);

% Plot results?
suppressfigs = 0;

% Extract beta parameters:
beta_a1 = model1.beta_a;
beta_b1 = model1.beta_b;
beta_a2 = model2.beta_a;
beta_b2 = model2.beta_b;

[prob_diff, ks_dist] = beta_compare(beta_a1,beta_b1,beta_a2,beta_b2);

if ~suppressfigs
    plotBeta_compare(prob_diff);
end