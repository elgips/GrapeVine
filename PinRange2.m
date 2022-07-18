function x = PinRange2(P,Pmin,Pmax)
    x=1;
    n=length(P);
    for i=1:n
        x=x*(P(i)<=Pmax(i)&P(i)>=Pmin(i));
    end