function [P,Fval] = RunCalibration()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%
close all;
clc;
clear;
PlantXml='vine_SYRAH_plt.xml';
SoilXml='C:\Javastics\WORKSPACE\sols.xml';
ParamNamesPlant={'splaimax';'h2ofrvert'};%{'splaimax';'dureefruit';'h2ofrvert'};
ParamNamesSoil={};
ParanumPlant=ListPara(ParamNamesPlant,PlantXml);
ParanumSoil=ListSoilPara(ParamNamesSoil,28,SoilXml);
PminPlant=ParMin(PlantXml,ParanumPlant);
PmaxPlant=ParMax(PlantXml,ParanumPlant);
PminSoil=ParMin(SoilXml,ParanumSoil);
PmaxSoil=ParMax(SoilXml,ParanumSoil);
Pmax=[PmaxPlant,PmaxSoil];
Pmin=[PminPlant,PminSoil];
%%
P0=[0.9,0.8051];
% options = optimoptions('fmincon','Algorithm','trust-region-reflective','SpecifyObjectiveGradient',true,'Display','iter','PlotFcn',@optimplotfval);
options = optimoptions('fmincon','Algorithm','interior-point','SpecifyObjectiveGradient',true,'Display','iter');
[P,Fval]=fmincon(@(P)SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,P),P0,[],[],[],[],Pmin,Pmax,[],options);
%% Multiple starting points
    %% Grid
%     PPlantInitGrid=
%     PPlantOptiGrid=
    %% Random points
    
end

