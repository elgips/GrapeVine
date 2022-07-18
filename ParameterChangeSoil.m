function Delta_P  = ParameterChangeSoil(ParamNum,SolNomNum,SolVarNum,ParamXmlFile,eps)
%one parameter change
    Root=xmlread(ParamXmlFile);
    ParNom=Root.getElementsByTagName('sol').item(SolNomNum).getElementsByTagName('param').item(ParamNum);
    ParVar=Root.getElementsByTagName('sol').item(SolVarNum).getElementsByTagName('param').item(ParamNum);
    if ~strcmp(ParNom.getAttribute('format'),'real')
        error('Wrong parameter type,please input a real type parameter')
    end
    Min=str2double(ParNom.getAttribute('min'));
    Max=str2double(ParNom.getAttribute('max'));
    NominalVal=str2double(ParNom.getTextContent);
    range=Max-Min;
    Delta_P=eps*(range);
    ParVar.setTextContent(num2str(NominalVal+Delta_P));
%     xmlwrite(strcat('plant\',ParamXmlFileVar),Root);
    xmlwrite((ParamXmlFile),Root);
end