function []  = ChngSoilTableParam(SoXlsFile,SolXlsFileVar,SolNom,LayerNom,ColloneName,Value)
SolsRoot=xmlread(SoXlsFile);
Sol=SolsRoot.getElementsByTagName('sol').item(unique(FindItemNum('sol',SolNom,SolsRoot)));
Table=Sol.getElementsByTagName('tableau').item(unique(FindItemNum('tableau',LayerNom,Sol)));
Table.getElementsByTagName('colonne').item(unique(FindItemNum('colonne',{ColloneName},Table))).setTextContent(Value);
xmlwrite(SolXlsFileVar,SolsRoot);


end

