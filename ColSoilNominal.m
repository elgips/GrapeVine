function Colnom = ColSoilNominal(LayerNum,ColNums,SoilName,ParamXml )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ColNums);
    Colnom=zeros(N,1);
    A=xmlread(ParamXml);
    Sol=A.getElementsByTagName('sol');
    SolNum=SoilNum(Sol,SoilName);
    Col=Sol.item(SolNum).getElementsByTagName('tableau').item(LayerNum-1).getElementsByTagName('colonne');
    for i=1:N
        Colnom(i)=str2double(Col.item(ColNums(i)).getTextContent);
    end
end

