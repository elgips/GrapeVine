function [] = UpdateVarList( VarFile,VarVec )
%UpdateVarList a function that gets a var.mod file and a vector of variable
%names and updates the var.mod file so it will include the variable names
%vector.
%  INPUT:
%VarFile - fille name and directory of Var.mod file of the STICS model
%Var Vec - a vector of states names to be included in the Var.mod file.
Var=fopen(VarFile,'w');
n=length(VarVec);
for i=1:n
fprintf(Var,'%s\n',char(VarVec(i)));
end
fclose(Var);
end

