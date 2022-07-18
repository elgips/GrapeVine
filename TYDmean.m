function [Erd] = TYDmean( T )
%% Calclute Mean and Standard Deviation of indexed measurements data
   Nt=length(unique(T(:,4)));
    Erd=zeros(max(T(:,1))*max(T(:,2))*Nt,6);
    for i=1:max(T(:,1))
        for j=1:max(T(:,2))
            for l=1:max(T(:,5))
            Ts=(T(:,6)==l).*(T(:,1)==i).*(T(:,2)==j).*T;
            range=find(Ts(:,1));
            Ts=Ts(min(range):max(range),:);
            Time=unique(Ts(:,4));
            for k=1:length(Time)
%                 length(find(Erd(:,1)))+1;
                Erd(length(find(Erd(:,1)))+1,:)=[i,j,Time(k),mean(nonzeros((Ts(:,4)==Time(k)).*Ts(:,5))),std(nonzeros((Ts(:,4)==Time(k)).*Ts(:,5))),l];
            end
            end
        end
    end
Erd=Erd(1:find(Erd(:,1),1,'last'),:);
end