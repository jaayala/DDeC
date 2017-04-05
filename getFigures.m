clear, close all

load('defaultParameters')
nlte = 3;
nStages = defaultParameters.totalStages;
iter = 1:nStages;
lw = 2;
lteScenario = {'Scenario 1', 'Scenario 2', 'Scenario 3',};

% Folders
gaf = 'SGA_stationary/results/';
mabf = 'MAB_stationary/results/';
proposalf = 'DDeC/stationary/results/';

% Algorithms
gaa = {'MSG2', 'MSG3', 'OSG', 'RSM'};
maba = {'e_greedy','e_greedy_desc','e_greedy_desc_log', 'softmax', 'softmax_desc', 'thompson_sampling_normal','UCB_normal'};
gaLeg = {'MSG2', 'MSG3', 'OSG', 'RSM', 'DDLM'};
mabLeg = {'\epsilon greedy','\epsilon greedy desc','\epsilon greedy desc log','softmax', 'softmax desc','Thomp. samp. norm.','UCB normal', 'DDLM'};

AxisFontSize = 13;

% Load files
nga = length(gaa);
nmab = length(maba);

for i = 1:nga
    load([gaf gaa{i} '_data'])
end

for i = 1:nmab
    load([mabf maba{i} '_data'])
end

load([proposalf 'DDeC_data'])

for i = 1:nlte
    f = figure;
    for j = 1:nga
        eval(['plot(iter,' gaa{j} '_data.LTE.sc' num2str(i) '(iter), ''LineWidth'', ' num2str(lw) '), hold on'])
    end
    eval(['plot(iter, DDeC_data.LTE.sc' num2str(i) ',''k'' , ''LineWidth'', ' num2str(lw) '), hold on'])
    xlabel('Stages')
    ylabel('Regret')
    title(lteScenario{i})
    set(gca,'FontSize',AxisFontSize);   
    grid on;
    legend(gaLeg,'Location','northwest')
%     print(f,['LTE_GA_sc' num2str(i)], '-depsc');

    
    f = figure;
    for j = 1:nmab
        eval(['plot(iter,' maba{j} '_data.LTE.sc' num2str(i) ', ''LineWidth'', ' num2str(lw) '), hold on'])
    end
    eval(['plot(iter, DDeC_data.LTE.sc' num2str(i) ',''k'' , ''LineWidth'', ' num2str(lw) '), hold on'])
    xlabel('Stages')
    ylabel('Regret')
    title(lteScenario{i})
    set(gca,'FontSize',AxisFontSize);
    grid on;
    legend(mabLeg,'Location','best')
%     print(f,['LTE_MAB_sc' num2str(i)], '-depsc');
end



% Folders
gaf = 'SGA_changing/results/';
mabf = 'MAB_changing/results/';
proposalf = 'DDeC/changing/results/';

legStr = 'NCD evaluation';
mabAxis = 100;

for i = 1:nga
    load([gaf gaa{i} '_data'])
end

for i = 1:nmab
    load([mabf maba{i} '_data'])
end

load([proposalf 'DDeC_NCD_data'])

f = figure;
for j = 1:nga
    eval(['plot(iter,' gaa{j} '_data.LTE(iter), ''LineWidth'', ' num2str(lw) '), hold on'])
end
eval(['plot(iter, DDeC_NCD_data.meanRegret,''k'' , ''LineWidth'', ' num2str(lw) '), hold on'])
xlabel('Stages')
ylabel('Regret')
title('Changing scenario')
legend(gaLeg,'Location','northwest')
set(gca,'FontSize',AxisFontSize);
grid on;
% print(f,['LTE_GA_NCD'], '-deps');

f = figure;
for j = 1:nmab
    eval(['plot(iter,' maba{j} '_data.LTE, ''LineWidth'', ' num2str(lw) '), hold on'])
end
eval(['plot(iter, DDeC_NCD_data.meanRegret,''k'' , ''LineWidth'', ' num2str(lw) '), hold on'])
xlabel('Stages')
ylabel('Regret')
title('Changing scenario')
legend(mabLeg,'Location','northwest')
set(gca,'FontSize',AxisFontSize);
grid on;
% print(f,['LTE_MAB_NCD'], '-deps');


