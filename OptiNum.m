% MATLAB code was developed to open a BA900 sheet, crop each internal table and keep 
% track of the items' descriptions.
% A simple programatic interface for such a BA900Sheet object is

sheet = BA900Sheet("./BA900-2019-06-01csv/TOTAL.csv")
% sheet = 
%
%   BA900Sheet with properties:
%
%             filepath: "./BA900-2019-06-01csv/TOTAL.csv"
%               header: [3×1 table]
%            subtables: [1×18 struct]
%     itemDescriptions: [336×1 table]

% The returned object has these listed properties. The header property holds the 
% sheet's identifying details.

sheet.header
% ans =
%
%   3×1 table
%
%                         ExtraVar1     
%                    ___________________
%
%     Date           {'2019-06'        }
%     Institution    {' *TOTAL*(TOTAL)'}
%     Form Type      {' BA900'         }

% The itemDescriptions property holds the list of itemNumbers and their associated
% descriptions.

sheet.itemDescriptions
% ans =
%
%   336×1 table
%
%                                                                                                                                                   Description                                                                                                                                       
%            _________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
%
%     1      "DEPOSITS (total of items 2 and 32)"                                                                                                                                                                                                                                                     
%     2      "DEPOSITS DENOMINATED IN RAND (total of items 3, 6, 12, 13 and 29)" 
%     ...

% The sheet object has functionality that enables a coarse search through these 
% descriptions, for the case-insensitive inclusion of a given string of characters.

sheet.getItemsDescribedBy('capital')
% ans =
%
%   2×1 table
%
%                           Description                
%            __________________________________________
%
%     97     "Share capital (total of items 98 to 100)"
%     291    "Committed capital expenditure"   

% Furthermore, there is functionality to retrieve a subtable that contains a
% given item number.

sheet.getSubtableWithItemNumber(97)
% ans =
%
%   7×3 table
%
%             TOTAL(1)     Of which: liabilities to the foreign sector(2)    Of which: in foreign currency (included in col 1 )(3)
%            __________    ______________________________________________    _____________________________________________________
%
%     96     4.8388e+08                      4.6344e+07                                           1.4009e+05                      
%     97     2.1648e+08                      3.0487e+07                                           1.3995e+05                      
%     98     6.8171e+07                      3.0467e+07                                           1.3995e+05                      
%     99     1.4149e+08                           20067                                                    0                      
%     100    6.8177e+06                               0                                                    0                      
%     101     2.674e+08                      1.5858e+07                                               138.18                      
%     102    5.7957e+09                             NaN                                                  NaN 

% Or to get the index of such a subtable within a sheet.

sheet.getSubtableWithItemNumber(97)
% ans =
%
%   5

% All of the subtables of a sheet are stored in the sheet's subtables property,
% which is an array of the sheet's internal tables, paired to
% their names in a structure.
% Each row in the subtable is identified by the item number, and the
% columns are headed according to the subtable. **Each cell has been parsed as a number.

sheet.subtables 
% ans = 
%
%   1×18 struct array with fields:
%
%     name
%     table

sheet.subtables(5)
% ans = 
%
%   struct with fields:
%
%      name: {'Table 5'}
%     table: [7×3 table]

% A convenience function exists to retrieve the descriptions for a subtable.

sheet.getDescriptionsForSubtable(sheet.subtables(5).table)
% ans =
%
%   7×1 table
%
%                                   Description                       
%            _________________________________________________________
%
%     96     "TOTAL EQUITY (total of items 97 and 101)"               
%     97     "Share capital (total of items 98 to 100)"               
%     98     "     Banksb"                                            
%     99     "     Financial corporate sectorc"                       
%     100    "     Non-financial corporate sector and other"          
%     101    "Other reserves"                                         
%     102    "TOTAL EQUITY AND LIABILITIES (total of items 95 and 96)"

[ans sheet.subtables(5).table]

% 

% In order to conduct an analysis across multiple banks and multiple months,
% further MATLAB code was created to programatically load and access multiple
% BA900 sheets. This is done with a BA900Analysis object, that optionally
% filters the directory's sheets against a list of filenames.

