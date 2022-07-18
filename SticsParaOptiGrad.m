function [f,g] = SticsParaOptiGrad(ParamNamesPlant,ParamNamesSoil,ParamVals)
%A function that get a list of parameters and return an objective function
%value for fmincon function, based on stics model runs
%   INPUT -SOIL parameters list, plantparameter list
%% INIT And Sens of plant
load DolevStruct.mat;
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
measurement=["LAI","SWF"];
n3=length(repeats);
% n3=length(repeats);
% n3=1;
%% model INIT
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
SoilXml='C:\Javastics\WORKSPACE\sols.xml';
SoilNameVar='SandyLoamDolevVar';
%%  optimality problem
%% PLANT parameters
np=length(ParamNamesPlant);
 ParanumPlant=ListPara(ParamNamesPlant,PlantXml);
 ParValPlant=ParamVals(1:np);
%     Pnom=ParaNominal(ParanumPlant,PlantXml);
%     Pmin=ParMin(PlantXml,ParanumPlant);
%     Pmax=ParMax(PlantXml,ParanumPlant);
%% Soil Parameters
%  np=length(ParamNamesSoil);
ParanumSoil=ListSoilPara(ParamNamesSoil,28,SoilXml);
ParValSoil=ParamVals(np+1:end);
%% 
close all;
style={'or'
'*k'};
% % measlable=strings(length(measurement),1);
% % simlable=strings(length(measurement),1);
% %     for l=1:length(measurement)
% %     simlable(l,:)=strcat(measurement(l)," simulation");
% %     measlable(l,:)=strcat(measurement(l)," measurments");
% %     end
% %     PlLable=[simlable;measlable];
%% RUN MODEL
TY=[];
Tm=[];
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
        for l=1:length(measurement)
            figure(l);
            subplot(n1,n2,n2*(i-1)+j);
            plot(T(730-SimStartDay+1-365+1:end),Y((730-SimStartDay+1-365+1:end),l));
            xlabel 't[Day of year]';
            ylabel(measurement(l));
            title(strcat(measurement(l),Years(i),Treatments(j)));
            hold on;
        for k=1:n3
            Stimes=[];
            SStat=[];
            St=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
            Stimes=[Stimes,St];
            %Ss=1*ones(1,length(St));
            SStat=[SStat,l*ones(1,length(St))];
            Yndat=(ResMat2Vec(Y,Stimes,SStat))';
            ny=length(Yndat);
            TY=[TY;i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),Stimes',Yndat,SStat'];
            YmeasDat=GetMeasData(Dolev,Years(i),Treatments(j),repeats(k) ,measurement(l));
            %                  YmeasDat(:,1)=YmeasDat(:,1)+yeardays(double(Years(i))-1)-SimStartDay+1;
            nym= length(YmeasDat);
            Tm=[Tm;  [i*ones(nym,1),j*ones(nym,1),k*ones(nym,1),YmeasDat,l*ones(nym,1)]];
%             plot(YmeasDat(:,1),YmeasDat(:,2),char(style(l)));
                %% Nominal Run
        end
            %                 Stimes=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
            %                 SStat=1*ones(1,length(Stimes));

        end
    end
%     legend(PlLable,'Location','northeast');
%     legend('Location','northeast')
%     legend('boxoff')
%     if ii<=1  
end
Erd=TYDmean(Tm);
    for i=1:n1
        for j=1:n2
            for l=1:length(measurement)
                figure(l);
            subplot(n1,n2,n2*(i-1)+j);
            Er=Er2sr(Erd,i,j,l);
            errorbar(Er(:,1),Er(:,2),Er(:,3),char(style(l)));
        end
        end
    end
%     TYY=unique(TY,'rows');
%     J(ii)=sum((Tm(7:end,5)-TY(7:end,5)).^2/mean(Tm(7:end,5))^2)/max(Tm(7:end,5));%+sum((Tm(1:6,5)-TY(1:6,5)).^2/mean(Tm(1:6,5))^2)/max(Tm(1:6,5));%sum((Tm(:,5)-TY(:,5)).^2/mean(Tm(:,5))^2);
Q=0;
for l=1:length(measurement)
    Q=Q+sum((Tm((Tm(:,6)==l),5)-TY((TY(:,6)==l),5)).^2)/max(Tm((Tm(:,6)==l),5))/length(TY((TY(:,6)==l),5));
