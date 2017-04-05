clear, clc, close all

defaultParameters.nSim = 5;
defaultParameters.totalStages = 5000;

defaultParameters.LTE.minPoint = [0 0];
defaultParameters.LTE.maxPoint = [7 20];
defaultParameters.LTE.initPoint = [1.5 1.5];

defaultParameters.functions.desc_log = @(x)1/log(x+1);
defaultParameters.functions.desc_sqrt = @(x)1/sqrt(x);
defaultParameters.functions.constant = @(x)1;

defaultParameters.stageChangeScenario = 2500;

save('defaultParameters', 'defaultParameters')

if ~license('test', 'statistics_toolbox')
    error('Statistic toolbox is not installed in your Matlab version.')
end

directories = {'MAB_stationary', 'SGA_stationary', 'DDeC/stationary', 'MAB_changing', 'SGA_changing', 'DDeC/changing'};

rootDir = pwd;
for i = 1:length(directories)
    cd(directories{i})
    execute
    cd(rootDir)
end

getFigures
