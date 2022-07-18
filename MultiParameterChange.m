function NumandVal  = MultiParameterChange(ParamNumVec,ParamXmlFileNom,ParamXmlFileVar,ParValVec)
    %changes parameters values in xml file -  list of parameters can be
    %changed.
    Root=xmlread(strcat('C:\Javastics\plant\',ParamXmlFileNom));
    n=length(ParamNumVec);
    for i=1:n
        Par=Root.getElementsByTagName('param').item(ParamNumVec(i));
        if ~strcmp(Par.getAttribute('format'),'real')
            error('Wrong parameter type,please input a real type parameter')
        end
        Par.setTextContent(num2str(ParValVec(i)));
    end
    xmlwrite(strcat('C:\Javastics\plant\',ParamXmlFileVar),Root);
    NumandVal=ParValVec;
end

