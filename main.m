function main()
    global Global
    ParameterInitial()
    %% Performance records
    Curx      = zeros(1,Global.D);
    RFits     = zeros(1,Global.T);
    RCosts    = zeros(1,Global.T);
    NonSatis  = zeros(1,Global.T);
    AllCurx   = zeros(Global.T,Global.D);

    

    %% Start the optimization
    RThreshold= 0;          %%% Initialize r_t^H
    TwoObjs   = zeros(1,2); %%% Record the objective values of the adjancent optimal robust solutions
    while Global.t <= Global.T
        %%% Generate the initial population
        P         = LHS_sam(Global.N, Curx); %%% Latin Hypercube Sampling
        PDec      = decs(P);
        EvalObj   = objs(P);
        PObj      = EvalObj(:,1);
        PreCurx   = Curx; %%%The robust solution deployed at previous time step
        PVel      = zeros(length(P),Global.D);
        Population= PopStruct(PDec, PObj, PVel);
        Pbest      = Population;
        [~,best]   = max(PObj);
        Gbest      = Pbest(best);
        Bs         =  0;  %%% The maximal switch cost 
        Global.DataBase = Population;
    
        %%% Update r_t^H 
        if Global.t == 2
            RThreshold = RThreshold + 0.2;
        elseif Global.t > 1
            RThreshold = RThreshold + (TwoObjs(2)-TwoObjs(1))/TwoObjs(2);
        end

            
        %%% Iteration process
        for gen = 1:Global.Gen-1
            % Calculate the correlation correlation coefficient r
            PopDec = decs(Population);
            PopObj = objs(Population);
            R = corrcoef(PopObj, pdist2(PopDec, PreCurx)); 
            R = R(1,2);
            
            if R < RThreshold
                %Correlation guidance method
                Population = Correlation_Guidance(Population,Pbest,Gbest,PreCurx, R, RThreshold);
            else
                %Diversity increasement method
                Dist = max(pdist2(PopDec, PreCurx));
                if Dist > Bs
                    Bs = Dist;
                end
                Population = Diversity_Increase(Population,Pbest,Gbest,PreCurx, Bs);
            end                
            replace        = objs(Pbest) < objs(Population);
            Pbest(replace) = Population(replace);
            [~,best]       = max(objs(Pbest));
            Gbest          = Pbest(best);
        end   


        %%% optimal robust solution selection
        DB     = Global.DataBase;
        DBDec  = decs(DB);
        Dists  = pdist2(DBDec, PreCurx);
        if Bs ~= 0
            DB(Dists>Bs) = [];
        end
        DBObj  = objs(DB);
        [~, idx] = max(DBObj);
        Curx   = decs(DB(idx));
        AllCurx(Global.t,:) = Curx;

        %%% Performance evaluation in one time step
        RFinObj         = eval([Global.Problem '.obj(Curx, PreCurx)']);
        RFits(Global.t) = RFinObj(1);  
        TwoObjs(1) = TwoObjs(2);
        TwoObjs(2) = RFinObj(1);
        RCosts(Global.t)= RFinObj(2); 
        if RFinObj(1) < Global.mu
            NonSatis(Global.t) = 1;
        end  
        Global.t = Global.t+1;
    end

    %% Performance evaluation across all time steps
    AverFit  = mean(RFits);
    AverCost = mean(RCosts);
    F_ind1   = AverFit-Global.alpha*sum(AverCost);
    N_ind2   = sum(NonSatis);
    disp('######################The performance on F_ind1 indicator is###########################')
    disp(F_ind1)
    disp('######################The performance on N_ind2 indicator is###########################')
    disp(N_ind2)
end