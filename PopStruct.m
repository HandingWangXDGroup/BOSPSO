function Population = PopStruct(PopDec, PopObj, PopVel)
    if isempty(PopDec)
        Population = struct;
    else
        if nargin > 2
            for i=1:size(PopDec,1)
                Population(i).dec = PopDec(i,:);
                Population(i).obj = PopObj(i,:);
                Population(i).vel = PopVel(i,:);
            end
        else
            for i=1:size(PopDec,1)
                Population(i).dec = PopDec(i,:);
                Population(i).obj = PopObj(i,:);
            end
        end
    end
end