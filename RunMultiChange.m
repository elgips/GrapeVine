function [Y,X,T]=RunMultiChange(ParamNumVec,USM_name,PlantXmlNom,PlantXmlVar,ParValVec)
%makes runs with parameter changes
    X= MultiParameterChange(ParamNumVec,PlantXmlNom,PlantXmlVar,ParValVec);
    temp=RunSimulation(USM_name,PlantXmlVar);
    Y=temp(:,5:end);
    T=temp(:,4);
end