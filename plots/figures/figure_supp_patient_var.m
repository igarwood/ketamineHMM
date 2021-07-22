human = 1;
file = 'human_';

multisession = 1;
subject_numbers = 1:9;
session_numbers = 1;
pre_anesthesia = 1;
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];
H = size(freq_bands,1);
K = 6;
L = length(subject_numbers);

mean_Y = zeros(H,L,K);
sums = zeros(L,K);

[start_t,end_t,anes_start] = sessionTimePoints(...
        session_numbers,subject_numbers,pre_anesthesia,human);
start_t = start_t - anes_start;
end_t = end_t - anes_start;
sessions = subject_numbers;
[spectrogram, time, spec_freq,N] = ...
    load_data(file,sessions,start_t, end_t);
model = loadmodel_GC(human, subject_numbers, session_numbers,pre_anesthesia);
path = model.path;
beta_a = model.beta_a;
beta_b = model.beta_b;

for l = 1:L
    ind1 = sum(N(1:l-1)) + 1;
    ind2 = sum(N(1:l));   
    Y_subject = scale_power(spectrogram(ind1:ind2,:),spec_freq, freq_bands);
    path_subject = path(ind1:ind2);
    for k = 1:K
        mean_Y(:,l,k) = mean(Y_subject(path_subject==k,:));
        sums(l,k) = sum(path_subject==k);
    end
    
end  

%%
Nsamp = 200;%min(min(sums));%200;
N_means = 10000;
means = zeros(N_means,H,K);
samp = zeros(1,Nsamp);
for h = 1:H
    for k = 1:K
        for n = 1:N_means
            samp = betarnd(beta_a(k,h),beta_b(k,h),Nsamp,1);
            means(n,h,k) = mean(samp);
        end
    end
end
%%

beta_means = zeros(h,k);
beta_q1 = zeros(h,k);
beta_q3 = zeros(h,k);
for h = 1:H
    for k = 1:K
        beta_means = means(:,h,k);
        beta_q1(h,k) = quantile(means(:,h,k),0.025);
        beta_q3(h,k) = quantile(means(:,h,k),0.975);
    end
end

defaults = [
        0.4940    0.1840    0.5560;...
        0.0000    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250;...
        0.4660    0.6740    0.1880;...
        0.3010    0.7450    0.9330;...
        0.6350    0.0780    0.1840];

for k = 1:K
    figure
    y_ind = 1:7;
    x =[beta_q1(:,k)', fliplr(beta_q3(:,k)')];
    y =[y_ind, fliplr(y_ind)];
    
    %plot(spectrum,spec_freq,'Color',defaults(k,:));
    %semilogy(sfreqs,(spectrum),'Color',defaults(i,:));
    %hold on
    fill(x,y,defaults(k,:),'FaceAlpha',0.3,'edgecolor','none');
    hold on
    for l = 1:L
        plot(mean_Y(:,l,k),[1:7],'.-','color',defaults(k,:))
        xlim([0,1])
        ylim([1,7])
    end
    plot([0.5,0.5],[1,7],'--','color',[0.5,0.5,0.5])
    yticklabels({'0-1 Hz','1-4 Hz','4-8 Hz', '8-12 Hz','12-25 Hz',...
        '25-35 Hz','35-50 Hz'})
    xlabel('Y')
end

% %% Color plot figure
% defaults = [
%         0.4940    0.1840    0.5560;...
%         0.0000    0.4470    0.7410;...
%         0.8500    0.3250    0.0980;...
%         0.9290    0.6940    0.1250;...
%         0.4660    0.6740    0.1880;...
%         0.3010    0.7450    0.9330;...
%         0.6350    0.0780    0.1840];
% % for i = 1:7
% %     for j = 1:3
% %         defaults(i,j) = max(defaults(i,j)-0.05,0);
% %     end
% % end
% defaults = defaults-defaults*0.1;
% defaults = reshape(defaults,7,1,3);
% defaults_minus = 1-defaults;
% 
% colors = zeros(K*L,H,3);
% colors_minus = zeros(K*L,H,3);
% for k = 1:K
%     colors((k-1)*L+1:k*L,:,:) = repmat(defaults(k,:,:),L,H,1);
%     colors_minus((k-1)*L+1:k*L,:,:) = repmat(defaults_minus(k,:,:),L,H,1);
% end
% 
% 
% for k = 1:K
%     for l = 1:L
%         for h = 1:H
%             mean_Y_hkl = mean_Y(h,l,k);
%             colors((k-1)*L+l,h,:) = colors((k-1)*L+l,h,:)+...
%                 (1-mean_Y_hkl)*colors_minus((k-1)*L+l,h,:);
%         end
%     end
% end
% 
% figure
% image(colors)

%%
% 
% mean_Y = zeros(H,L,K);
% Y = zeros(sum(N),H);
% scale_k = zeros(L,H);
% sums = zeros(L,K);
% for l = 1:L
%     ind1 = sum(N(1:l-1)) + 1;
%     ind2 = sum(N(1:l)); 
%     [Y(ind1:ind2,:)] = ...
%         band_power(spectrogram(ind1:ind2,:),spec_freq, freq_bands);
%     Y_subject = Y(ind1:ind2,:);
%     path_subject = path(ind1:ind2);
%     for k = 1:K
%         mean_Y(:,l,k) = mean(Y_subject(path_subject==k,:));
%         sums(l,k) = sum(path_subject==k);
%     end
%     
% end  


%%
% 
% 
% defaults = [
%         0.4940    0.1840    0.5560;...
%         0.0000    0.4470    0.7410;...
%         0.8500    0.3250    0.0980;...
%         0.9290    0.6940    0.1250;...
%         0.4660    0.6740    0.1880;...
%         0.3010    0.7450    0.9330;...
%         0.6350    0.0780    0.1840];
% 
% for k = 1:K
%     figure
%     for l = 1:L
%         plot(mean_Y(:,l,k),[1:7],'.-','color',defaults(k,:))
%         hold on
%         xlim([-30,30])
%         ylim([1,7])
%     end
%     %plot([0.5,0.5],[1,7],'--','color',[0.5,0.5,0.5])
%     yticklabels({'0-1 Hz','2-4 Hz','5-8 Hz', '9-12 Hz','13-25 Hz',...
%         '26-35 Hz','36-50 Hz'})
%     xlabel('power (dB)')
% end
% 
% 
% 
