function BW = TW2BW(TW,WC,Nb)
	%A function that make berry weight time-vector from Total weight per ha time vector and number of berries per ha
	%INPUT: TW - total berry dry weight per area(ton per ha)
    %              WC- fruit water content [%]
	%		Nb - number of berries per area (num/m^2)
	%OUTPUT:BW - 100 berries weight gram
	BW=TW/(Nb/100)/10000*1000*1000./(1-WC); %ton/ha/(num/m^2)/(m^2/ha)/(kg/ton)/(gr/kg)/(Dry%)
end