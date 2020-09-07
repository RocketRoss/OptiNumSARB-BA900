classdef BA900Analysis
    %BA900Analysis Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileNameFilter
        sheets
        dates
        institutions
    end
    
    methods
        function obj = BA900Analysis(fileNameFilter)
            %BA900Analysis Construct an instance of this class

            ba900Files = dir('**/*.csv');
            ba900FileList = {ba900Files.folder; ba900Files.name};

            if length(fileNameFilter) == 0
                fileNameFilter = {ba900Files.name}
            end

            filteredFileListIndices = find(contains(ba900FileList(2,:), fileNameFilter));
            obj.fileNameFilter = fileNameFilter

            for i = 1:size(filteredFileListIndices,2)
                filePath = string(join(ba900FileList(:,filteredFileListIndices(i)), '\'));
                sheets(i) = BA900Sheet(filePath);
                
                dates(i) = string(sheets(i).header{'Date', 1});
                institutions(i) = string(sheets(i).header{'Institution', 1});
            end

            obj.sheets = sheets;
            obj.dates = unique(dates);
            obj.institutions = unique(institutions);
        end
        
        function r = getCells(obj, rowId, varId)
            %getCells Returns a cell array of a particular data from all sheets
            rowIdString = string(rowId);
            for i = 1:size(obj.sheets,2)
                rowIndex = find(strcmp(obj.institutions, obj.sheets(i).header{'Institution', 1}));
                colIndex = find(strcmp(obj.dates, obj.sheets(i).header{'Date', 1}));
            
                subtable = getSubtableWithItemNumber(obj.sheets(i), rowId);

                r(rowIndex, colIndex) = subtable{rowIdString, varId};
            end
        end

        function r = cells2table(obj, cells, cellsCastFunction)
            %cells2table Wraps the cells in a table with the variable and row names of the sheets
            if nargin < 3
                cellsCastFunction = @cells2table;
            end
            r = cellsCastFunction(cells);
            r.Properties.RowNames = obj.institutions;
            r.Properties.VariableNames = obj.dates;
        end
        
        function r = getItemsDescribedBy(obj, descr)
           r = obj.sheets(1).getItemsDescribedBy(descr);
        end
        
        function r = getCellsAsTable(obj, rowId, varId)
           r = obj.cells2table(obj.getCells(rowId, varId), @array2table); 
        end
        
        function r = applyFunctionToTables(obj, tableFunc, table1, table2)
           if nargin < 4 % treat table1 as a cellArray of tables
            r = obj.cells2table(tableFunc(cellfun(@table2array, table1, "UniformOutput", false)), @array2table); 
           else   
            r = obj.cells2table(tableFunc(table2array(table1), table2array(table2)), @array2table); 
           end
        end
    end
end

