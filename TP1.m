classdef TP1 < handle
    methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec, Curx)
            global Global
            PopObj = zeros(size(PopDec,1), 2);
            m      = Global.m;
            Pref   = zeros(size(PopDec,1),m);
            Ct = Global.Ct; Ht = Global.Ht; Wt = Global.Wt;
            for i = 1:m
                Pref(:,i) = Ht(Global.t,i)-Wt(Global.t,i)*vecnorm(PopDec-repmat(Ct(Global.t,:),size(PopDec,1),1), 2, 2);
            end
            PopObj(:,1) = max(Pref,[],2);
            PopObj(:,2) = vecnorm(PopDec-repmat(Curx,size(PopDec,1),1), 2, 2);
        end
    end
end