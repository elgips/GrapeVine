function Nb = GetNb(Y)
	%A function that get JavaStics output file and retrieve number of berries scalar value
	%INPUT: Y - JavaStics output file (time vector)
	%OUTPUT	Nb - number of berries per area (num/ha)
	Nb=max(Y);
end