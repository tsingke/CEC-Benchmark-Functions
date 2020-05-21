function varargout = CMOP4(Operation,Global,input)
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
            Global.upper    = 1.5*ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec    = repmat(Global.lower,input,1) + repmat(Global.upper-Global.lower,input,1).*rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            PopDec = input;
            [~,D]  = size(PopDec);
            M      = Global.M;
            z      = 1 - exp(-10*(PopDec(:,M:end) - ((M:D) - 1)/D).^2);
            g      = 1 + sum((1.5 + (0.1/D)*z.^2 - 1.5*cos(2*pi*z)),2);
            
            PopObj(:,1) = g.*PopDec(:,1);
            PopObj(:,2) = g.*(5 - exp(PopObj(:,1)./g) - abs(0.5*sin(3*pi*PopObj(:,1)./g)));

            PopCon(:,1) = -1*(5 - (1 + PopObj(:,1) + 0.5*PopObj(:,1).^2) - 0.5*sin(3*pi*PopObj(:,1)) - PopObj(:,2)).*(5 - (1 + 0.7*PopObj(:,1)) - 0.5*sin(3*pi*PopObj(:,1)) - PopObj(:,2));
            PopCon(:,2) =    (5 - exp(PopObj(:,1)) - 0.5*sin(3*pi*PopObj(:,1)) - PopObj(:,2)).*(5 - (1 + 0.4*PopObj(:,1)) - 0.5*sin(3*pi*PopObj(:,1)) - PopObj(:,2));
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF4.dat');
            varargout = {f(:,1:2)};
    end
end