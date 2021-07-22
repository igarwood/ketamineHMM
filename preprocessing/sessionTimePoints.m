function [start_t,end_t,anes_start] = ...
    sessionTimePoints(sessions,subjects,pre_anesthesia,human)

% All time points in seconds

start_t = zeros(length(subjects),length(sessions));
end_t = zeros(length(subjects),length(sessions));
anes_start = zeros(length(subjects),length(sessions));

for j = 1:length(subjects)
    for k = 1:length(sessions)
        if ~human
            if subjects(j) == 1
                if sessions(k) == 1
                    anes_start(j,k) = 300;
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                end_t(j,k) = 1530;
                elseif sessions(k) == 2
                    anes_start(j,k) = 300;
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1530;
                elseif sessions(k) == 3
                    anes_start(j,k) = 32;
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+120;
                    end
                    end_t(j,k) = 1202;
                else
                    anes_start(j,k) = 177;
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1407;
                end
            else
                if sessions(k) == 1
                    anes_start(j,k) = 300; 
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1500;
                elseif sessions(k) == 2
                    anes_start(j,k) = 300; 
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1500;
                elseif sessions(k) == 3
                    anes_start(j,k) = 300; 
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1500;
                elseif sessions(k) == 4
                    anes_start(j,k) = 300; 
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1500;
                else
                    anes_start(j,k) = 300; 
                    if pre_anesthesia
                        start_t(j,k) = 0;
                    else
                        start_t(j,k) = anes_start(j,k)+30;
                    end
                    end_t(j,k) = 1500;
                end
            end
        else
            if subjects(j) == 1 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 540;
            elseif subjects(j) == 2 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 720;
            elseif subjects(j) == 3 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 960;
            elseif subjects(j) == 4 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 720;
            elseif subjects(j) == 5 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 540;
            elseif subjects(j) == 6 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 840;
            elseif subjects(j) == 7 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 720;
            elseif subjects(j) == 8 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 720;
            else 
                anes_start(j,k) = 120; 
                start_t(j,k) = 0;
                end_t(j,k) = 600;
            end
        end
    end
end

end