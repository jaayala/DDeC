codeFolder = '../algorithms/';
saveFolder = './results/';

LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };
convex_model_std = [1.5 7.5 20];

softmax_data.LTE_model_files = LTE_model_files;
softmax_data.convex_model_std = convex_model_std;

load('../defaultParameters')

inputParameters.nSim = defaultParameters.nSim;
inputParameters.nIter = defaultParameters.totalStages;

addpath(codeFolder)

fprintf('Executing softmax...\n')

tao = .005;
inputParameters.algo = softmax_algo(tao);    

% LTE evaluation
load('arms_values')
inputParameters.x1 = vABS;
inputParameters.x2 = vCRE;

for i = 1:length(LTE_model_files)
    fprintf('LTE scenario %i: %s\n', i, LTE_model_files{i})
        
    load(LTE_model_files{i})
    m = modelLTE;
    m.initialize(model, defaultParameters.LTE.minPoint, defaultParameters.LTE.maxPoint)
    inputParameters.model = m;
    data = data_bandit_sim(inputParameters);
    softmax_data.LTE.(['sc' num2str(i)]) = data.meanRegret;
end

save([saveFolder 'softmax_data'], 'softmax_data')
