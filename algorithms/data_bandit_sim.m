function [data] = data_bandit_sim(inputParameters)
% (algo, nIter, num_sims, Arms, model)

num_sims = inputParameters.nSim;
nIter = inputParameters.nIter;
m = inputParameters.model;
algo  = inputParameters.algo;
x1 = inputParameters.x1;
x2 = inputParameters.x2;

[mABS, mCRE] = meshgrid(x1, x2);
Arms = [mABS(:) mCRE(:)];

num_arms = numel(mABS);

meanReward_per_sim_per_round = zeros(num_sims,nIter);
obtainedRewardIter = zeros(num_sims,nIter);
selectedArmIter = zeros(num_sims,nIter);
regret_iter = zeros(num_sims,nIter);

for s = 1:num_sims
%     fprintf('Simulation %i\n', s);
    
    counts = zeros(1,num_arms);
    algo.initialize(num_arms);
    lastMeanReward = 0;
    
    if isfield(inputParameters, 'FCD')
        m.resetScenario();
    end    
    
    for it = 1:nIter
        chosen_arm = algo.select_arm();
        reward = m.getValues(Arms(chosen_arm,:));
        obtainedRewardIter(s,it) = reward;
        selectedArmIter(s,it) = chosen_arm;
        counts(chosen_arm) = counts(chosen_arm) + 1;

        meanReward_per_sim_per_round(s,it) = (it - 1) / it * lastMeanReward + (1 / it) * reward;       
        lastMeanReward = meanReward_per_sim_per_round(s,it);
        algo.update(chosen_arm, reward);
        
        optPoint = m.getOptPoint();
        regret_iter(s,it) = m.getValues(optPoint,0) - m.getValues(Arms(chosen_arm,:),0);
    end
end

regret = cumsum(regret_iter,2);

meanReward_per_round = mean(meanReward_per_sim_per_round,1);   

data.num_arms = num_arms;
data.counts = counts;
data.meanReward_per_sim_per_round = meanReward_per_sim_per_round;
data.meanReward_per_round = meanReward_per_round; 
data.Arms = Arms;
data.obtainedRewardIter = obtainedRewardIter;
data.selectedArmIter = selectedArmIter;
data.regret = regret;
data.meanRegret = mean(regret, 1);

end
