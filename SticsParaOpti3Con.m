function F = SticsParaOpti3Con(ParanumPlant,ParanumSoil,ParamVals,Pmin,Pmax)
%A function that get a list of parameters and return an objective function
%value for fmincon function, based on stics model runs
%   INPUT -SOIL parameters list, plantparameter list
%% INIT And Sens of plant
global x;
Dolev=x;
VarList=["lai(n)","swfac","mafruit","nfruit(nboite)","H2Orec"];
VarFile='C:\Javastics\WORKSPACE\var.mod';
UpdateVarList(VarFile,VarList);
%init data
SimStartDay=50;
Years=["2009","2010","2011"];%,"2012"];
n1=length(Years);
Treatments=["A","B","C","D","E"];
n2=length(Treatments);
repeats=["R1","R2","R3","R4"];
measurement=["LAI","SWP","W100Ber","BPV","Brix"];
n3=length(repeats);
% n3=length(repeats);
% n3=1;
Ps1=ParamVals(end-1);
Ps2=ParamVals(end);
%% model INIT
%USM
USM_name='VINE_ALPHA';
%INIT XML
% InitXml='vigne_ini.xml';
%SOILNOM
% SoilNom='SandyLoamDolevAlpha';
% original plant param file
PlantXml='MERILO_plt.xml';
% param file with a change
PlantXmlVar='vin_cs_plt.xml';
% TREAT XMLFILE
TecXml='vigne_tec.xml';
SoilXml='C:\Javastics\WORKSPACE\sols.xml';
SoilNameVar='SandyLoamDolevVar';
% Q=0;
%%  optimality problem
%% PLANT parameters
% np=length(ParamNamesPlant(1));
np=length(ParanumPlant);
%  ParanumPlant=ListPara(ParamNamesPlant,PlantXml);
 ParValPlant=ParamVals(1:np);
%     Pnom=ParaNominal(ParanumPlant,PlantXml);
%     Pmin=ParMin(PlantXml,ParanumPlant);
%     Pmax=ParMax(PlantXml,ParanumPlant);
%% Soil Parameters
%  np=length(ParamNamesSoil);
% ParanumSoil=ListSoilPara(ParamNamesSoil,28,SoilXml);
ParValSoil=ParamVals(np+1:end-2);
%% 
close all;
style={'or'
'*k'
'or'
'*k'};
W=[1.5,1,1,1];
% % measlable=strings(length(measurement),1);
% % simlable=strings(length(measurement),1);
% %     for l=1:length(measurement)
% %     simlable(l,:)=strcat(measurement(l)," simulation");
% %     measlable(l,:)=strcat(measurement(l)," measurments");
% %     end
% %     PlLable=[simlable;measlable];
%% RUN MODEL
Q=0;
% TY=[];
% Tm=[];
% Ys2s=[];
% Hs2s=[];
figure();
for i=1:n1
    for j=1:n2
        %set treatment file
        disp(ParamVals);
        IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
        FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
        LfRVec=[Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Do, yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Time,Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Value];
        TreatInitIrFe(IrriMat,FertMat,TecXml);
        TreatInitLr(LfRVec,TecXml);
        %get simulation result
        [Y,~,~,T]=RunChanges(ParanumPlant,ParanumSoil,USM_name,PlantXml,PlantXmlVar,SoilXml,ParValPlant,ParValSoil,SoilNameVar);
        Nb = GetNb(Y(:,4));% number of berries
        Y(:,3)=TW2BW(Y(:,3),Y(:,5),Nb);%fresh 100 berries weight
        Y(:,5)=WC2BRIX(Y(:,3),Y(:,5));
        
        
        for l=1:length(measurement)
            Tm=[];
