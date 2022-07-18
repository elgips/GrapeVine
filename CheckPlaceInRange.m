function x = CheckPlaceInRange( Paranum,ParamXml )
    %UNTITLED5 Summary of this function goes here
    %   Detailed explanation goes here
    A=xmlread(ParamXml);
    Par=A.getElementsByTagName('param').item(Paranum);
    Min=str2double(Par.getAttribute('min'));
    Max=str2double(Par.getAttribute('max'));
    Nom=str2double(Par.getTextContent);
    x=1*(Nom==Max)+2*(Nom==Min);
end

