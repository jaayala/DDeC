function data = DDeC(inputParameters)

nSim = inputParameters.nSim;
totalStages = inputParameters.totalStages;

initPointCoor = inputParameters.initPointCoor;
maxSetIterations = inputParameters.maxSetIterations;

x1 = inputParameters.x1;
x2 = inputParameters.x2;
[mX1, mX2] = meshgrid(x1, x2);
[yDim, xDim] = size(mX1);

m = inputParameters.m;
algo = inputParameters.algo;

arms = [mX1(:) mX2(:)];

meanReward_per_round = zeros(nSim,totalStages);
num_arms = length(arms(:,1));

obtainedRewardIter = zeros(nSim,totalStages);
selectedArmIter = zeros(nSim,totalStages);
optPoint = m.getOptPoint();

counts = zeros(nSim,num_arms);
vCurrentPointCoor = cell(1, nSim);
vAvailableArms = cell(1, nSim);
vStep = zeros(nSim,totalStages);
regret_iter = zeros(nSim,totalStages);

step_ini = 2;
converFlag = 4;

for s = 1:nSim
    
%     fprintf('Simulation %i\n',s)
    CurrentPointCoor = initPointCoor;
    it = 1;    
    algo.initialize(num_arms);
    lastMeanReward = 0;    
    vCurrentPointCoor{s} = zeros(totalStages,2);
    vAvailableArms{s} = zeros(num_arms, totalStages);
    
    step = step_ini;
    converCount = 0;
    
    while it <= totalStages
    %     fprintf('\nHeuristic Iteration %i\nCurrent coord: %i,%i\nCurrent central point: %i,%i\n', ...
    %         it, CurrentPointCoor,mABS(1,CurrentPointCoor(2)), mCRE(CurrentPointCoor(1),1));

        yWindowsIndex = max(1,CurrentPointCoor(1)-step):step:min(yDim, CurrentPointCoor(1)+step);
        xWindowsIndex = max(1,CurrentPointCoor(2)-step):step:min(xDim, CurrentPointCoor(2)+step);

        mAux = zeros(size(mX1));
        mAux(yWindowsIndex,xWindowsIndex) = 1;
        availableArms = mAux(:);

        setIterations = 1;
        selectedArmIter_aux = zeros(1,maxSetIterations);
        while setIterations <= maxSetIterations && it <= totalStages

            chosen_arm = algo.select_arm(availableArms);
            reward = m.getValues(arms(chosen_arm,:));
            obtainedRewardIter(s,it) = reward;
            selectedArmIter(s,it) = chosen_arm;
            selectedArmIter_aux(setIterations) = chosen_arm;
            counts(s,chosen_arm) = counts(s,chosen_arm) + 1;

            meanReward_per_round(s,it) = (it - 1) / it * lastMeanReward + (1 / it) * reward;       
            lastMeanReward = meanReward_per_round(s,it);
            algo.update(chosen_arm, reward);        

            vCurrentPointCoor{s}(it, :) = CurrentPointCoor;
            vAvailableArms{s}(:,it) = availableArms;
            vStep(s,it) = step;
            regret_iter(s,it) = m.getValues(optPoint,0) - m.getValues(arms(chosen_arm,:),0);

            setIterations = setIterations + 1;
            it = it + 1;
        end

        f = zeros(1, num_arms);
        for i = 1:num_arms
            f(i)=sum(sum(selectedArmIter_aux == i));
        end
        [~, winnerArmI] = max(f);

        [row,~] = find(mX2 == mX2(winnerArmI), 1, 'first');
        [~,col] = find(mX1 == mX1(winnerArmI), 1, 'first');
        
        if norm(CurrentPointCoor - [row, col]) == 0 && step > 1
            converCount = converCount + 1;
        else
            converCount = 0;
        end 
        
        if converCount == converFlag
            step = 1;
        else
            CurrentPointCoor = [row, col];
        end        
        
        
    end   
end

regret = cumsum(regret_iter,2);

data.nSim = nSim;
data.Arms = arms;
data.counts = counts;
data.meanReward_per_round = mean(meanReward_per_round,1); 
data.obtainedRewardIter = obtainedRewardIter;
data.selectedArmIter = selectedArmIter;
data.vCurrentPointCoor = vCurrentPointCoor;
data.vAvailableArms = vAvailableArms;
data.x1 = x1;
data.x2 = x2;
data.regret = regret;
data.meanRegret = mean(regret, 1);

end

% save([resultFolder 'proposal_convex'], 'proposal_convex')