LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };
convex_model_std = [1.5 7.5 20];

maxSetIterations.LTE = [34 31 29];
maxSetIterations.convex = [31 40 66];


DDeC_data.LTE_model_files = LTE_model_files;
DDeC_data.convex_model_std = convex_model_std;

load('../../defaultParameters')

inputParameters.nSim = defaultParameters.nSim;
inputParameters.totalStages = defaultParameters.totalStages;

%optimal windows size
inputParameters.maxSetIterations = 31;

inputParameters.initPointCoor = [2,2];


codeFolder = '../../algorithms/';
resultFolder = './results/';
addpath(codeFolder)

fprintf('Executing DDeC...\n')

% LTE evaluation
load('arms_values')
inputParameters.x1 = vABS;
inputParameters.x2 = vCRE;


for i = 1:length(LTE_model_files)
    fprintf('LTE scenario %i: %s\n', i, LTE_model_files{i})
    alpha = -.5;
    algo = TSN_sleeping(alpha);
    inputParameters.algo = algo;
    
    load(LTE_model_files{i})
    m = modelLTE;
    m.initialize(model, defaultParameters.LTE.minPoint, defaultParameters.LTE.maxPoint)
    inputParameters.m = m;

    inputParameters.maxSetIterations = maxSetIterations.LTE(i);
    
    data = DDeC_algo(inputParameters);
    DDeC_data.LTE.(['sc' num2str(i)]) = data.meanRegret;
end


save([resultFolder 'DDeC_data'], 'DDeC_data')

rmpath(codeFolder)
