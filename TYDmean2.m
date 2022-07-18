function [Erd] = TYDmean2( T )
%% Calclute Mean and Standard Deviation of indexed measurements data
   Nt=length(unique(T(:,4)));
    Erd=zeros(Nt,3);
    Time=unique(T(:,4));
    for k=1:length(Time)
%                 length(find(Erd(:,1)))+1;
        Erd(k,:)=[Time(k),mean(T((T(:,4)==Time(k)),5)),std(T((T(:,4)==Time(k)),5))];
    end
end