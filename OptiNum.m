fileNameFilter = ["34118.csv", "25046.csv", "TOTAL.csv"];

ba900Files = dir('**/*.csv');
ba900FileList = {ba900Files.folder; ba900Files.name};

filteredFileListIndices = find(contains(ba900FileList(2,:), fileNameFilter));
clearvars fileNameFilter

for i = 1:size(filteredFileListIndices,2)
    filePath = string(join(ba900FileList(:,filteredFileListIndices(i)), '\'));
    sheets(i) = BA900Sheet(filePath);
    
    dates(i) = string(sheets(i).header{'Date', 1});
    institutions(i) = string(sheets(i).header{'Institution', 1});
end
clearvars ba900Files ba900FileList i filteredFileListIndices filePath

dates = unique(dates);
institutions = unique(institutions);

depositCells = {};
loanCells = {};
for i = 1:size(sheets,2)
    rowIndex = find(strcmp(institutions, sheets(i).header{'Institution', 1}));
    colIndex = find(strcmp(dates, sheets(i).header{'Date', 1}));

    depositCells(rowIndex, colIndex) = {cellfun(@str2double, sheets(i).subtables(1).table{'"1"', '"TOTAL(7)"'})};
    subtable = getSubtableWithItemNumber(sheets(i), 110);
    loanCells(rowIndex, colIndex) = {cellfun(@str2double, subtable{'"110"', '"TOTAL ASSETS (Col 1 plus col 3)(5)"'})};
end
clearvars i rowIndex colIndex subtable

metrics.Deposits = cell2table(depositCells);
metrics.Deposits.Properties.RowNames = institutions;
metrics.Deposits.Properties.VariableNames = dates;

metrics.Loans = cell2table(loanCells);
metrics.Loans.Properties.RowNames = institutions;
metrics.Loans.Properties.VariableNames = dates;


metrics.MarketShare = array2table(table2array(metrics.Deposits) ./ table2array(metrics.Deposits(1, :)));
metrics.MarketShare.Properties.RowNames = institutions;
metrics.MarketShare.Properties.VariableNames = dates;

clearvars loanCells depositCells% dates institutions

metrics

sortrows(metrics.MarketShare, size(metrics.MarketShare,2), 'descend')