function varargout = CMOP9(Operation,Global,input)
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
            Global.lower    = [0,0,0,0,100,6.3,5.9,4.5];
            Global.upper    = [1,1000,40,40,300,6.7,6.4,6.25];
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            g      = PopDec(:, 2) - 193.724510070035 + 1;
            
            PopObj(:,1) = PopDec(:,1);
            PopObj(:,2) = g - PopObj(:,1).^(1/2);
            
            PopCon(:,1) = 1 - PopObj(:,1) - PopObj(:,2);
            PopCon(:,2) = 1 - PopObj(:,1) - PopObj(:,2) + abs(sin(10*pi*(PopObj(:,1) - PopObj(:,2) + 1)));
            PopCon(:,3) = (PopObj(:,1) - 0.8).*(PopObj(:,2) - 0.6);
            PopCon(:,4) = - PopDec(:, 2) + 35 * PopDec(:, 3).^0.6 + 35 * PopDec(:, 4).^0.6;
            PopCon(:,5) = abs(-300 * PopDec(:, 4) + 7500 * PopDec(:, 6) - 7500 * PopDec(:, 7) - 25 * PopDec(:, 5).* PopDec(:, 6) + 25 * PopDec(:, 5).* PopDec(:, 7) + PopDec(:, 4).* PopDec(:, 5)) - 0.0001;
            PopCon(:,6) = abs(100 * PopDec(:, 3) + 155.365 * PopDec(:, 5) + 2500 * PopDec(:, 8) - PopDec(:, 3).* PopDec(:, 5) - 25 * PopDec(:, 5).* PopDec(:, 8) - 15536.5) - 0.0001;
            PopCon(:,7) = abs(- PopDec(:, 6) + log( - PopDec(:, 5) + 900)) - 0.0001;
            PopCon(:,8) = abs(- PopDec(:, 7) + log(PopDec(:, 5) + 300)) - 0.0001;
            PopCon(:,9) = abs(- PopDec(:, 8) + log(-2 * PopDec(:, 5) + 700)) - 0.0001;
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF9.dat');
            varargout = {f(:,1:2)};
    end
end