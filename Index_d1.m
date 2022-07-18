function d1 = Index_d1(ModVec,MeasVec,MeasMean)
    % Calculates Index of agreement -d1
    % using meas and model data (including meas mean and std)
    d1=1-sum((ModVec-MeasVec).^2)/sum((abs(MeasVec-MeasMean)+abs(ModVec-MeasMean)).^2);
end

