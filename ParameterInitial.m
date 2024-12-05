function ParameterInitial()
    global Global
    %% Parameters of BOSPSO
    Global.Gen   = 50;         %%%Population generation of BOSPSO
    Global.N     = 100;        %%%Population size
    Global.n     = 5;          %%%Guidance strength

    %% Problem paramters
    Global.Problem = 'TP1';
    Global.D     = 10;
    Global.T     = 100;        %%%Total times
    Global.alpha = 1;          %%%Ratio of objective value and switch cost
    Global.m     = 5;          %%%Problem peaks
    Global.t     = 1;          %%%Initialize time step t
    Global.mu    = 40;         %%%Threshold of the obejctive performance
    Hmin = 30; Hmax = 70; Hini = 50; Hphi = [1,10];   phis = 2;
    Wmin = 1;  Wmax = 12; Wini = 6;  Wphi = [0.1,1];  alp  = 0.04;
    Global.Lower = zeros(1,Global.D);
    Global.Upper = 30*ones(1,Global.D);
    Ct = repmat(linspace(1,30,Global.T)',1,Global.D);
    Ht = zeros(100,Global.m); Ht(1,:) = Hini; Hr = rand(100,Global.m)*2-1;
    Wt = zeros(100,Global.m); Wt(1,:) = Wini; Wr = rand(100,Global.m)*2-1;
    for i = 2:Global.T
        for j = 1:Global.m
            derH   = alp*(Hphi(2)-Hphi(1))*Hr(i,j)*phis;
            Ht(i,j)= min(max(Hmin,Ht(i-1,j)+derH),Hmax);
            derW   = alp*(Wphi(2)-Wphi(1))*Wr(i,j)*phis;
            Wt(i,j)= min(max(Wmin,Wt(i-1,j)+derW),Wmax);    
        end
    end
    Global.Ct = Ct; Global.Ht = Ht; Global.Wt = Wt;
end