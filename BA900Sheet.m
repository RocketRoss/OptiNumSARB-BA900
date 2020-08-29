classdef BA900Sheet
    %BA900Sheet
    
    properties
        filepath
        headingTable
        sheetTable
    end
    
    methods
        function obj = BA900Sheet(filepath)
            %Construct an instance of this class from a given 
            %file path to a SARB BA900 datasheet.
            %(https://www.resbank.co.za/Research/Statistics/Pages/Banks-BA900-Economic-Returns.aspx)
            
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

