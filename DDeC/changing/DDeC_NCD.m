LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };
maxSetIterations = [34 31 29];

proposal_data.LTE_model_files = LTE_model_files;

load('../../defaultParameters')

inputParameters.nSim = defaultParameters.nSim;
inputParameters.totalStages = defaultParameters.totalStages;

inputParameters.initPointCoor = defaultParameters.LTE.initPoint;

inputParameters.nu = 5;
inputParameters.resetValue = 5;

codeFolder = '../../algorithms/';
resultFolder = './results/';
addpath(codeFolder)

fprintf('Executing DDeC...\n')

% LTE evaluation
load('arms_values')
inputParameters.x1 = vABS;
inputParameters.x2 = vCRE;

alpha = -.5;
algo = TSN_sleeping(alpha);
inputParameters.algo = algo;

load(LTE_model_files{1})
model1 = model;
load(LTE_model_files{2})
model2 = model;
itChange = defaultParameters.stageChangeScenario;

m = modelLTE2scenario;
m.initialize(model1, model2, itChange, defaultParameters.LTE.minPoint, defaultParameters.LTE.maxPoint)
inputParameters.m = m;

inputParameters.maxSetIterationsVector = [ones(1,itChange-1)*maxSetIterations(1) ones(1,inputParameters.totalStages - itChange +1)*maxSetIterations(2) ];

DDeC_NCD_data = DDeC_NCD_algo(inputParameters);


save([resultFolder 'DDeC_NCD_data'], 'DDeC_NCD_data')
rmpath(codeFolder)
