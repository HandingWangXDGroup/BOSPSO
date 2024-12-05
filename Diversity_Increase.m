function Offspring = Diversity_Increase(Particle,Pbest,Gbest,PreCurx, MaxDist)
    global Global
    W = 0.4;
    ParticleDec = decs(Particle);
    PbestDec    = decs(Pbest);
    GbestDec    = decs(Gbest);
    [N,D]       = size(ParticleDec);
    ParticleVel = vels(Particle);

    %% Particle swarm optimization
    r1        = rand(N,D)*0.5;
    r2        = rand(N,D)*0.5;
    r3        = randn(N,D)*ceil(MaxDist)*0.1;
    OffVel    = W.*ParticleVel + r1.*(PbestDec-ParticleDec) + r2.*(GbestDec-ParticleDec) + r3;
    OffDec    = ParticleDec + OffVel;
    Dist      = pdist2(OffDec, PreCurx);
    idx       = (Dist>ceil(MaxDist));
    SubDec = [];
    for i = 1: sum(idx)
        point = randn(1, D);
        distance = norm(point);
        point = point / distance;
        point = point * (rand()^(1/D)) * ceil(MaxDist);
        point = point + PreCurx;
        SubDec = [SubDec; point];
    end
    OffDec(idx,:) = SubDec;
    EvalObj   = eval([Global.Problem '.obj(OffDec, PreCurx)']);
    OffObj    = EvalObj(:,1);
    Offspring = PopStruct(OffDec, OffObj, OffVel);
    Global.DataBase  = [Global.DataBase, Offspring];
end