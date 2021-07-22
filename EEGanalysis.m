% Script for running EEG analysis
%
% Indie Garwood 
% April 29, 2021
%
% In this example, a single human ketamine EEG session is estimated
%
% Note that the estimation algorithm runs 5 times in order to find the
% global maxima (The EM algorithm is prone to optimizing for local maxima)
%
% The output of this analysis is the HMM state path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Replace this line with code to calculate the spectrogram from your data
[spectrogram,time,spec_freq] = load_data('human_',6,0,840);

% Specify the number of states to estimate:
num_states = 5;

[path] = runHMM_simple(spectrogram,time,spec_freq,num_states);
% Note the the x axes of figure 1 and 2 are linked -- you can use the 
% MATLAB figure interface to zoom in or out 
