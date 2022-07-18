close all;
clc;
clear;
load DolevStructRawWithFruit.mat;
global x;
x=Dolev;
PlantXml='MERILO_plt.xml';
SoilXml='C:\Javastics\WORKSPACE\sols.xml';
ParamNamesPlant={'q10';'h2ofrvert'};%'afpf'};
ParamNamesSoil={'albedo'};
ParanumPlant=ListPara(ParamNamesPlant,strcat('C:\Javastics\plant\',PlantXml));
ParanumSoil=ListSoilPara(ParamNamesSoil,28,SoilXml);
PminPlant=ParMin(strcat('C:\Javastics\plant\',PlantXml),ParanumPlant);
PmaxPlant=ParMax(strcat('C:\Javastics\plant\',PlantXml),ParanumPlant);
PminSoil=ParMin(SoilXml,ParanumSoil);
PmaxSoil=ParMax(SoilXml,ParanumSoil);
Pmax=[PmaxPlant;PmaxSoil];
Pmin=[PminPlant;PminSoil];
ParamVals=[1.626857417,0.908797,0.23];
options = optimset('Display','iter','TolFun',10^-2,'TolX',0.01);
[Xval,Fval]=fminsearch(@(P)SticsParaOpti3Con(ParanumPlant,ParanumSoil,[P,-0.15118,-1.49968],Pmin,Pmax),ParamVals,options);
PinRange(ParamVals,Pmax,Pmin,[],[],[]);
[f,g] = SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,ParamVals);
dJ=10;
dP=pinv(g')*dJ;
Pnew=ParamVals-dP;
while ~PinRange(Pnew,Pmax,Pmin,[],[],[])
    dJ=dJ/2;
    disp(dJ);
    dP=pinv(g')*dJ;
    Pnew=ParamVals-dP;
    disp(Pnew);
end
Fnew=SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,Pnew);
while Fnew>f
    dJ=dJ/2;
    dP=pinv(g')*dJ;
    Pnew=ParamVals-dP;
    Fnew=SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,Pnew);
end
%%
% i=0;
% while norm(g)>10^-5 && i<=50
    P=Pnew;
    [f,g] = SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,P);
    dJ=1;
    dP=pinv(g')*dJ;
    Pnew=P-dP;
    while ~PinRange(Pnew,Pmax,Pmin,[],[],[])
        dJ=dJ/10;
        disp(dJ);
        dP=pinv(g')*dJ;
        Pnew=P-dP;
        disp(Pnew);
    end
    Fnew=SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,Pnew);
    while Fnew>f
        dJ=dJ/10;
        dP=pinv(g')*dJ;
        Pnew=P-dP;
        Fnew=SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,Pnew);
        disp(Fnew);
    end
% end