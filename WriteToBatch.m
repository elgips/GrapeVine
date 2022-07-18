function [] = WriteToBatch(BatchFile,USM_name)
    %Summery - gets betchfile and USM name, and returns updated batch file
    %running the specific USM item
    %INPUT:
    %BatchFile - *.bat file to run USMfor STICS model
    %USM_name - names of usm item
    Bat=fopen(BatchFile,'w');
    BatchString=string(strcat('C:\Javastics\JavaSticsCmd.exe --run WORKSPACE',{' '} ,USM_name));
    fprintf(Bat,'%s',BatchString);
    fclose(Bat);
end