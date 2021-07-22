function [CI, med] = confidence_intervals(data)
% Returns median and confidence intervals from an 1xN array of data

sort_data = sort(data);
CI = [sort_data(round(length(data)*0.025)),...
    sort_data(round(length(data)*0.975))];
med = median(data);

end