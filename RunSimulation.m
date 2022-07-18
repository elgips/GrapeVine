function [Y,Heads] = RunSimulation(USM_name,PlantXml,SoilNom,InitXml,Place,Yrs,TreatXml)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    N=nargin;
    if N>0
    %% set USM
        USMS=xmlread('C:\Javastics\WORKSPACE\usms.xml');% load USMS FILE
        %loading USM node
        Vini=USMS.getElementsByTagName('usm').item(FindItemNum('usm',{USM_name},USMS)); % node to our chosen USM
        % set USM Name in run batch file
        WriteToBatch('C:\Javastics\eximp.bat',USM_name);
        %  Set Plant
        if N>1
            %plant
            Vini.getElementsByTagName('fplt').item(0).setTextContent(PlantXml);
            if N>2
                %Soil
                Vini.getElementsByTagName('nomsol').item(0).setTextContent(SoilNom);
                if N>3     
                    %Init
                    Vini.getElementsByTagName('finit').item(0).setTextContent(InitXml);
                    if N>4
                        Vini.getElementsByTagName('fclim1').item(0).setTextContent(string(strcat(Place,'.',Yrs(1))));
                        Vini.getElementsByTagName('fclim2').item(0).setTextContent(string(strcat(Place,'.',Yrs(2))));
                        if N>5
                            Vini.getElementsByTagName('ftec').item(0).setTextContent(TreatXml);
                        end
                    end
                end
            end
        end
    end
    %% Write USMS
    xmlwrite('C:\Javastics\WORKSPACE\usms.xml',USMS);
    %% RUN SIMULATION
    system('C:\Javastics\eximp.bat >output.txt');
    %% get output
    OUTPUT=importdata(char(strcat('C:\Javastics\WORKSPACE\mod_s',USM_name,'.sti')),';');
    Y=OUTPUT.data;
    Heads=OUTPUT.colheaders;
end


function ItemNumVec = FindItemNum(Tag,ItemsNames,xmlNode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ItemsNames);
    ItemNumVec=ones(N,1)*(-1);
    Items=xmlNode.getElementsByTagName(Tag);
    for i=0:Items.getLength-1
        ItemNumVec=ItemNumVec+((i+1)*double(strcmp(Items.item(i).getAttribute('nom'),ItemsNames)))';
    end
end

function [] = WriteToBatch(BatchFile,USM_name)
    %Summary - gets betchfile and USM name, and returns updated batch file
    %running the specific USM item
    %INPUT:
    %BatchFile - *.bat file to run USMfor STICS model
    %USM_name - names of usm item
    Bat=fopen(BatchFile,'w');
    BatchString=string(strcat('C:\Javastics\JavaSticsCmd.exe --run WORKSPACE',{' '} ,USM_name));
    fprintf(Bat,'%s',BatchString);
    fclose(Bat);
end