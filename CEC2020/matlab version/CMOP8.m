function varargout = CMOP8(Operation,Global,input)
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
            Global.D        = 8;
            Global.lower    = [0, -10, -10, -10, -10, -10, -10, -10];
            Global.upper    = [1,  10,  10,  10,  10,  10,  10,  10];
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            g      = (PopDec(:, 2) - 10).^2 + 5*(PopDec(:, 3) - 12).^2 + PopDec(:, 4).^4 + 3*(PopDec(:, 5) - 11).^2 + 10*PopDec(:, 6).^6 + ...
                     7*PopDec(:, 7).^2 + PopDec(:, 8).^4 - 4*PopDec(:, 7).*PopDec(:, 8) - 10*PopDec(:, 7) - 8*PopDec(:, 8) - 680.6300573745 + 1;
            
            PopObj(:,1) = PopDec(:,1);
            PopObj(:,2) = g - PopObj(:,1).^(1/2);
            
            PopCon(:,1) = 1 - PopObj(:,1) - PopObj(:,2);
            PopCon(:,2) = 1 - PopObj(:,1) - PopObj(:,2) + abs(sin(10*pi*(PopObj(:,1) - PopObj(:,2) + 1)));
            PopCon(:,3) = -127 + 2 * PopDec(:, 2).^2 + 3 * PopDec(:, 3).^4 + PopDec(:, 4) + 4 * PopDec(:, 5).^2 + 5 * PopDec(:, 6);
            PopCon(:,4) = -282 + 7 * PopDec(:, 2) + 3 * PopDec(:, 3) + 10 * PopDec(:, 4).^2 + PopDec(:, 5) - PopDec(:, 6);
            PopCon(:,5) = -196 + 23 * PopDec(:, 2) + PopDec(:, 3).^2 + 6 * PopDec(:, 7).^2 - 8 * PopDec(:, 8);
            PopCon(:,6) = 4 * PopDec(:, 2).^2 + PopDec(:, 3).^2 - 3 * PopDec(:, 2).* PopDec(:, 3) + 2 * PopDec(:, 4).^2 + 5 * PopDec(:, 7) - 11 * PopDec(:, 8);
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF8.dat');
            varargout = {f(:,1:2)};
    end
end