fileNameFilter = ["34118.csv", "160571.csv", "165239.csv", "333107.csv", "TOTAL.csv"];
analysis = BA900Analysis(fileNameFilter)
% analysis = 
%
%   BA900Analysis with properties:
%
%     fileNameFilter: ["34118.csv"    "160571.csv"    "165239.csv"    "333107.csv"    "TOTAL.csv"]
%             sheets: [1×15 BA900Sheet]
%              dates: ["2019-06"    "2019-07"    "2019-08"]
%       institutions: [1×5 string]

% The BA900Analysis object automatically keeps track of each sheet's date
% and institution, building up a list of values for each. Adding or removing
% a month to or from the analysis merely requires handling the folders.

analysis.institutions
% ans = 
%
%   1×5 string array
%
%     " *TOTAL*(TOTAL)"    " ABSA BANK LTD(341…"    " AFRICAN BANK LIMI…"    " CAPITEC BANK(3331…"    " TYME BANK LIMITED…"

% These are used to neatly catalogue the results of a request for a particular
% cell from each sheet, for instance the total for item number 96.

metrics.Equity = analysis.getCellsAsTable(96, 'TOTAL(1)')
% ans =
%
%   5×3 table
%
%                                          2019-06       2019-07       2019-08  
%                                         __________    __________    __________
%
%     *TOTAL*(TOTAL)                      4.8388e+08    4.8656e+08    4.8898e+08
%     ABSA BANK LTD(34118)                8.7394e+07    8.7228e+07    8.5308e+07
%     AFRICAN BANK LIMITED (N)(160571)    8.3697e+06    8.4421e+06    8.5002e+06
%     CAPITEC BANK(333107)                2.1744e+07    2.2285e+07    2.2601e+07
%     TYME BANK LIMITED(165239)           7.3395e+05    6.2953e+05     5.175e+05

% This can easily be reformatted.

format bank
metrics.Equity
% ans =
%
%   5×3 table
%
%                                           2019-06         2019-07         2019-08   
%                                         ____________    ____________    ____________
%
%     *TOTAL*(TOTAL)                      483883453.86    486559710.77    488984498.04
%     ABSA BANK LTD(34118)                 87394402.00     87227604.00     85307593.00
%     AFRICAN BANK LIMITED (N)(160571)      8369696.00      8442130.00      8500235.00
%     CAPITEC BANK(333107)                 21744242.00     22285040.00     22601239.00
%     TYME BANK LIMITED(165239)              733953.00       629529.00       517503.00

% These tabulated results can be filtered for an institution or a date.

metrics.Deposits = analysis.getCellsAsTable(1, 'TOTAL(7)');
metrics.Deposits("*TOTAL*(TOTAL)", :)

% Quickly casting from the table to an array, the values of the cells can be used
% in calculation.

metrics.Loans = analysis.getCellsAsTable(110, 'TOTAL ASSETS (Col 1 plus col 3)(5)');
table2array(metrics.Loans) ./ table2array(metrics.Deposits)
% ans =
%
%     1.0193    1.0178    1.0082
%     1.0662    1.0758    1.0474
%     6.1933    6.0496    5.5532
%     1.0924    1.0715    1.0426
%     2.6640    2.1343    0.9916

% This can be retabulated with the appropriated row and column labels
% using a conversion function from the BA900Analysis object.

metrics.LoansToDeposits = analysis.cells2table(ans, @array2table);
metrics.LoansToDeposits
% ans =
%
%   5×3 table
%
%                                         2019-06    2019-07    2019-08
%                                         _______    _______    _______
%
%     *TOTAL*(TOTAL)                      1.0193     1.0178      1.0082
%     ABSA BANK LTD(34118)                1.0662     1.0758      1.0474
%     AFRICAN BANK LIMITED (N)(160571)    6.1933     6.0496      5.5532
%     CAPITEC BANK(333107)                1.0924     1.0715      1.0426
%     TYME BANK LIMITED(165239)            2.664     2.1343     0.99163

% A convenience function handles the intermediate conversions, and enables
% the application of a function, taking two arrays, to the analysis tables.

metrics.MarketShare = analysis.applyFunctionToTables(@(t1, t2) t1 ./ t2, metrics.Deposits, metrics.Deposits("*TOTAL*(TOTAL)", :));
metrics.MarketShare

