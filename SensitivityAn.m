function [H,Hn,CN] = SensitivityAn( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% INIT And Sens of plant
load DolevStructRawWithFruit.mat;
ParamNames={'splaimax'
'splaimin'
'spfrmax'
'spfrmin'
'afpf'
'dureefruit'
'durvieF'
'dlaimaxbrut'
'bfpf'
'nbinflo'
'cfpf'
'dfpf'
'pgrainmaxi'
'pentinflores'
'inflomax'
'afruitpot'
'stdrpnou'
'stressdev'
'nbgrmax'
'stdrpmat'
'psiturg'
'psisto'
'q10'
'stlevdrp'%
'durvieF'%
'dureefruit'%
'h2ofeuilverte'
'h2ofeuiljaune'
'h2otigestruc'
'h2oreserve'
'h2ofrvert'
'deshydbase'
'tempdeshyd'
'rsmin'
'sensanox'
'sensrsec'
'contrdamax'
'draclong'
'debsenrac'
'lvfront'
'longsperac'
};
% variable list update
VarList=["lai(n)","swfac","mafruit","nfruit(nboite)","H2Orec"];
VarFile='C:\Javastics\WORKSPACE\var.mod';
UpdateVarList( VarFile,VarList );
%init data
SimStartDay=50;
Years=["2009","2010","2011"];
n1=length(Years);
Treatments=["A","B","C","D","E"];
n2=length(Treatments);
repeats=["R1","R2","R3","R4"];
measurement=["LAI","SWP","W100Ber","NbDummy"];%,"Brix"];%;,"TPD"];
% n3=length(repeats);
n3=1;
%% model INIT
%USM
USM_name='VINE_ALPHA';
%INIT XML
InitXml='vigne_ini.xml';
%SOILNOM
SoilNom='SandyLoamDolevAlpha';
% original plant param file
PlantXml='MERILO_plt.xml';
% param file with a change
PlantXmlVar='vin_cs_plt.xml';
% TREAT XMLFILE
TecXml='vigne_tec.xml';
H1=[];
Hn1=[];
Paranum=ListPara(ParamNames,PlantXml);
Pnom=ParaNominal(Paranum,PlantXml);
%
TYnom=[];
TYmeas=[];

end

