classdef BA900Sheet
    %SNBDATASHEET
    
    properties
        filepath
        headingTable
        sheetTable
    end
    
    methods
        function obj = SNBDatasheet(filepath)
            %SNBDATASHEET Construct an instance of this class
            obj.filepath = filepath
            
            opts = detectImportOptions(filepath)
            opts.PreserveVariableNames = true
            
            obj.sheetTable = readtable(filepath, opts)
            obj.headingTable = readtable(filepath, delimitedTextImportOptions('DataLines',[1 opts.DataLines(1)-3]))
        end
        
        function r = getTotal(obj)
            r = obj.sheetTable(:,9)
        end
        
        function r = getDescription(obj)
           r = obj.sheetTable(:, 1) 
        end
    end
end

