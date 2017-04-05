resultsFolder = './results/';
if exist(resultsFolder, 'dir') ~= 7
    mkdir(resultsFolder)
end

fprintf('\n\n-----DDeC stationary setting-----\n\n')

DDeC
