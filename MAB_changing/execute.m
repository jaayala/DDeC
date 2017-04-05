resultsFolder = './results/';
if exist(resultsFolder, 'dir') ~= 7
    mkdir(resultsFolder)
end

fprintf('\n\n-----Multi-armed bandits: changing setting-----\n\n')

e_greedy
e_greedy_desc
e_greedy_desc_log
softmax
softmax_desc
UCB_normal
thompson_sampling_normal

