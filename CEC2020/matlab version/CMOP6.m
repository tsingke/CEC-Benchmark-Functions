function varargout = CMOP6(Operation,Global,input)
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
            Global.upper    = 1.414213562373*ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            M      = Global.M;
            g      = 1 + sum(2*(PopDec(:,M:end) + (PopDec(:,M-1:end-1) - 0.5).^2 - 1).^2,2);
            
            PopObj(:,1) = g.*PopDec(:,1);
            PopObj(:,2) = g.*sqrt(2 - (PopObj(:,1)./g).^2);

            PopCon(:,1) = -1*(3 - PopObj(:,1).^2 - PopObj(:,2)).*(3 - 2*PopObj(:,1).^2 - PopObj(:,2));
            PopCon(:,2) =    (3 - 0.625*PopObj(:,1).^2 - PopObj(:,2)).*(3 - 7*PopObj(:,1).^2 - PopObj(:,2));
            PopCon(:,3) = -1*(1.62 - 0.18*PopObj(:,1).^2 - PopObj(:,2)).*(1.125 - 0.125*PopObj(:,1).^2 - PopObj(:,2));
            PopCon(:,4) =    (2.07 - 0.23*PopObj(:,1).^2 - PopObj(:,2)).*(0.63 - 0.07*PopObj(:,1).^2 - PopObj(:,2));
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF6.dat');
            varargout = {f(:,1:2)};
    end
end