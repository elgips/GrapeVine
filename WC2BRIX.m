function TSS = WC2BRIX(DryWBerry,BerryWContent)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a_tot2seed=0.123850865;	
a_tot2skin=0.016737528;
b_tot2seed=0.057537016;
b_tot2skin=-0.008075162;
FreshWBerry=DryWBerry./((1-BerryWContent).*(BerryWContent~=0)+(BerryWContent==0));
MwetPulp=(1-a_tot2seed-a_tot2skin)*FreshWBerry-(b_tot2seed-b_tot2skin).*(FreshWBerry~=0);
Mwater=FreshWBerry.*BerryWContent;
MdryPulp=MwetPulp-Mwater;
TSS=MdryPulp./(MwetPulp+(MwetPulp==0));


end

