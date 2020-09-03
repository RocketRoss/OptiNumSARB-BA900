classdef BA900Sheet
    %BA900Sheet
    
    properties
        filepath
        header
        subtables
        itemDescriptions
    end
    
    methods
        function obj = BA900Sheet(filepath)
            %Construct an instance of this class from a given 
            %file path to a SARB BA900 datasheet.
            %(https://www.resbank.co.za/Research/Statistics/Pages/Banks-BA900-Economic-Returns.aspx)
            
            obj.filepath = filepath;
            
            tabRange = [1 inf];
            tabReadOpts = delimitedTextImportOptions('DataLines', tabRange);
            entireSheet =  readtable(filepath, tabReadOpts);

            A = table2array(entireSheet(:, 1));
            tableSplits = find(contains(A(:,1), "Table "));
            tableSplits = [tableSplits; size(entireSheet,1)];
            
            headerRange = [1 tableSplits(1)-1];
            headerReadOpts = delimitedTextImportOptions('DataLines', headerRange);
            header = readtable(filepath, headerReadOpts);
            header.Properties.RowNames = table2cell(header(1:end, 1));
            obj.header = header(1:end, 2);
            
            for i = 1:size(tableSplits,1)-1
                
                tableHeader = table2cell(entireSheet(tableSplits(i)+1,:));
                emptyIndices = cellfun(@isempty,tableHeader);
                subtableWidth = find(emptyIndices);
                subtableWidth = subtableWidth(1)-1;
                
                itemNumbers = table2cell(entireSheet(tableSplits(i)+2:tableSplits(i+1)-1,2));
                itemNumbers = strrep(itemNumbers, '"', '');
                
                if i == 1
                   obj.itemDescriptions = entireSheet(tableSplits(i)+2:tableSplits(i+1)-1,1:1);
                   allItemNumbers = itemNumbers;
                else
                   obj.itemDescriptions = [obj.itemDescriptions; entireSheet(tableSplits(i)+2:tableSplits(i+1)-1,1:1)];
                   allItemNumbers = [allItemNumbers; itemNumbers];
                end
                
                obj.subtables(i).name = A(tableSplits(i),1);
                obj.subtables(i).table = entireSheet(tableSplits(i)+2:tableSplits(i+1)-1,3:subtableWidth);
                obj.subtables(i).table = array2table(cellfun(@str2double, table2cell(obj.subtables(i).table)));
                obj.subtables(i).table.Properties.VariableNames = strrep(tableHeader(3:subtableWidth), '"', '');
                obj.subtables(i).table.Properties.RowNames = itemNumbers;
            end
            obj.itemDescriptions = array2table(cellfun(@string, table2cell(obj.itemDescriptions)));
            obj.itemDescriptions.Properties.VariableNames = {'Description'};
            obj.itemDescriptions.Properties.RowNames = allItemNumbers;
        end
        
        function r = getSubtableWithItemNumber(obj, itemNumber)
            itemNumStr = string(itemNumber);
            for i = 1:size(obj.subtables, 2)
                if find(strcmp(obj.subtables(i).table.Properties.RowNames, itemNumStr))
                    r = obj.subtables(i).table;
                    return
                end
            end
        end
        
        function r = getItemsDescribedBy(obj, descr)
            matchFun = @(x) contains(x, descr);
            r = obj.itemDescriptions(arrayfun(matchFun, table2array(obj.itemDescriptions)), 1); 
        end
    end
end

