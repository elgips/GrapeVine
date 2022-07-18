%ONLY PLANT! כדי שאוכל לעכל צרה בשעתה
clc;
clear all;
%USM NAME
USM_name='VINE_ALPHA';
% original plant param file
ParamXml='vine_SYRAH_plt.xml';
% param file with a change
ParamXmlFileVar='MERILO_plt.xml';
%param names list
ParamNames={'splaimax'
'afpf'
'bfpf'
'nbinflo'
'cfpf'
};
% sampling points:
Stimes=365-100+1+[117
135
152
173]';
SStat=3*ones(1,4);
%Nominal Run
Ynom=RunSimulation(USM_name,ParamXml);
Ynom=Ynom(:,5:end);
[n,m]=size(Ynom);
Yavg=repmat(mean(Ynom),n,1);
Yi=zeros(length(ParamNames),length(SStat));
Yin=Yi;
%Average Nominal values
%% make param number vector
Paranum=ListPara(ParamNames,ParamXml);
Pnom=ParaNominal(Paranum,ParamXml);
for i=1:length(Paranum)
    ParaPlaceInRange=CheckPlaceInRange(Paranum(i),ParamXml);
    [Ypl,Dp]=RunChange(Paranum(i),ParamXml,ParamXmlFileVar,1);
    Ymn=RunChange(Paranum(i),ParamXml,ParamXmlFileVar,-1);
    switch ParaPlaceInRange
        case 0
            DYDP=0.5*((Ypl-Ynom)/Dp+(Ynom-Ymn)/Dp).*(Pnom(i)./Yavg);
        case 1
            DYDP=(Ypl-Ynom)/Dp*Pnom(i)./Yavg;
        case 2
            DYDP=(Ynom-Ymn)/Dp*Pnom(i)./Yavg;
    end
    Yi(i,:)=ResMat2Vec(DYDP,Stimes,SStat);
    Yin(i,:)=Yi(i,:)/sqrt(Yi(i,:)*Yi(i,:)');
end
Fish=Yi*Yi';
CF=cond(Fish)
FishN=Yin*Yin';

