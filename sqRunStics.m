%% simple runner to test succsesive \sequential init run stics
clc 
clear;
%% INIT
load DolevStruct.mat;

% variable list update
% VarList="lai(n)";
% VarFile='C:\Javastics\WORKSPACE\var.mod';
% UpdateVarList( VarFile,VarList );
%init data
SimStartDay=50;
Years="2011"%;["2009","2010","2011"];
n1=length(Years);
Treatments=["A","B","C","D","E"];
n2=length(Treatments);
repeats=["R1","R2","R3","R4"];
measurement="SWF";
% n3=length(repeats);
n3=1;
% model INIT
%USM
USM_name='VINE_ALPHA';
%INIT XML
InitXml='vigne_ini.xml';
%SOILNOM
SoilNom='SandyLoamDolevAlpha';
% original plant param file
PlantXml='vine_SYRAH_plt.xml';
% param file with a change
PlantXmlVar='MERILO_plt.xml';
% TREAT XMLFILE
TecXml='vigne_tec.xml';

%% 2008 get default value
init2008=xmlread('vigne_ini2008.xml');
%assume LAI=0, because we are indorm
%masec - changes, 

%magrain=0
Zrac08=init2008.getElementsByTagName('zrac0').item(0);%zrac - same same 115(asumme developed roots
QNplante08=init2008.getElementsByTagName('QNplante0').item(0);
resperenne08=init2008.getElementsByTagName('resperenne0').item(0);%QNPLANTE
%roots

%% run two years
        IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(1))-1)))).General.Treatments.(char(Treatments(1))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(1)))).General.Treatments.(char(Treatments(1))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(1))-1)))).General.Treatments.(char(Treatments(1))).Irrigation.Time.Data ;yeardays(double(Years(1))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(1)))).General.Treatments.(char(Treatments(1))).Irrigation.Time.Data]];
        FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(1))-1)))).General.Treatments.(char(Treatments(1))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(1)))).General.Treatments.(char(Treatments(1))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(1))-1)))).General.Treatments.(char(Treatments(1))).Fertigation.Time.Data ; yeardays(double(Years(1))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(1)))).General.Treatments.(char(Treatments(1))).Fertigation.Time.Data]];
        TreatInitIrFe(IrriMat,FertMat,TecXml);
        Ynom=RunSimulation(USM_name,PlantXml,SoilNom,InitXml,Dolev.ConstantData.SiteName,[num2str(double(Years(1))-1),Years(1)],TecXml);
%% take final value and insert it to the init file
%run's end to 2009 init file for next run
% Zrac09=init2008.getElementsByTagName('zrac0').item(0).setTextContent("");%zrac - same same 115(asumme developed roots
% QNplante09=init2008.getElementsByTagName('QNplante0').item(0).setTextContent("");
% resperenne09=init2008.getElementsByTagName('resperenne0').item(0).setTextContent("");%QNPLANTE

