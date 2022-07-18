function D2 = d2(Tm,TYY)
	n=size(TYY);
    n=n(1);
	mone=0;
	machane=0;
	memu=mean(Tm(:,5));
	for k=1:n
        sd=std(Tm(Tm(:,4)==TYY(k,1),5));
		mone=mone+sum(max(0,(Tm(Tm(:,4)==TYY(k,1),5)-TYY(k,2)).^2-sd^2));
		machane=machane+sum((abs(Tm(Tm(:,4)==TYY(k,1),5)-memu)+abs(TYY(k,2)-memu)).^2);
	end
	D2=1-mone/machane;
end