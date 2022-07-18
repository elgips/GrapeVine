function SWF = SWP2SWF(SWP,P1,P2)
	SWF=(P2-SWP)./(P2-P1).*(SWP<=P1).*(SWP>=P2)+(SWP>P1);
end