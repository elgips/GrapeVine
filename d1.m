function D1 = d1(Tm,TYY)
	n=size(TYY);
    n=n(1);
	mone=0;
	machane=0;
	memu=mean(Tm(:,5));
	for k=1:n
		mone=mone+sum((Tm(Tm(:,4)==TYY(k,1),5)-TYY(k,2)).^2);
		machane=machane+sum((abs(Tm(Tm(:,4)==TYY(k,1),5)-memu)+abs(TYY(k,2)-memu)).^2);
	end
	D1=1-mone/machane;
end