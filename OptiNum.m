fileNameFilter = ["34118.csv", "25046.csv"];

ba900files = dir('**/*.csv');
ba900FileList = {ba900files.folder; ba900files.name};

filteredFileListIndices = find(contains(ba900FileList(2,:), fileNameFilter));

for i = 1:size(filteredFileListIndices,2)
    filePath = string(join(ba900FileList(:,filteredFileListIndices(i)), '\'))
    sheet = BA900Sheet(filePath);

    % totals = sheet.subtables(1).table(:, '"TOTAL(7)"')
    % depositTotal = totals('"1"', 1)
    depositTotal = cellfun(@str2double, sheet.subtables(1).table{'"1"', '"TOTAL(7)"'})

    subtable = getSubtableWithItemNumber(sheet, 110);
    loanTotal = cellfun(@str2double, subtable{'"110"', '"TOTAL ASSETS (Col 1 plus col 3)(5)"'})
end
