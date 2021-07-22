function [path_accuracy, KS_dist, A_error, pi_error] = sim_accuracy(...
    file, K, N_sim)


path_accuracy = zeros(length(K),N_sim);
KS_dist = zeros(length(K),N_sim);
A_error = zeros(length(K),N_sim);
pi_error = zeros(length(K),N_sim);

L = length(K);
parfor n = 1:N_sim
    for j = 1:L
        k = K(j);
%         sim = load([file,num2str(k),'_sim',num2str(n),'.mat']);
%         model = load([file,num2str(k),'_sim',num2str(n),'_est.mat']);
        sim = load([file,num2str(k),'_sim',num2str(n),'_est.mat']);
        
        sim_path = sim.sim_path;
        sim_beta_a = sim.sim_beta_a;
        sim_beta_b = sim.sim_beta_b;
        sim_A = sim.sim_A;
        sim_pi = sim.sim_pi;
        
        est_path = sim.est_path;
        est_beta_a = sim.est_beta_a;
        est_beta_b = sim.est_beta_b;
        est_A = sim.est_A;
        est_pi = sim.est_pi;

        [ks_dist] = beta_compare_ks(sim_beta_a, sim_beta_b,...
            est_beta_a, est_beta_b);
        
        path_accuracy(j,n) = sum(est_path'==sim_path)/length(sim_path);
        KS_dist(j,n) = mean(mean(ks_dist));
        A_error(j,n) = sum(sum(abs(sim_A-est_A)))/(k*2); 
        pi_error(j,n) = sum(abs(sim_pi-est_pi))/2;
  
    end
end


pathDiff_sort = sort(path_accuracy,2);
Pdiff_sort = sort(A_error,2);
Pidiff_sort = sort(pi_error,2);
betadiff_sort = sort(KS_dist,2);