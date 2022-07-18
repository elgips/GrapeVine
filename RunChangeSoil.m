function [Y,Dp]=RunChangeSoil(ParamNum,USM_name,PlantXml,solsXml,SolNomNum,SoilVarName,sign)
Root=xmlread(solsXml);
ParNom=Root.getElementsByTagName('sol').item(SolNomNum).getElementsByTagName('param').item(ParamNum).getTextContent;
ParVal=str2num(ParNom)*(1+sign*0.01);
   Pp=MulParChangeSoil(ParamNum,ParVal,solsXml,SoilVarName);
   Dp=str2num(ParNom)*0.01;
    temp=RunSimulation(USM_name,PlantXml,SoilVarName);
    Y=temp(:,5:end);
end