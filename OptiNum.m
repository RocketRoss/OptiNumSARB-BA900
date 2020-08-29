filepath = "D:\Development\Code\Scripts\MATLAB\OptiNumDatasets\BA900-2020-01-01csv\34118.csv"

sheet = BA900Sheet(filepath)

% totals = sheet.subtables(1).table(:, '"TOTAL(7)"')
% depositTotal = totals('"1"', 1)
depositTotal = sheet.subtables(1).table{'"1"', '"TOTAL(7)"'}
subtable = getSubtableWithItemNumber(sheet, 110);
loanTotal = subtable{'"110"', '"TOTAL ASSETS (Col 1 plus col 3)(5)"'}
