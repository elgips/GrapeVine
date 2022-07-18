function Paranom = SoilParaNominal(ParamNums,SolNum,ParamXml )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ParamNums);
    Paranom=zeros(N,1);
    A=xmlread(ParamXml);
    Pars=A.getElementsByTagName('sol').item(SolNum).getElementsByTagName('param');
    for i=1:N
        Paranom(i)=str2double(Pars.item(ParamNums(i)).getTextContent);
    end
end

