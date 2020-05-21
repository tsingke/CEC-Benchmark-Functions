function varargout = CMOP7(Operation,Global,input)
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
            Global.D        = 6;
            Global.lower    = [0,78,33,27,27,27];
            Global.upper    = [1,102,45,45,45,45];
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            g      = 5.3578547*PopDec(:, 4).^2 + 0.8356891*PopDec(:, 2).*PopDec(:, 6) + 37.293239*PopDec(:, 2) - 40792.141 + 30665.5386717834 + 1;
            
            PopObj(:,1) = PopDec(:,1);
            PopObj(:,2) = g.*(1.0 - sqrt(PopObj(:,1))./g);
            
            PopCon(:,1) = 1 - PopObj(:,1).^2 - PopObj(:,2).^2;
            PopCon(:,2) = + 85.334407 + 0.0056858*PopDec(:, 3).*PopDec(:, 6) + 0.0006262*PopDec(:, 2).*PopDec(:, 5) - 0.0022053*PopDec(:, 4).*PopDec(:, 6) - 92;
            PopCon(:,3) = - 85.334407 - 0.0056858*PopDec(:, 3).*PopDec(:, 6) - 0.0006262*PopDec(:, 2).*PopDec(:, 5) + 0.0022053*PopDec(:, 4).*PopDec(:, 6);
            PopCon(:,4) = + 80.51249 + 0.0071317*PopDec(:, 3).*PopDec(:, 6) + 0.0029955*PopDec(:, 2).*PopDec(:, 3) + 0.0021813*PopDec(:, 4).^2 - 110;
            PopCon(:,5) = - 80.51249 - 0.0071317*PopDec(:, 3).*PopDec(:, 6) - 0.0029955*PopDec(:, 2).*PopDec(:, 3) - 0.0021813 *PopDec(:, 4).^2 + 90;
            PopCon(:,6) = + 9.300961 + 0.0047026 *PopDec(:, 4).*PopDec(:, 6) + 0.0012547 *PopDec(:, 2).*PopDec(:, 4) + 0.0019085 *PopDec(:, 4) .*PopDec(:, 5) - 25;
            PopCon(:,7) = - 9.300961 - 0.0047026 *PopDec(:, 4).*PopDec(:, 6) - 0.0012547 *PopDec(:, 2).*PopDec(:, 4) - 0.0019085 *PopDec(:, 4) .*PopDec(:, 5) + 20;
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF7.dat');
            varargout = {f(:,1:2)};
    end
end