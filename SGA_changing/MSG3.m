codeFolder = '../algorithms/';
saveFolder = './results/';

LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };

MSG3_data.LTE_model_files = LTE_model_files;

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


load(LTE_model_files{1})
model1 = model;
load(LTE_model_files{2})
model2 = model;
itChange = defaultParameters.stageChangeScenario;

m = modelLTE2scenario;
m.initialize(model1, model2, itChange, defaultParameters.LTE.minPoint, defaultParameters.LTE.maxPoint)
inputParameters.model = m;

inputParameters.FCD = 1;

data = GradientAscent(inputParameters);
MSG3_data.LTE = data.meanRegret;


save([saveFolder 'MSG3_data'], 'MSG3_data')

rmpath(codeFolder)