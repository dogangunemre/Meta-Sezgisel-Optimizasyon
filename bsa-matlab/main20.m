%algorithms = {'abc', 'aefa', 'agde', 'aso', 'boa', 'bsa', 'cgsa', 'ckgsa', 'coa', 'cs', 'csa', 'de', 'dsa', 'efo', 'gsa', 'gwo', 'hho', 'is', 'lsa', 'mfla', 'mfo', 'ms', 'pso', 'sca', 'se', 'sfs', 'sos', 'ssa', 'tlabc', 'wde', 'woa', 'yypo'};
% algorithms = {'abc', 'abc_case1'}; % Her grup kendi algoritmasýnýn adýný buraya yazacak
algorithms = {'bsa','bsafdbpop20', 'bsafdbpopartandu20', 'bsafdbpopdinamik20','bsafdbpop40', 'bsafdbpopartandu40', 'bsafdbpopdinamik40','bsafdbpop60', 'bsafdbpopartandu60', 'bsafdbpopdinamik60'};

dimension = 30; 
run = 10; 
maxIteration = 100*dimension;
filename = 'result-';

experimentNumber = 1;  functionsNumber = 10;
solution = zeros(experimentNumber, functionsNumber, run);
solutionR = zeros(functionsNumber * experimentNumber, run);
globalMins = [100, 1100, 700, 1900, 1700, 1600, 2100, 2200, 2400, 2500];
paths;
cec20so = str2func('cec20_func_so'); 
for ii = 1 : length(algorithms)
    disp(algorithms(ii));
    algorithm = str2func(char(algorithms(ii)));
    for i = 1 : functionsNumber
        disp(i);
        for j = 1 : run
            [~, bestFitness, ~] = algorithm(cec20so, dimension, maxIteration, i);
            solution(1, i, j) = bestFitness - globalMins(i);
            for k = 1 : experimentNumber
                solutionR(k + experimentNumber * (i - 1), j) = solution(k, i, j);
            end
        end
    end
    xlswrite(strcat(filename, func2str(algorithm), '-d=', num2str(dimension), '.xlsx'), solutionR, 1);
    eD = strcat(func2str(algorithm), '-Bitti :)');
    disp(eD);
end