clc 
clear;
%% INIT
load DolevStruct.mat;
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
% 'pluiebat'
'zesx'
'cfes'
'z0solnu'
% 'csurNsol'
% 'penterui'
};
% variable list update
VarList={'lai(n)'};
VarFile='C:\Javastics\WORKSPACE\var.mod';
UpdateVarList( VarFile,VarList );
%init data
SimStartDay=50;
Years=["2009","2010","2011"];
n1=length(Years);
Treatments=["A","B","C","D","E"];
n2=length(Treatments);
repeats=["R1","R2","R3","R4"];
measurement="LAI";
% n3=length(repeats);
n3=1;
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
H=[];
Hn=[];
Paranum=ListSoilPara(ParamNames,NomNum,SolXml);
Pnom=SoilParaNominal(Paranum,NomNum,SolXml);
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
            St=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement)).DOY;
            Stimes=unique(St);
            Ss=1*ones(1,length(St));
            SStat=1*ones(1,length(Stimes));
            %Nominal Run
            Ynom=RunSimulation(USM_name,PlantXml,SoilNom,InitXml,Dolev.ConstantData.SiteName,[num2str(double(Years(i))-1),Years(i)],TecXml);
            Ynom=Ynom(:,5:end);
            [n,m]=size(Ynom);
            Yavg=repmat(mean(Ynom),n,1);
            Yi=zeros(length(ParamNames),length(SStat));
            Yin=Yi;
                        %% make param number vector - fix the runsimu/runchange funcheaders
            for ii=1:length(Paranum)%לא יעיל, אתה מחשב כל פעם באופן מיותר, נא יעל והוצא חלקים מיותרים מהלולאה
                ParaPlaceInRange=SoilCheckPlaceInRange(Paranum(ii),NomNum,SolXml);
                [Ypl,Dp]=RunChangeSoil(Paranum(ii),USM_name,PlantXml,SolXml,NomNum,VarNum,SoilVar,1);
                Ymn=RunChangeSoil(Paranum(ii),USM_name,PlantXml,SolXml,NomNum,VarNum,SoilVar,-1);
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
                Yin(ii,:)=Yi(ii,:)/sqrt(Yi(ii,:)*Yi(ii,:)');
            end
            H=[H,Yi];
            Hn=[Hn,Yin];
        end
    end
end
Fish=H*H';
CF=cond(Fish);
FishN=Hn*Hn';
%% PART 2 - optimality problem
    close all;
    ParamNames={'splaimax';'afpf'};
    Paranum=ListPara(ParamNames,PlantXml);
    Pnom=ParaNominal(Paranum,PlantXml);
    Pmin=ParMin(PlantXml,Paranum);
    Pmax=ParMax(PlantXml,Paranum);
    space=5;
    Valmtrix=Range2Vec( Pmin,Pmax,space );
    points=10^4;
    Pmin=[0.7,0.65];
    Pmax=[1.2,0.65];
    P1=linspace(Pmin(1),Pmax(1),8);
    P2=linspace(Pmin(2),Pmax(2),1);
%     P3=linspace(Pmin(3),Pmax(3)-0.01,6);
    Pmat=combvec(P1,P2);
% Pmax(3)=0.97;
%     Pmat=Pmin+rand(2,15).*(Pmax-Pmin);
    J=zeros(1,length(P1)*length(P2));
    Blue=zeros(1,length(P1)*length(P2));
    d1=zeros(1,length(P1)*length(P2));
%     P=[0.505,.7];
for ii=1:length(Pmat)    
    P=Pmat(:,ii);
    TY=[];
    if ii<=1
        Tm=[];
    end
    figure();
    for i=1:n1
        for j=1:n2
            %set treatment file
            IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
            FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
            LfRVec=[Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Do, yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Time,Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Value];
            TreatInitIrFe(IrriMat,FertMat,TecXml);
            TreatInitLr(LfRVec,TecXml);
             %get simulation result
             [Y,~,T]=RunMultiChange(Paranum,USM_name,PlantXml,PlantXmlVar,P);
             subplot(n1,n2,n2*(i-1)+j);
             plot(T,Y);
             hold on;
            for k=1:n3
                Stimes=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement)).DOY;
                SStat=1*ones(1,length(Stimes));   
                Yndat=(ResMat2Vec(Y,Stimes,SStat))';
                ny=length(Yndat);
                TY=[TY; [i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),Stimes',Yndat]];
                 YmeasDat=GetMeasData(Dolev,Years(i),Treatments(j),repeats(k) ,measurement);
%                  YmeasDat(:,1)=YmeasDat(:,1)+yeardays(double(Years(i))-1)-SimStartDay+1;
                 nym= length(YmeasDat);
                 if ii<=1
                    Tm=[Tm;  [i*ones(nym,1),j*ones(nym,1),k*ones(nym,1),YmeasDat]];
                 end
                 plot(YmeasDat(:,1),YmeasDat(:,2),'ro');
            end
              xlabel 't[Day of year]';
             ylabel 'LAI';
             title(strcat(Years(i),Treatments(j)));
        end
    end
    if ii<=1
        Erd=TYDmean(Tm);
    end
    for i=1:n1
        for j=1:n2
            subplot(n1,n2,n2*(i-1)+j);
            Er=Er2sr(Erd,i,j);
            errorbar(Er(:,1),Er(:,2),Er(:,3),'k');
        end
    end
    TYY=unique(TY,'rows');
    J(ii)=sum((Tm(:,5)-TY(:,5)).^2/mean(Tm(:,5))^2);
    d1(ii)=Index_d1(TYY(:,5),Erd(:,4),mean(Erd(:,4))); %כאן צריך ווקטורים לכל המדגם - כל
    Blue(ii)=BLU_ERROR(TYY(:,5),Erd(:,4),Erd(:,5));
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
