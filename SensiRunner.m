function [ RelSensMat ] = SensiRunner(VarVec ,ParamXml ,ParamXmlFileVar,ParamNames ,Stimes ,SStat ,Yrs ,Trt  )
    % SensiRunner - a function that compute Relative Sensitivity Matrix for a
    % given treatment,time, parameters and states.
    % INPUT:
    % VarVec - String array for updating the var file in stics (which states
    % are observed in the stics ouput file).
    %ParamNames - cell array of the nominated parameters for sensitivity
    %analysis.
    %Stimes - Time index vector of the observed states in the stics output
    %file.
    %SStat - State variable index in the STICS MODEL OUTPUT file
    %Yrs - names of the years for the simulation run - a vector of two string,
    %successive years.
    %Trt - treatmeant name (a,b,c,d,e) or other (Z, r etc...) - determins which
    %treatment file to call.
%     ParamXml -  original plant param file
%     ParamXmlFileVar -plant  param file with a change

    %   OUTPUT- 
    % RelSensMat - Relative sensitivity matrix
    %% INIT 
    UpdateVarList( 'C:\Javastics\WORKSPACE\var.mod',VarVec );
    Ynom=RunSimulation(ParamXml);
    Ynom=Ynom(:,5:end);
    [n,m]=size(Ynom);
    Yavg=repmat(mean(Ynom),n,1);%Average Nominal values
    RelSensMat=zeros(length(ParamNames),length(SStat));% matrix for results
    Paranum=ListPara(ParamNames,ParamXml); %retrieve a parameter number list form parameters names list and XML file.
    Pnom=ParaNominal(Paranum,ParamXml); % rerieve a vector of nominal parameters values
end

function [] = UpdateVarList( VarFile,VarVec )
    %UpdateVarList a function that gets a var.mod file and a vector of variable
    %names and updates the var.mod file so it will include the variable names
    %vector.
    %  INPUT:
    %VarFile - fille name and directory of Var.mod file of the STICS model
    %Var Vec - a vector of states names to be included in the Var.mod file.
    Var=fopen(VarFile,'w');
    fprintf(Var,'%s\n',VarVec);
    fclose(Var);
end