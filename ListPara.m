function ItemNumVec = ListPara(ParamNames,ParamXml )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ParamNames);
    ItemNumVec=ones(N,1)*(-1);
    A=xmlread(ParamXml);
    Pars=A.getElementsByTagName('param');
    for i=0:Pars.getLength-1
        ItemNumVec=ItemNumVec+(i+1)*double(strcmp(Pars.item(i).getAttribute('nom'),ParamNames));
    end
end

