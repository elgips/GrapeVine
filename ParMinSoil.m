function Pmin = ParMinSoil(ParamXmlFileNom,ParNumVec)
    Root=xmlread(ParamXmlFileNom);
    n=length(ParNumVec);
    Pmin=zeros(n,1);
    for i=1:n
        Par=Root.getElementsByTagName('param').item(ParNumVec(i));
        if ~strcmp(Par.getAttribute('format'),'real')
            error('Wrong parameter type,please input a real type parameter')
        end
        Pmin(i)=str2double(Par.getAttribute('min'));
    end


end

