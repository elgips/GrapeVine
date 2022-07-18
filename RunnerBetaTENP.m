clc 
clear;
%% INIT And Sens of plant
load DolevStructRaw.mat;
ParamNames={'splaimax'
'splaimin'
'afpf'
'dlaimaxbrut'
'bfpf'
'nbinflo'
'cfpf'
'dfpf'
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
VarList=["lai(n)","swfac"];
VarFile='C:\Javastics\WORKSPACE\var.mod';
UpdateVarList( VarFile,VarList );
%init data
SimStartDay=50;
Years=["2009","2010","2011"];
n1=length(Years);
Treatments=["A","B","C","D","E"];
n2=length(Treatments);
repeats=["R1","R2","R3","R4"];
measurement=["LAI","SWP"];
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
% %% MultiRun
for i=1:n1
    for j=1:n2
        %set treatment file
        IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
        FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
        TreatInitIrFe(IrriMat,FertMat,TecXml);
        for k=1:n3
            Stimes=[];
            SStat=[];
            for l=1:length(measurement)
                St=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY; %צריך להוסיף לולאה כאן לבניית וקטור ביחס לכל המצבים
                Stimes=[Stimes,unique(St)];
                %Ss=1*ones(1,length(St));
                SStat=[SStat,l*ones(1,length(unique(St)))];
            end
            %Nominal Run
            Ynom=RunSimulation(USM_name,PlantXml,SoilNom,InitXml,Dolev.ConstantData.SiteName,[num2str(double(Years(i))-1),Years(i)],TecXml);
            Ynom=Ynom(:,5:end);
            [n,m]=size(Ynom);
            Yavg=repmat(mean(Ynom),n,1);
            Yi=zeros(length(ParamNames),length(SStat));
            Yin=Yi;
                        %% make param number vector - fix the runsimu/runchange funcheaders
            for ii=1:length(Paranum)%לא יעיל, אתה מחשב כל פעם באופן מיותר, נא יעל והוצא חלקים מיותרים מהלולאה
                ParaPlaceInRange=CheckPlaceInRange(Paranum(ii),PlantXml);
                [Ypl,Dp]=RunChange(Paranum(ii),USM_name,PlantXml,PlantXmlVar,1);
                Ymn=RunChange(Paranum(ii),USM_name,PlantXml,PlantXmlVar,-1);
                switch ParaPlaceInRange
                    case 0
                        DYDP=0.5*((Ypl-Ynom)/Dp+(Ynom-Ymn)/Dp).*(Pnom(ii)./Yavg);
                    case 1
                        DYDP=(Ypl-Ynom)/Dp*Pnom(ii)./Yavg;
                    case 2
                        DYDP=(Ynom-Ymn)/Dp*Pnom(ii)./Yavg;
                end
%                  Yndat=(ResMat2Vec(Ynom,St,Ss))';
%                  ny=length(Yndat);
%                  TYnom=[TYnom; [i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),St',Yndat]];               
                Yi(ii,:)=ResMat2Vec(DYDP,Stimes,SStat);
                if  Yi(ii,:)*Yi(ii,:)'~=0
                    Yin(ii,:)=Yi(ii,:)/sqrt(Yi(ii,:)*Yi(ii,:)');
                else
                    Yin(ii,:)=Yi(ii,:);
                end
                disp([ii,i,j,k]);
                RunPer=(i-1)/n1+(j-1)/n1/n2+(ii-1)/n1/n2/length(Paranum);
                disp(strcat(string(RunPer*100),'%'));
 
            end
            H1=[H1,Yi];
            Hn1=[Hn1,Yin];
        end
    end
end
%%  INIT And Sens of Soil
  ParamNames={'argi'
'norg'
'profhum'
'calc'
'pH'
'concseuil'
'albedo'
'q0'
'ruisolnu'
'obstarac'
'pluiebat'
'zesx'
'cfes'
'z0solnu'
'csurNsol'
'penterui'
};
% model INIT
%USM
USM_name='VINE_ALPHA';
%INIT XML
InitXml='vigne_ini.xml';
%SOILNOM
SoilNom='SandyLoamDolevAlpha';
SolXml='C:\Javastics\WORKSPACE\sols.xml';
SoilVar='SandyLoamDolevVar';
temp=xmlread(SolXml);
Sr=temp.getElementsByTagName('sol');
NomNum=SoilNum(Sr,SoilNom);
VarNum=SoilNum(Sr,SoilVar);
% original plant param file
PlantXml='vine_SYRAH_plt.xml';
% param file with a change
PlantXmlVar='MERILO_plt.xml';
% TREAT XML FILE
TecXml='vigne_tec.xml';
Paranum=ListSoilPara(ParamNames,NomNum,SolXml);
Pnom=SoilParaNominal(Paranum,NomNum,SolXml);
H2=[];
Hn2=[];
% %% MultiRun
for i=1:n1
    for j=1:n2
        %set treatment file
        IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
        FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
        TreatInitIrFe(IrriMat,FertMat,TecXml);
        for k=1:n3
            Stimes=[];
            SStat=[];
            for l=1:length(measurement)
                St=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
                Stimes=[Stimes,unique(St)];
                %Ss=1*ones(1,length(St));
                SStat=[SStat,l*ones(1,length(unique(St)))];
                %Nominal Run
            end
            Ynom=RunSimulation(USM_name,PlantXml,SoilNom,InitXml,Dolev.ConstantData.SiteName,[num2str(double(Years(i))-1),Years(i)],TecXml);
            Ynom=Ynom(:,5:end);
            [n,m]=size(Ynom);
            Yavg=repmat(mean(Ynom),n,1);
            Yi=zeros(length(ParamNames),length(SStat));
            Yin=Yi;
                        %% make param number vector - fix the runsimu/runchange funcheaders
            for ii=1:length(Paranum)%לא יעיל, אתה מחשב כל פעם באופן מיותר, נא יעל והוצא חלקים מיותרים מהלולאה
                ParaPlaceInRange=SoilCheckPlaceInRange(Paranum(ii),NomNum,SolXml);
                [Ypl,Dp]=RunChangeSoil(Paranum(ii),USM_name,PlantXml,SolXml,NomNum,SoilVar,1);
                Ymn=RunChangeSoil(Paranum(ii),USM_name,PlantXml,SolXml,NomNum,SoilVar,-1);
                switch ParaPlaceInRange
                    case 0
                        DYDP=0.5*((Ypl-Ynom)/Dp+(Ynom-Ymn)/Dp).*(Pnom(ii)./Yavg);
                    case 1
                        DYDP=(Ypl-Ynom)/Dp*Pnom(ii)./Yavg;
                    case 2
                        DYDP=(Ynom-Ymn)/Dp*Pnom(ii)./Yavg;
                end
%                  Yndat=(ResMat2Vec(Ynom,St,Ss))';
%                  ny=length(Yndat);
%                  TYnom=[TYnom; [i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),St',Yndat]];               
                Yi(ii,:)=ResMat2Vec(DYDP,Stimes,SStat);
                if  Yi(ii,:)*Yi(ii,:)'~=0
                    Yin(ii,:)=Yi(ii,:)/sqrt(Yi(ii,:)*Yi(ii,:)');
                else
                    Yin(ii,:)=Yi(ii,:);
                end
                disp([ii,i,j,k]);
                RunPer=(i-1)/n1+(j-1)/n1/n2+(ii-1)/n1/n2/length(Paranum);
                disp(strcat(string(RunPer*100),'%'));
            end
            H2=[H2,Yi];
            Hn2=[Hn2,Yin];
        end
    end
end
%% FISHER
H=[H1;H2];
for i=1:length(H(:,1))
    if H(i,:)*H(i,:)'~=0
        Hn(i,:)=H(i,:)/sqrt(H(i,:)*H(i,:)');
    end
end
% Hn=[Hn1;Hn2];
Fish=H*H';
CF=cond(Fish);
FishN=Hn*Hn';
%% PART 2 - optimality problem
close all;
style={'or'
'*k'};
measlable=strings(length(measurement),1);
simlable=strings(length(measurement),1);
    for l=1:length(measurement)
    simlable(l,:)=strcat(measurement(l)," simulation")
    measlable(l,:)=strcat(measurement(l)," measurments")
    end
    PlLable=[simlable;measlable];
    %% plant parameters
    ParamPlantNames={'splaimax'};
    ParanumPlant=ListPara(ParamPlantNames,PlantXml);
    Pnom=ParaNominal(ParanumPlant,PlantXml);
    Pmin=ParMin(PlantXml,ParanumPlant);
    Pmax=ParMax(PlantXml,ParanumPlant);
    space=5;
    Valmtrix=Range2Vec( Pmin,Pmax,space);
%     points=10^2;
%     Pmin=[0.7,0.65];
%     Pmax=[1.2,0.65];
    P1Plant=linspace(Pmin(1),Pmax(1),3);
%     P2=linspace(Pmin(2),Pmax(2),4);
%     P3=linspace(Pmin(3),Pmax(3)-0.01,6);
%     Pmat=combvec(P1,P2);
% Pmax(3)=0.97;
%     Pmat=Pmin+rand(2,15).*(Pmax-Pmin);
%% soil paraneters
SoilXml='C:\Javastics\WORKSPACE\sols.xml';
SoilNameVar='SandyLoamDolevVar';
    ParamSoilNames={'profhum'};
    ParanumSoil=ListSoilPara(ParamSoilNames,28,SoilXml);
    PnomSoil=SoilParaNominal(ParanumSoil,28,SoilXml);
    PminSoil=ParMin(SoilXml,ParanumSoil);
    PmaxSoil=ParMax(SoilXml,ParanumSoil);
    space=5;
    Valmtrix=Range2Vec( Pmin,Pmax,space);
%     points=10^2;
%     Pmin=[0.7,0.65];
%     Pmax=[1.2,0.65];
    P1Soil=linspace(PminSoil(1),PmaxSoil(1),3);
    %%
    close all;
    Pmat=combvec(1:1:length(P1Plant),1:1:length(P1Soil));
    J=zeros(1,length(P1Plant)*length(P1Soil));
    Blue=zeros(1,length(P1Plant)*length(P1Soil));
    d1=zeros(1,length(P1Plant)*length(P1Soil));
%     P=[0.505,.7];
for ii=1:length(Pmat)    
    PPlant=P1Plant(Pmat(1,ii));
    PSoil=P1Soil(Pmat(2,ii));
    TY=[];
    if ii<=1
        Tm=[];
    end
    figure();
    for i=1:n1
        for j=1:n2
            %set treatment file
            disp('monkey');
            IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
            FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
            LfRVec=[Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Do, yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Time,Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Value];
            TreatInitIrFe(IrriMat,FertMat,TecXml);
            TreatInitLr(LfRVec,TecXml);
             %get simulation result
             [Y,~,~,T]=RunChanges(ParanumPlant,ParanumSoil,USM_name,PlantXml,PlantXmlVar,SoilXml,PPlant,PSoil,SoilNameVar);
             subplot(n1,n2,n2*(i-1)+j);
             plot(T(730-SimStartDay+1-365+1:end),Y((730-SimStartDay+1-365+1:end),:));
             disp('no monkey');
             hold on;
            for k=1:n3
                Stimes=[];
                SStat=[];
                for l=1:length(measurement)
                    St=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
                    Stimes=[Stimes,St];
                    %Ss=1*ones(1,length(St));
                    SStat=[SStat,l*ones(1,length(St))];
                    %Nominal Run
                end
                disp('crazy monkey');
%                 Stimes=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
%                 SStat=1*ones(1,length(Stimes));   
                Yndat=(ResMat2Vec(Y,Stimes,SStat))';
                ny=length(Yndat);
                TY=[TY; [i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),Stimes',Yndat,SStat']];
                for l=1:length(measurement)
                 YmeasDat=GetMeasData(Dolev,Years(i),Treatments(j),repeats(k) ,measurement(l));
%                  YmeasDat(:,1)=YmeasDat(:,1)+yeardays(double(Years(i))-1)-SimStartDay+1;
                 nym= length(YmeasDat);
                 if ii<=1
                    Tm=[Tm;  [i*ones(nym,1),j*ones(nym,1),k*ones(nym,1),YmeasDat,l*ones(nym,1)]];
                 end
                 plot(YmeasDat(:,1),YmeasDat(:,2),char(style(l)));
                end
            end
            
              xlabel 't[Day of year]';
             ylabel 'LAI,SWF';
             title(strcat(Years(i),Treatments(j)));
        end
    end
%     legend(PlLable,'Location','northeast');
%     legend('Location','northeast')
%     legend('boxoff')
%     if ii<=1
%         Erd=TYDmean(Tm);
%     end
%     for i=1:n1
%         for j=1:n2
%             subplot(n1,n2,n2*(i-1)+j);
%             Er=Er2sr(Erd,i,j);
%             errorbar(Er(:,1),Er(:,2),Er(:,3),'k');
%         end
%     end
%     TYY=unique(TY,'rows');
%     J(ii)=sum((Tm(7:end,5)-TY(7:end,5)).^2/mean(Tm(7:end,5))^2)/max(Tm(7:end,5));%+sum((Tm(1:6,5)-TY(1:6,5)).^2/mean(Tm(1:6,5))^2)/max(Tm(1:6,5));%sum((Tm(:,5)-TY(:,5)).^2/mean(Tm(:,5))^2);
for l=1:length(measurement)
    J=J+sum((Tm((Tm(:,6)==l),5)-TY((TY(:,6)==l),5)).^2/mean(Tm((Tm(:,6)==l),5))^2)/max(Tm((Tm(:,6)==l),5));
end
%     d1(ii)=Index_d1(TYY(:,5),Erd(:,4),mean(Erd(:,4))); %כאן צריך ווקטורים לכל המדגם - כל
%     Blue(ii)=BLU_ERROR(TYY(:,5),Erd(:,4),Erd(:,5));
%     איבר הוא ביום,שנה וטיפול מסויים (נראה לי שחזרות שונות מתומצתות לממוצע
%     של הרגע, לשאול את פרופ' איוסלוביץ
end

% end
% %get min J and...  (another iterration?)
%             for ii=1:2
%                 %get simulation result
%                 [Y,X]=RunMultiChange(Paranum,USM_name,PlantXml,PlantXmlVar,Pmin+rand*Pmax);
%                 %make sample vector of relevent simulation
%                 Ys=ResMat2Vec(Y,Stimes,SStat);
%                 %get measured data vector
%                 Ym
%                 %calculate J - optimization criterion J is stored in vector
%                 %similiar to the points vector (either random points or all
%                 %combi vector)
%             end
