function [Y,Xp,Xs,T]=RunChanges(ParamNumPlant,ParamNumSoil,USM_name,PlantXmlNom,PlantXmlVar,ParamXmlSol,ParValVecPlant,ParValVecSoil,SoilNameVar)
%running changes of both plant and soil parameters
%makes runs with parameter changes
    Xp= MultiParameterChange(ParamNumPlant,PlantXmlNom,PlantXmlVar,ParValVecPlant);
    Xs=  MulParChangeSoil(ParamNumSoil,ParValVecSoil,ParamXmlSol,SoilNameVar);
    temp=RunSimulation(USM_name,PlantXmlVar,SoilNameVar);
    Y=temp(:,5:end);
    T=temp(:,4);
end