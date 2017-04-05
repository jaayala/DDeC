function [data] = GradientAscent(inputParameters)

    nSim = inputParameters.nSim;
    totalStages = inputParameters.totalStages;

    m = inputParameters.model;
    algo = inputParameters.algo;    

    initPoint = inputParameters.initPoint;
    minPoint = inputParameters.minPoint;
    maxPoint = inputParameters.maxPoint;
    
    d = length(initPoint);

    evolution = cell(1, nSim);
    samplesPerIter = cell(1, nSim);

    nPointsPerIter = algo.nPointsPerIter();
    
    GA_iterations = ceil(totalStages / nPointsPerIter);
    regret_iter =  zeros(nSim, GA_iterations * nPointsPerIter);

    minPoint_m = repmat(minPoint,nPointsPerIter,1);
    maxPoint_m = repmat(maxPoint,nPointsPerIter,1);


    for s = 1:nSim

        evolution{s} = zeros(d,totalStages+1);
        samplesPerIter{s} = zeros(nPointsPerIter,totalStages);

        evolution{s}(:,1) = initPoint';
%         fprintf('Simulation %i\n',s)
        CurrentPoint = initPoint;
        regretIndex = 1;
        
        if isfield(inputParameters, 'FCD')
            m.resetScenario();
        end

        for it = 1:GA_iterations

            [points, var]= algo.explorationPoints(CurrentPoint);

            if sum(sum(points < minPoint_m | points > maxPoint_m)) > 0
                points = max(points, minPoint_m);
                points = min(points, maxPoint_m);            
            end

            val = m.getValues(points);
            grad = algo.computeGradient(val, var);
            alpha = algo.getAlpha(it);

            CurrentPoint = CurrentPoint + alpha * grad;

            if sum(CurrentPoint < minPoint | CurrentPoint > maxPoint) > 0        
                CurrentPoint = max(CurrentPoint, minPoint);
                CurrentPoint = min(CurrentPoint, maxPoint);
            end

            evolution{s}(:,it+1) = CurrentPoint';
            samplesPerIter{s}(:,it) = val;
            
            optPoint = m.getOptPoint();
            regret_iter(s,regretIndex:(regretIndex+nPointsPerIter-1)) = repmat(m.getValues(optPoint,0), 1, nPointsPerIter) - m.getValues(points, 0)';            
            regretIndex = regretIndex + nPointsPerIter;

        end    
    end
    regret = cumsum(regret_iter,2);

    data.nSim = nSim;
    data.samplesPerIter = samplesPerIter;
    data.evolution = evolution;
    data.regret = regret;
    data.meanRegret = mean(regret, 1);

end