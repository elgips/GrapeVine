function M =Range2Vec( Pmin,Pmax,Space )
    n=length(Pmin);
    M=zeros(n,Space);
    for i=1:n
        M(i,:)=linspace(Pmin(i),Pmax(i),Space);
    end
end

