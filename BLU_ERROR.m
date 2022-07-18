function BluE = BLU_ERROR(ModVec,MeasVec,MeasStd)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    MeasStdNoze=MeasStd(MeasStd>0);
    Minstd=min(MeasStdNoze);
    MeasStd=MeasStd+(MeasStd==0)*Minstd; %replace zero variance with min value of the vector
    BluE=sum(((ModVec-MeasVec).^2)./(MeasStd.^2));

end

