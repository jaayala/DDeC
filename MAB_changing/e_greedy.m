codeFolder = '../algorithms/';
saveFolder = './results/';

LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };


e_greedy_data.LTE_model_files = LTE_model_files;

load('../defaultParameters')

inputParameters.nSim = defaultParameters.nSim;
inputParameters.nIter = defaultParameters.totalStages;

addpath(codeFolder)

fprintf('Executing epsilon greedy...\n')

epsilon = .15;
inputParameters.algo = e_greedy_algo(epsilon);    

% LTE evaluation
load('arms_values')
inputParameters.x1 = vABS;
inputParameters.x2 = vCRE;

load(LTE_model_files{1})
model1 = model;
load(LTE_model_files{2})
model2 = model;
itChange = defaultParameters.stageChangeScenario;

m = modelLTE2scenario;
m.initialize(model1, model2, itChange, defaultParameters.LTE.minPoint, defaultParameters.LTE.maxPoint)
inputParameters.model = m;

inputParameters.FCD = 1;

data = data_bandit_sim(inputParameters);
e_greedy_data.LTE = data.meanRegret;


save([saveFolder 'e_greedy_data'], 'e_greedy_data')
