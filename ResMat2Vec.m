function y = ResMat2Vec(DYDP,Stimes,SPara)
 % THIS FUNCTION TAKES A RESULT MATRIX, AND TURNS IT TO A VECTOR OF DESIRED STATES AT DESIRED TIMES   
    n=length(SPara);
    y=zeros(1,n);
    for i=1:n
        y(i)=DYDP(Stimes(i),SPara(i));
    end
end

