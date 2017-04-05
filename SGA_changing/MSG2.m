codeFolder = '../algorithms/';
saveFolder = './results/';

LTE_model_files = {'model_l=0.15_nP=2_Pp=0.66.mat', 'model_l=0.15_nP=4_Pp=0.66.mat', 'model_l=0.15_nP=12_Pp=0.66.mat' };

MSG2_data.LTE_model_files = LTE_model_files;

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
alphaC = 108.2210;
algo = multiSampleGradient_2;
algo.initilize(d, delta, alphaF, alphaC)
inputParameters.algo = algo;

inputParameters.initPoint = initPoint;
inputParameters.minPoint = minPoint;
inputParameters.maxPoint = maxPoint;

fprintf('Executing MSG2...\n')


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
MSG2_data.LTE = data.meanRegret;


save([saveFolder 'MSG2_data'], 'MSG2_data')

rmpath(codeFolder)