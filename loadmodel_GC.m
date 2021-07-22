function model = loadmodel_GC(human, subjects, sessions,pre_anesthesia)
% Load model from Garwood, Chakravarty et al, 2020
%
% Inputs: human = 1 (yes) or 0 (no, NHP)
%         subjects: if human: 1-9, if NHP: 1-2
%         sessions: if human: 1, if NHP 1: 1-4, if NHP 2: 1-5
%         pre_anesthesia: model with or without pre_anesthesia data
%         included (only applicable for NHP 1, session 1)
%         If more than one subject or session is given, the multisession
%         model will be returned
% Output: model, an object containing ('A','pi','beta_a','beta_b','path',
%                                       'dt')
%
%

% Determine which files to load:
if human
    file = 'human_';
    file2 = file;
    multisession = length(subjects) > 1;
    if multisession 
        if ~isequal(subjects,1:9)
            error('Human multi-subject model only available for subjects 1-9');
        end
        file = [file,'MS_'];
    else 
        error(['Model for human subject ', num2str(subjects), ' not available']);
    end
    sessions = subjects;
else
    file = 'NHP_';
    if length(subjects) > 1
        error('Multi-subject model for NHPs is not available');
    end
    multisession = length(sessions) > 2;
    if subjects == 1
        file = [file, 'MJ_'];
        file2 = file;
        if multisession 
            if ~isequal(sessions,1:4)
                error('NHP MJ multi-session model only available for sessions 1-4');
            end
            file = [file,'MS_'];
        elseif sessions > 1
            error(['Model for NHP MJ session ', num2str(sessions), ' not available']);
        else
            file = [file, num2str(sessions), '_SS_'];
            if pre_anesthesia == 0
                file = [file, num2str(sessions), '_SS_preA0'];
            end
        end
    else
        file = [file, 'LM_'];
        file2 = file;
        if multisession 
            if ~isequal(sessions,1:5)
                error('NHP LM multi-session model only available for sessions 1-5');
            end
            file = [file,'MS_'];
        else
            error(['Model for NHP LM session ', num2str(sessions), ' not available']);
        end
    end
end

model.beta_a =  csvread([file,'beta_a.csv']);
model.beta_b =  csvread([file,'beta_b.csv']);
model.A =  csvread([file,'A.csv']);
time = csvread([file2,'1_time.csv']);
model.dt = time(2)-time(1);

if multisession
    model.pi = [];
    model.path = [];
    for l = 1:length(sessions)
        model.pi =  [model.pi; ...
            csvread([file2,num2str(sessions(l)),'_MS_pi.csv'])];
        model.path =  [model.path, ...
            csvread([file2,num2str(sessions(l)),'_MS_path.csv'])];
    end
else
    model.pi = csvread([file,'pi.csv']);
    model.path = csvread([file,'path.csv']);
end
   

end