% ans =
%
%   5×3 table
%
%                                          2019-06       2019-07       2019-08  
%                                         __________    __________    __________
%
%     *TOTAL*(TOTAL)                               1             1             1
%     ABSA BANK LTD(34118)                   0.19865       0.19678       0.19865
%     AFRICAN BANK LIMITED (N)(160571)    0.00093041    0.00097679     0.0010792
%     CAPITEC BANK(333107)                  0.018944      0.019206      0.019785
%     TYME BANK LIMITED(165239)           5.3401e-05    6.9023e-05    8.3886e-05

% MATLAB's regular functionality enables further manipulation of this data.

sortrows(metrics.MarketShare, size(metrics.MarketShare,2), 'descend')
% ans =
%
%   5×3 table
%
%                                          2019-06       2019-07       2019-08  
%                                         __________    __________    __________
%
%     *TOTAL*(TOTAL)                               1             1             1
%     ABSA BANK LTD(34118)                   0.19865       0.19678       0.19865
%     CAPITEC BANK(333107)                  0.018944      0.019206      0.019785
%     AFRICAN BANK LIMITED (N)(160571)    0.00093041    0.00097679     0.0010792
%     TYME BANK LIMITED(165239)           5.3401e-05    6.9023e-05    8.3886e-05

% http://wiredspace.wits.ac.za/xmlui/bitstream/handle/10539/15806/Thesis.pdf?sequence=1&isAllowed=y
% The fourth intermediation measure used is loans plus deposits divided by total assets,
% essentially a banking operational efficiency measure, which would be expected to
% exceed one hundred percent.

% In order to gauge the operational efficiency of a bank, the outstanding
% data is that of total assets. 

analysis.getItemsDescribedBy('total assets')
% ans =
%
%   4×1 table
%
%                                      Description                           
%            ________________________________________________________________
%
%     277    "TOTAL ASSETS (total of items 103, 110, 195, 258 and 267)"      
%     284    "Total assets prior to netting or set-off"                      
%     351    "Total assets temporarily acquired (total of items 352 and 369)"
%     377    "Total assets lent (total of items 378, 381 and 382)"   

% To gauge which column is required from that item number, the containing
% subtable from the first sheet is viewed.

analysis.sheets(1).getSubtableWithItemNumber(277)
% ...

% Then the cells are collected from every sheet.

metrics.Assets = analysis.getCellsAsTable(277, 'TOTAL ASSETS (Col 1 plus col 3)(5)');
metrics.Assets
% ans =
%
%   5×3 table
%
%                                          2019-06       2019-07       2019-08  
%                                         __________    __________    __________
%
%     *TOTAL*(TOTAL)                      5.7957e+09    5.8007e+09    5.8954e+09
%     ABSA BANK LTD(34118)                1.1478e+09    1.1469e+09    1.1431e+09
%     AFRICAN BANK LIMITED (N)(160571)    2.6965e+07    2.7477e+07    2.8249e+07
%     CAPITEC BANK(333107)                1.0929e+08    1.1062e+08    1.1323e+08
%     TYME BANK LIMITED(165239)           1.0875e+06      9.91e+05    9.2207e+05

metrics.OperationalEfficiency = analysis.applyFunctionToTables(@(cellArray) (cellArray{1} + cellArray{2}) ./ cellArray{3}, {metrics.Loans metrics.Deposits metrics.Assets})
metrics.OperationalEfficiency
% ans =
%
%   5×3 table
%
%                                         2019-06    2019-07    2019-08
%                                         _______    _______    _______
%
%     *TOTAL*(TOTAL)                       1.4223     1.4228     1.4077
%     ABSA BANK LTD(34118)                 1.4598     1.4568     1.4703
%     AFRICAN BANK LIMITED (N)(160571)     1.0132      1.025     1.0345
%     CAPITEC BANK(333107)                 1.4806      1.471     1.4749
%     TYME BANK LIMITED(165239)           0.73444    0.89291    0.74875

% To compile the above ratio for the banking industry, banking institutions’ total loans
% and advances and total investments and bills discounted are computed relative to
% banking institutions’ total assets. As can be seen in Chart 5, the ratio suggests that
% between 71.94% and 82.20% of banks’ total assets in the 1992 to 2008 period was
% either lent out or invested. This suggests that banks have not used their assets to their
% full potential (loans plus marketable securities at least one hundred percent of total
% assets), as banks are uniquely able to add to the existing stock of money by lending
% money created by claims on their own debt (Schumpeter, 1934), while below potential
% investment in corporates’ fixed income securities and equities limits companies’
% ability to expand and invest, limiting economic activity.