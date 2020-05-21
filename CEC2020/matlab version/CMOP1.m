function varargout = CMOP1(Operation,Global,input)
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
            PopObj(:,2) = g.*sqrt(1 - (PopObj(:,1)./g).^2);
            
            PopCon(:,1) = PopObj(:,1).^2 + PopObj(:,2).^2 - (1.7 - LA(0.2,2,1,1,atan(PopObj(:,2)./PopObj(:,1)))).^2;
            t = 0.5*pi - 2*abs(atan(PopObj(:,2)./PopObj(:,1)) - 0.25*pi);
            PopCon(:,2) = (1 + LA(0.5,6,3,1,t)).^2 - PopObj(:,1).^2 - PopObj(:,2).^2;
            PopCon(:,3) = (1 - LA(0.45,6,3,1,t)).^2 - PopObj(:,1).^2 - PopObj(:,2).^2;
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f = textread('PF1.dat');
            varargout = {f(:,1:2)};
    end
end

function answer = LA(A,B,C,D,thera)
    t = thera.^C;
    answer = A*sin(B*t).^D; 
end