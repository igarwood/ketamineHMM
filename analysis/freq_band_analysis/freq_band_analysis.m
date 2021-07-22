% %freq_bands = [0:10:40;10:10:50]';
% %freq_bands = [0:2:49;1:2:50]';
% %freq_bands = [0:1:50;0:1:50]';
% %freq_bands = [0:3:48;2:3:50]';
% freq_bands = [0:4:47;3:4:50]';
% 
freqs0 = {[0:1:50;0:1:50]'};
for i = 2:26
    freqs0 = {freqs0{1:(i-1)},[0:i:(50-i+1);(i-1):i:50]'};
end
freqs0{end+1} = [0,50];
freqs = {freqs0{[1:8,10,12,17,25,27]}};
freqs = [freqs,{[[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]]}];


N_H = length(freqs);

k_theta = [];
AIC = [];
path_mat = [];
ax_H = [];
A_freqs = cell(1,N_H);
pi_freqs = cell(1,N_H);
beta_freqs = cell(2,N_H);
N_H = length(freqs);

for f = 1:N_H
    freq_bands = freqs{f};
    
    ketamineAnalysis;
%     figure(numfigs+(f-1)*3+1)
%     ax_H = [ax_H,gca];
%     figure(numfigs+(f-1)*3+2)
%     ax_H = [ax_H,gca];
    A_freqs{1,f} = A;
    pi_freqs{1,f} = pi;
    beta_freqs{1,f} = beta_a;
    beta_freqs{2,f} = beta_b;
    
    k_theta = [k_theta, (K-1) + K*(K-1) + 2*K*size(freq_bands,1)];
    AIC = [AIC, (2*k_theta(end) - 2*LL)];
    path_mat = [path_mat;path];
end

%linkaxes(ax_H,'x');
path_sim = zeros(N_H,N_H);
num_H = zeros(1,N_H);
for j = 1:N_H
    for k = 1:N_H
        path_sim(j,k) = sum(path_mat(j,:)==path_mat(k,:))/sum(N);
    end
    num_H(j) = size(freqs{j},1);
end

figure
plot(k_theta(1:end-1),AIC(1:end-1),'.-','Markersize',10)
hold on
plot(k_theta(end),AIC(end),'x','Markersize',10)
xlabel('Number of parameters')
ylabel('AIC')
box off
set(gca,'fontsize',18)

mdl = fitlm(k_theta,AIC);
R2 = mdl.Rsquared.Ordinary;

figure
imagesc(path_sim,[0,1])
xticks(1:N_H)
yticks(1:N_H)
xticklabels(num_H);
yticklabels(num_H);
c = colorbar;
xlabel('Number of frequency bands')
ylabel('Number of frequency bands')
ylabel(c,'Path similarity')
set(gca,'fontsize',18)


save('freq_analysis_MJ_ms_PFC1-64','path_mat','path_sim','freqs','AIC',...
    'k_theta','A_freqs','pi_freqs','beta_freqs');