function ItemNumVec = ListSoilCol(ColNames,SoilName,ParamXml )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ColNames);
    ItemNumVec=ones(N,1)*(-1);
    A=xmlread(ParamXml);
    % get soil serial number
    Sol=A.getElementsByTagName('sol');
    SolNum=SoilNum(Sol,SoilName);
    % get parameters serial numbers
    Col=Sol.item(SolNum).getElementsByTagName('tableau_entete').item(0).getElementsByTagName('colonne');
    for i=0:Col.getLength-1
        ItemNumVec=ItemNumVec+(i+1)*double(strcmp(Col.item(i).getAttribute('nom'),ColNames));
    end
end

