resultsFolder = './results/';
if exist(resultsFolder, 'dir') ~= 7
    mkdir(resultsFolder)
end

fprintf('\n\n-----DDeC changing setting-----\n\n')

DDeC_NCD
