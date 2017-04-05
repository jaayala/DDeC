codeFolder = '../algorithms/';
saveFolder = './results/';

LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };
convex_model_std = [1.5 7.5 20];

MSG3_data.LTE_model_files = LTE_model_files;
MSG3_data.convex_model_std = convex_model_std;

load('../defaultParameters')
inputParameters.nSim = defaultParameters.nSim;
inputParameters.totalStages = defaultParameters.totalStages;

addpath(codeFolder)

% LTE evaluation
minPoint = defaultParameters.LTE.minPoint;
maxPoint = defaultParameters.LTE.maxPoint;
initPoint = defaultParameters.LTE.initPoint;

d = length(minPoint);
delta = 1;
alphaF = defaultParameters.functions.desc_sqrt;
alphaC = 73.7246;
algo = multiSampleGradient_3;
algo.initilize(d, delta, alphaF, alphaC)
inputParameters.algo = algo;


inputParameters.initPoint = initPoint;
inputParameters.minPoint = minPoint;
inputParameters.maxPoint = maxPoint;

fprintf('Executing MSG3...\n')

for i = 1:length(LTE_model_files)
    fprintf('LTE scenario %i: %s\n', i, LTE_model_files{i})
    load(LTE_model_files{i})
    m = modelLTE;
    m.initialize(model, minPoint, maxPoint);
    inputParameters.model = m;    
    data = GradientAscent(inputParameters);
    MSG3_data.LTE.(['sc' num2str(i)]) = data.meanRegret;
end

save([saveFolder 'MSG3_data'], 'MSG3_data')
rmpath(codeFolder)