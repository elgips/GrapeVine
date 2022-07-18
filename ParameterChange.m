function Delta_P  = ParameterChange(ParamNum,ParamXmlFileNom,ParamXmlFileVar,eps)
    Root=xmlread(ParamXmlFileNom);
    Par=Root.getElementsByTagName('param').item(ParamNum);
    if ~strcmp(Par.getAttribute('format'),'real')
        error('Wrong parameter type,please input a real type parameter')
    end
    Min=str2double(Par.getAttribute('min'));
    Max=str2double(Par.getAttribute('max'));
    NominalVal=str2double(Par.getTextContent);
    range=Max-Min;
    Delta_P=eps*(range);
    Par.setTextContent(num2str(NominalVal+Delta_P));
    xmlwrite(strcat('plant\',ParamXmlFileVar),Root);
end

