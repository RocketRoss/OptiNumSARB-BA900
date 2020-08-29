classdef BA900Sheet
    %BA900Sheet
    
    properties
        filepath
        headingTable
        subtables
    end
    
    methods
        function obj = BA900Sheet(filepath)
            %Construct an instance of this class from a given 
            %file path to a SARB BA900 datasheet.
            %(https://www.resbank.co.za/Research/Statistics/Pages/Banks-BA900-Economic-Returns.aspx)
            
            obj.filepath = filepath
            
            tabRange = [1 inf];
            tabReadOpts = delimitedTextImportOptions('DataLines', tabRange);
            entireSheet =  readtable(filepath, tabReadOpts);

            A = table2array(entireSheet(:, 1));
            tableSplits = find(contains(A(:,1), "Table "));
            tableSplits = [tableSplits; inf];
            
            headerRange = [1 tableSplits(1)-1];
            headerReadOpts = delimitedTextImportOptions('DataLines', headerRange);
            obj.headingTable = readtable(filepath, headerReadOpts);

            for i = 1:size(tableSplits,1)-1
                
                tableHeader = table2cell(entireSheet(tableSplits(i)+1,:));
                emptyIndices = cellfun(@isempty,tableHeader);
                subtableWidth = find(emptyIndices);
                subtableWidth = subtableWidth(1)-1
                
                tabRange = [tableSplits(i)+3 tableSplits(i+1)];
                tabReadOpts = delimitedTextImportOptions('DataLines', tabRange);
                tabReadOpts.PreserveVariableNames = true;
                tabReadOpts.VariableNamesLine = tableSplits(i)+2;
                
                obj.subtables(i).name = A(tableSplits(i),1);
                obj.subtables(i).table = readtable(filepath, tabReadOpts);
                obj.subtables(i).table = obj.subtables(i).table(:, 1:subtableWidth);
            end
        end
        
    end
end

