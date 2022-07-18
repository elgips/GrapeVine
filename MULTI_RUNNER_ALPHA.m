clc;
clear all;
%% Plant PARAMETERS
% original plant param file
PlantParamXml='vine_SYRAH_plt.xml';
% param file with a change
PlantParamXmlFileVar='MERILO_plt.xml';
%param names list
PlantParamNames={'splaimax'
'afpf'
'bfpf'
'nbinflo'
'cfpf'
};
%% SOIL PARAMETERS
% original plant param file
SoilParamXml='SandyLoamDolevAlpha';
% param file with a change
SoilParamXmlFileVar='SandyLoamDolevVar';
%param names list
SoilParamNames={};
%% Init PARAMETERS
% original plant param file
InitParamXml='vigne_ini.xml';
% param file with a change
InitParamXmlFileVar='vigne_iniVar.xml';
%param names list
InitParamNames={};
%% Sample sets
Sets={}; % struct SIte.Treat.Line.year - it is possible to build this kind of structs (and it may be efficient in arranging the data coherently

%%
Stimes=[];%cell array for i treatments
SStat=[];
%% NOMINAL RUN
