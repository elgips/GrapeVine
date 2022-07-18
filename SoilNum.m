function SolNum = SoilNum( rootSoil,SoilName)
%UNTITLED2 returns soil type serial number
%   Detailed explanation goes here
Nsoils=rootSoil.getLength;
    SolNum=NaN;
    for i=1:Nsoils
        if strcmp(rootSoil.item(i-1).getAttribute('nom'),SoilName)
            SolNum=i-1;
        end
    end
    if isnan(SolNum)
        error('INPUT ERRROR:wrong soil name');
    end

end