%             TY=[];
            TYY=[];
            figure(l);
            subplot(n1,n2,n2*(i-1)+j);
            plot(T(730-SimStartDay+1-365+1:end),Y((730-SimStartDay+1-365+1:end),l));
            xlabel 't[Day of year]';
            ylabel(measurement(l));
            hold on;
            for k=1:n3
                Stimes=[];
                SStat=[];
                St=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
                Stimes=[Stimes,St];
                %Ss=1*ones(1,length(St));
                SStat=[SStat,l*ones(1,length(St))];                
                if strcmp(measurement(l),"BPV")
                    Yndat=max(Y(:,4));
                else
                    Yndat=(ResMat2Vec(Y,Stimes,SStat))';
                end
                %             ny=length(Yndat);
                %                 TY=[i*ones(ny,1),j*ones(ny,1),Stimes',Yndat,SStat'];-
                if strcmp(measurement(l),"BPV")
                    TY=[unique(Stimes),Yndat];
                else
                    TY=[Stimes',Yndat];
                end
                TYY=sortrows(unique([TYY;TY],'rows'));
                YmeasDat=GetMeasData(Dolev,Years(i),Treatments(j),repeats(k) ,measurement(l));
                %                  YmeasDat(:,1)=YmeasDat(:,1)+yeardays(double(Years(i))-1)-SimStartDay+1;
                if strcmp(measurement(l),"SWP")
                    YmeasDat(:,2)=SWP2SWF(YmeasDat(:,2),Ps1,Ps2);
                end
                
                %             end
                nym= length(YmeasDat);
                Tm=[Tm;  [i*ones(nym,1),j*ones(nym,1),k*ones(nym,1),YmeasDat,l*ones(nym,1)]];
            end
            %             plot(YmeasDat(:,1),YmeasDat(:,2),char(style(l)));
%% Nominal Run
            %                 Stimes=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
            %                 SStat=1*ones(1,length(Stimes));
               Erd=TYDmean2(Tm);
               TYY(:,1)=TYY(:,1)-(yeardays(double(Years(i))-1)-SimStartDay+1);
               figure(l);
               subplot(n1,n2,n2*(i-1)+j);
%                if strcmp(measurement(l),"SWP")
%                    Ys2s=[Ys2s (TYY(:,2))'];
%                    Hs2s=[Hs2s S2S_SA(Ys2s,ParamVals(end-1),ParamVals(end),eps)];
%                end
%                Er=Er2sr(Erd,i,j,l);
               errorbar(Erd(:,1),Erd(:,2),Erd(:,3),char(style(l)));
               Residual=Erd(:,2)-TYY(:,2);
               Q=Q+W(l)*sum(Residual.^2)/max(Erd(:,1))/length(Residual);
               D1=d1(Tm,TYY);
               D2=d2(Tm,TYY);
%                dim = [.2+(i-1)/n1 .5+(i-1)/n1 .3+(j-1)/n2 .3+(j-1)/n2];
%                str = strcat('d1=',num2str(d1));
%                annotation('textbox',dim,'String',str,'FitBoxToText','on');
               title([strcat(measurement(l),Years(i),Treatments(j));strcat("d1=",num2str(D1));strcat("d2=",num2str(D2))]);
        end
    end
end
%     legend(PlLable,'Location','northeast');
%     legend('Location','northeast')
%     legend('boxoff')
%     if ii<=1  
% end
% Erd=TYDmean(Tm);
%     for i=1:n1
%         for j=1:n2
%             for l=1:length(measurement)
%                 figure(l);
%             subplot(n1,n2,n2*(i-1)+j);
%             Er=Er2sr(Erd,i,j,l);
%             errorbar(Er(:,1),Er(:,2),Er(:,3),char(style(l)));
%         end
%         end
%     end
%     TYY=unique(TY,'rows');
    
%     J(ii)=sum((Tm(7:end,5)-TY(7:end,5)).^2/mean(Tm(7:end,5))^2)/max(Tm(7:end,5));%+sum((Tm(1:6,5)-TY(1:6,5)).^2/mean(Tm(1:6,5))^2)/max(Tm(1:6,5));%sum((Tm(:,5)-TY(:,5)).^2/mean(Tm(:,5))^2);

% for l=1:length(measurement)
%     Q=Q+sum((Tm((Tm(:,6)==l),5)-TY((TY(:,6)==l),5)).^2)/max(Tm((Tm(:,6)==l),5))/length(TY((TY(:,6)==l),5));
% Q=Q+(sum(log(Tm((Tm(:,6)==l),5)./TY((TY(:,6)==l),5)).^2))/max(Tm((Tm(:,6)==l),5))/length(TY((TY(:,6)==l),5));
% end
% Hs2sN(1,:)=Hs2s(1,:)/sqrt(Hs2s(1,:)*Hs2s(1,:)');
% Hs2sN(2,:)=Hs2s(2,:)/sqrt(Hs2s(2,:)*Hs2s(2,:)');
F=Q+(1-PinRange2(ParamVals(1:end-2),Pmin,Pmax))*10^7;%(ParamVals(1)-1.2).^2+(ParamVals(2)-39).^2;
disp(F);
end

