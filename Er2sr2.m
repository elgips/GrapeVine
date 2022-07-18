function [EsPartial] = Er2sr2(Erd,Yi,Ti,Li )
%generate time series for specific treatment , year and measurement
%   Detailed explanation goes here
   EsPartial=  (Erd(:,6)==Li).*(Erd(:,1)==Yi).*(Erd(:,2)==Ti).*Erd;
EsPartial=EsPartial(find(EsPartial(:,1),1,'first'):find(EsPartial(:,1),1,'last'),3:5);
end

