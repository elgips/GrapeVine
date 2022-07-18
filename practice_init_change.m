%% check init change
segmentName='plante';
item_name='zrac0';
A=xmlread('vigne_ini.xml');
B=A.getElementsByTagName(segmentName).item(0).getElementsByTagName(item_name).item(0).getTextContent;
A.getElementsByTagName(segmentName).item(0).getElementsByTagName(item_name).item(0).setTextContent('61');
%% sol chnage
segmentName='sol';
item_name='hinit';
hori=4-1;
Value='3.8000';
B=A.getElementsByTagName(segmentName).item(0).getElementsByTagName(item_name).item(0).getElementsByTagName('horizon').item(hori).getTextContent;
A.getElementsByTagName(segmentName).item(0).getElementsByTagName(item_name).item(0).getElementsByTagName('horizon').item(hori).setTextContent(Value);
%%
xmlwrite('vigne_initVar.xml',A);