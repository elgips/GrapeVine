function Paranom = ParaSoilNominal(ParamNums,SoilName,ParamXml )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ParamNums);
    Paranom=zeros(N,1);
    A=xmlread(ParamXml);
    Sol=A.getElementsByTagName('sol');
    SolNum=SoilNum(Sol,SoilName);
    Pars=Sol.item(SolNum).getElementsByTagName('param');
    for i=1:N
        Paranom(i)=str2double(Pars.item(ParamNums(i)).getTextContent);
    end
end

