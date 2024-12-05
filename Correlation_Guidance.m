function Offspring = Correlation_Guidance(Particle,Pbest,Gbest,PreCurx, R, RThreshold)
    global Global
    W = 0.4;
    ParticleDec = decs(Particle);
    PbestDec    = decs(Pbest);
    GbestDec    = decs(Gbest);
    [N,D]       = size(ParticleDec);
    ParticleVel = vels(Particle);

    %% Particle swarm update
    r1        = rand(N,D);
    r2        = rand(N,D);
    Rm        = repmat((RThreshold-R)/((1+RThreshold)*Global.n),N,D)+randn(N,D)*0.1;
    OffVel    = W.*ParticleVel + r1.*(PbestDec-ParticleDec) + r2.*(GbestDec-ParticleDec) + Rm.*(repmat(PreCurx,N,1)-ParticleDec);
    OffDec    = ParticleDec + OffVel;
    EvalObj   = eval([Global.Problem '.obj(OffDec, PreCurx)']);
    OffObj    = EvalObj(:,1);
    Offspring = PopStruct(OffDec, OffObj, OffVel);
    Global.DataBase  = [Global.DataBase, Offspring];
end