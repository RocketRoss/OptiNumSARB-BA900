filepath = "D:\Development\Code\Scripts\MATLAB\OptiNumDatasets\BA900-2020-01-01csv\34118.csv"

sheet = BA900Sheet(filepath)

getTotal(sheet)

%totalMapped = containers.Map(getDescription(sheet), getTotal(sheet))