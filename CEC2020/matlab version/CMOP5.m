function varargout = CMOP5(Operation,Global,input)
% <problem> <A>
% Benchmark Functions for the CEC¡¯2020 Special Session and Competition on 
% Constrained Multi-Objective Optimization
% operator --- EAreal

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

    switch Operation
        case 'init'
            Global.M        = 2;
            Global.D        = 25;
            Global.lower    = zeros(1,Global.D);
            Global.upper    = ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            [~,D]  = size(PopDec);
            M      = Global.M;
            g      = 1 + sum(1 - exp(-10*((PopDec(:,M:end).^(D-M)) - 0.5 - ((M:D) - 1)/(2*D)).^2),2);
            
            PopObj(:,1) = g.*PopDec(:,1);
            PopObj(:,2) = g.*(1 - (PopObj(:,1)./g).^0.6);
            
            t1 = (1 - 0.64*PopObj(:,1).^2 - PopObj(:,2)).*(1 - 0.36*PopObj(:,1).^2 - PopObj(:,2));
            t2 = (1.35*1.35 - (PopObj(:,1) + 0.35).^2 - PopObj(:,2)).*(1.15*1.15 - (PopObj(:,1) + 0.15).^2 - PopObj(:,2));
            PopCon = min(t1,t2);
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF5.dat');
            varargout = {f(:,1:2)};
    end
end
