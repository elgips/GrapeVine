function ItemNumVec = FindItemNum(Tag,ItemsNames,xmlNode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N=length(ItemsNames);
    ItemNumVec=ones(N,1)*(-1);
    Items=xmlNode.getElementsByTagName(Tag);
    for i=0:Items.getLength-1
        ItemNumVec=ItemNumVec+((i+1)*double(strcmp(Items.item(i).getAttribute('nom'),ItemsNames)))';
    end
end

