fileNameFilter = ["34118.csv", "25046.csv", "160571.csv", "165239.csv", "333107.csv", "TOTAL.csv"];

analysis = BA900Analysis(fileNameFilter);

depositCells = analysis.getCells(1, 'TOTAL(7)');
loanCells = analysis.getCells(110, 'TOTAL ASSETS (Col 1 plus col 3)(5)');

metrics.Deposits = analysis.cells2table(cellfun(@str2double, depositCells), @array2table);
metrics.Loans = analysis.cells2table(cellfun(@str2double, loanCells), @array2table);;
clearvars loanCells depositCells

metrics.MarketShare = analysis.cells2table(table2array(metrics.Deposits) ./ table2array(metrics.Deposits("*TOTAL*(TOTAL)", :)), @array2table);;
metrics.LoansToDeposits = analysis.cells2table(table2array(metrics.Loans) ./ table2array(metrics.Deposits), @array2table);

metrics

sortrows(metrics.MarketShare, size(metrics.MarketShare,2), 'descend')