end
f=Q;%(ParamVals(1)-1.2).^2+(ParamVals(2)-39).^2;
%%  Grad
if nargout > 1
    Jgrad=zeros(1,length(ParamVals));
    eps=0.001;
    %% PLANT parameters
    np=length(ParamNamesPlant);
    ParanumPlant=ListPara(ParamNamesPlant,PlantXml);
    ParValPlant=ParamVals(1:np);
    %     Pnom=ParaNominal(ParanumPlant,PlantXml);
    Pmin=ParMin(PlantXml,ParanumPlant);
    Pmax=ParMax(PlantXml,ParanumPlant);
    Prange=Pmax-Pmin;
    PdPlant=zeros(2,np);
    for i=1:np
        if ParValPlant(i)-eps*Prange(i)<=Pmin(i)
            PdPlant(:,i)=[ParValPlant(i);ParValPlant(i)+eps*Prange(i)];
        elseif ParValPlant(i)+eps*Prange(i)>=Pmax(i)
            PdPlant(:,i)=[ParValPlant(i)-eps*Prange(i);ParValPlant(i)];
        else
            PdPlant(:,i)=[ParValPlant(i)-Prange(i)*eps/2;ParValPlant(i)+Prange(i)*eps/2];
        end
    end
    %% Soil Parameters
    ns=length(ParamNamesSoil);
    ParanumSoil=ListSoilPara(ParamNamesSoil,28,SoilXml);
    PminSoil=ParMin(SoilXml,ParanumSoil);
    PmaxSoil=ParMax(SoilXml,ParanumSoil);
    PrangeSoil=PmaxSoil-PminSoil;
    ParValSoil=ParamVals(np+1:end);
    PdSoil=zeros(2,ns);
    for i=1:ns
        if ParValSoil(i)-eps*PrangeSoil(i)<=PminSoil(i)
            PdSoil(:,i)=[ParValSoil(i);ParValSoil(i)+eps*PrangeSoil(i)];
        elseif ParValSoil(i)+eps*PrangeSoil(i)>=PmaxSoil(i)
            PdSoil(:,i)=[ParValSoil(i)-eps*PrangeSoil(i);ParValSoil(i)];
        else
            PdSoil(:,i)=[ParValSoil(i)-PrangeSoil(i)*eps/2;ParValSoil(i)+PrangeSoil(i)*eps/2];
        end
    end
    %%
    % close all;
    % style={'or'
    % '*k'};
    % measlable=strings(length(measurement),1);
    % simlable=strings(length(measurement),1);
    %     for l=1:length(measurement)
    %     simlable(l,:)=strcat(measurement(l)," simulation");
    %     measlable(l,:)=strcat(measurement(l)," measurments");
    %     end
    %     PlLable=[simlable;measlable];
    %% RUN MODEL
    for ii=1:np
        J=[0 0];
        for jj=1:2
            PVPV=ParValPlant;
            PVPV(ii)=PdPlant(jj,ii);
            TY=[];
            Tm=[];
            %         figure();
            for i=1:n1
                for j=1:n2
                    %set treatment file
                    %         disp(ParamVals);
                    IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
                    FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
                    LfRVec=[Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Do, yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Time,Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Value];
                    TreatInitIrFe(IrriMat,FertMat,TecXml);
                    TreatInitLr(LfRVec,TecXml);
                    %get simulation result
                    [Y,~,~,T]=RunChanges(ParanumPlant,ParanumSoil,USM_name,PlantXml,PlantXmlVar,SoilXml,PVPV,ParValSoil,SoilNameVar);
                    disp(100*((ii-1)/np+(jj-1)/np/2+(i-1)/np/2/n1+(j-1)/np/2/n1/n2));
                    disp(f);
                    %                 subplot(n1,n2,n2*(i-1)+j);
                    %                 plot(T(730-SimStartDay+1-365+1:end),Y((730-SimStartDay+1-365+1:end),:));
                    %                 hold on;
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
                        %                 Stimes=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
                        %                 SStat=1*ones(1,length(Stimes));
                        Yndat=(ResMat2Vec(Y,Stimes,SStat))';
                        ny=length(Yndat);
                        TY=[TY; [i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),Stimes',Yndat,SStat']];
                        for l=1:length(measurement)
                            YmeasDat=GetMeasData(Dolev,Years(i),Treatments(j),repeats(k) ,measurement(l));
                            %                  YmeasDat(:,1)=YmeasDat(:,1)+yeardays(double(Years(i))-1)-SimStartDay+1;
                            nym= length(YmeasDat);
                            Tm=[Tm;  [i*ones(nym,1),j*ones(nym,1),k*ones(nym,1),YmeasDat,l*ones(nym,1)]];
                            %                         plot(YmeasDat(:,1),YmeasDat(:,2),char(style(l)));
                        end
                    end
                    
                    %                 xlabel 't[Day of year]';
                    %                 ylabel 'LAI,SWF';
                    %                 title(strcat(Years(i),Treatments(j)));
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
            Q=0;
            for l=1:length(measurement)
                Q=Q+sum((Tm((Tm(:,6)==l),5)-TY((TY(:,6)==l),5)).^2)/max(Tm((Tm(:,6)==l),5))/length(TY((TY(:,6)==l),5));
            end
            J(jj)=Q;
        end
        Jgrad(ii)=(J(2)-J(1))/(Prange(ii)*eps);
    end
    %%
    for ii=1:ns
        J=[0 0];
        for jj=1:2
            PVSV=ParValSoil;
            PVSV(ii)=PdSoil(jj,ii);
            TY=[];
            Tm=[];
            %         figure();
            for i=1:n1
                for j=1:n2
                    %set treatment file
                    %         disp(ParamVals);
                    IrriMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data ;yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Irrigation.Time.Data]];
                    FertMat=[[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data ; Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Value.Data],[Dolev.Temporal.Years.(char(strcat('Y',num2str(double(Years(i))-1)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data ; yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Fertigation.Time.Data]];
                    LfRVec=[Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Do, yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Time,Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).LeafRemoval.Value];
                    TreatInitIrFe(IrriMat,FertMat,TecXml);
                    TreatInitLr(LfRVec,TecXml);
                    %get simulation result
                    [Y,~,~,T]=RunChanges(ParanumPlant,ParanumSoil,USM_name,PlantXml,PlantXmlVar,SoilXml,ParValPlant,PVSV,SoilNameVar);
                    disp(100*((ii-1)/np+(jj-1)/ns/2+(i-1)/ns/2/n1+(j-1)/ns/2/n1/n2));
                    %                 subplot(n1,n2,n2*(i-1)+j);
                    %                 plot(T(730-SimStartDay+1-365+1:end),Y((730-SimStartDay+1-365+1:end),:));
                    %                 hold on;
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
                        %                 Stimes=yeardays(double(Years(i))-1)-SimStartDay+1+Dolev.Temporal.Years.(char(strcat('Y',Years(i)))).General.Treatments.(char(Treatments(j))).Measurements.(char(repeats(k))).(char(measurement(l))).DOY;
                        %                 SStat=1*ones(1,length(Stimes));
                        Yndat=(ResMat2Vec(Y,Stimes,SStat))';
                        ny=length(Yndat);
                        TY=[TY; [i*ones(ny,1),j*ones(ny,1),k*ones(ny,1),Stimes',Yndat,SStat']];
                        for l=1:length(measurement)
                            YmeasDat=GetMeasData(Dolev,Years(i),Treatments(j),repeats(k) ,measurement(l));
                            %                  YmeasDat(:,1)=YmeasDat(:,1)+yeardays(double(Years(i))-1)-SimStartDay+1;
                            nym= length(YmeasDat);
                            Tm=[Tm;  [i*ones(nym,1),j*ones(nym,1),k*ones(nym,1),YmeasDat,l*ones(nym,1)]];
                            %                         plot(YmeasDat(:,1),YmeasDat(:,2),char(style(l)));
                        end
                    end
                    
                    %                 xlabel 't[Day of year]';
                    %                 ylabel 'LAI,SWF';
                    %                 title(strcat(Years(i),Treatments(j)));
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
            Q=0;
            for l=1:length(measurement)
                Q=Q+sum((Tm((Tm(:,6)==l),5)-TY((TY(:,6)==l),5)).^2)/max(Tm((Tm(:,6)==l),5))/length(TY((TY(:,6)==l),5));
            end
            J(jj)=Q;
        end
        Jgrad(np+ii)=(J(2)-J(1))/(PrangeSoil(ii)*eps);
    end
    g=Jgrad;
    disp(g);
    disp(g);
end
