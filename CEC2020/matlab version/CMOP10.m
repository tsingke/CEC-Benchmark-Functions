function varargout = CMOP10(Operation,Global,input)
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
            Global.M        = 3;
            Global.D        = 10;
            Global.lower    = [0,0, 500,1000,5000,100,100,100,100,100];
            Global.upper    = [1,1,1000,2000,6000,500,500,500,500,500];
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            g	   = PopDec(:,3) + PopDec(:,4) + PopDec(:,5) - 7048.2480205286;
            
            PopObj(:,1) = g.*PopDec(:,1).*PopDec(:,2);
            PopObj(:,2) = g.*PopDec(:,1).*(1 - PopDec(:,2));
            PopObj(:,3) = g.*(1 - PopDec(:,1));
            
            PopCon(:,1) = (0.4 - PopObj(:,3)).*(PopObj(:,3) - 0.6);
            
            PopCon(:,2) = -1 + 0.0025*(PopDec(:,6) + PopDec(:,8));
            PopCon(:,3) = -1 + 0.0025*(PopDec(:,7) + PopDec(:,9) - PopDec(:,6));
            PopCon(:,4) = -1 + 0.01*(PopDec(:,10) - PopDec(:,7));
            PopCon(:,5) = -PopDec(:,3).*PopDec(:,8) + 833.33252*PopDec(:,6) + 100*PopDec(:,3) - 83333.333;
            PopCon(:,6) = -PopDec(:,4).*PopDec(:,9) + 1250*PopDec(:,7) + PopDec(:,4).* PopDec(:,6) - 1250 * PopDec(:,6);
            PopCon(:,7) = -PopDec(:,5).*PopDec(:,10) + 1250000 + PopDec(:,5).* PopDec(:,7) - 2500 * PopDec(:,7);
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF10.dat');
            varargout = {f(:,1:3)};
    end
end