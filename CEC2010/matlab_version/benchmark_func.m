
function fit = benchmark_func(x, func_num)
global initial_flag jrandflag jrand lb ub
persistent fhd

if (initial_flag == 0)
    % Search Range
    if (func_num == 1 | func_num == 4 | func_num == 7 | func_num == 8 | func_num == 9 | func_num == 12 | func_num == 13 | func_num == 14 | func_num == 17 | func_num == 18 | func_num == 19 | func_num == 20)
        lb = -100;
        ub = 100;
    end
    if (func_num == 2 | func_num == 5 | func_num == 10 | func_num == 15)
        lb = -5;
        ub = 5;
    end
    if (func_num == 3 | func_num == 6 | func_num == 11 | func_num == 16)
        lb = -32;
        ub = 32;
    end
    
    % Separable, D = 1000
	if (func_num ==  1) fhd = str2func('elliptic_shift_func');
    elseif (func_num ==  2) fhd = str2func('rastrigin_shift_func');
    elseif (func_num ==  3) fhd = str2func('ackley_shift_func');
    % Single-group m-nonseparable, D = 1000, m = 50
	elseif (func_num ==  4) fhd = str2func('elliptic_group1_shift_rot_func');
    elseif (func_num ==  5) fhd = str2func('rastrigin_group1_shift_rot_func');
    elseif (func_num ==  6) fhd = str2func('ackley_group1_shift_rot_func');
    elseif (func_num ==  7) fhd = str2func('schwefel_group1_shift_func');
    elseif (func_num ==  8) fhd = str2func('rosenbrock_group1_shift_func');
    % D/(2m)-group m-nonseparable, D = 1000, m = 50
	elseif (func_num ==  9) fhd = str2func('elliptic_group10_shift_rot_func');
    elseif (func_num == 10) fhd = str2func('rastrigin_group10_shift_rot_func');
    elseif (func_num == 11) fhd = str2func('ackley_group10_shift_rot_func');
    elseif (func_num == 12) fhd = str2func('schwefel_group10_shift_func');
    elseif (func_num == 13) fhd = str2func('rosenbrock_group10_shift_func');
    % D/m-group m-nonseparable, D = 1000, m = 50
	elseif (func_num == 14) fhd = str2func('elliptic_group20_shift_rot_func');
    elseif (func_num == 15) fhd = str2func('rastrigin_group20_shift_rot_func');
    elseif (func_num == 16) fhd = str2func('ackley_group20_shift_rot_func');
    elseif (func_num == 17) fhd = str2func('schwefel_group20_shift_func');
    elseif (func_num == 18) fhd = str2func('rosenbrock_group20_shift_func');
    % Fully-nonseparable, D = 1000
	elseif (func_num == 19) fhd = str2func('schwefel_shift_func');
    elseif (func_num == 20) fhd = str2func('rosenbrock_shift_func');
    end
	jrandflag = 0;
	if (jrandflag == 1)
		jrand = Randomizer(func_num);
	end
end

fit = feval(fhd, x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sphere Function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = sphere_func(x)

fit = sum(x.*x, 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elliptic Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = elliptic_func(x)

[ps, D] = size(x);
a = 1e+6;
fit = 0;
for i = 1:D
   fit = fit+a.^((i-1)/(D-1)).*x(:,i).^2;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotated Elliptic Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = elliptic_rot_func(x, M)

x = x*M;
fit = elliptic_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Schwefel's Problem 1.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = schwefel_func(x)

[ps D] = size(x);
fit = 0;
for i = 1:D
	fit = fit + sum(x(:,1:i),2).^2;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rosenbrock's Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rosenbrock_func(x)

[ps D] = size(x);
fit = sum(100.*(x(:,1:D-1).^2-x(:,2:D)).^2+(x(:,1:D-1)-1).^2,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rastrigin's Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rastrigin_func(x)

fit = sum(x.*x-10*cos(2*pi*x)+10, 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotated Rastrigin's Fucntion 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rastrigin_rot_func(x, M)

x = x*M;
fit = rastrigin_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ackley's Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = ackley_func(x)

[ps, D] = size(x);
fit = sum(x.^2,2);
fit = 20-20.*exp(-0.2.*sqrt(fit./D))-exp(sum(cos(2.*pi.*x),2)./D)+exp(1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotated Ackley's Function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = ackley_rot_func(x, M)

x = x*M;
fit = ackley_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F1: Shifted Elliptic Function
% D = 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = elliptic_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o

[ps D] = size(x);
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
		save 'datafiles/f01_o.mat' o;
    else
		load 'datafiles/f01_o.mat';
		o = o(1:D);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = elliptic_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F2: Shifted Rastrigin's Function
% D = 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rastrigin_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o

[ps D] = size(x);
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
		save 'datafiles/f02_o.mat' o;
    else
		load 'datafiles/f02_o.mat';
		o = o(1:D);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = rastrigin_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F3: Shifted Ackley's Function
% D = 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = ackley_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o

[ps D] = size(x);
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
		save 'datafiles/f03_o.mat' o;
    else
		load 'datafiles/f03_o.mat' o;
		o = o(1:D);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = ackley_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F4: Single Group Shifted and Rotated Elliptic Function
% D = 1000, m = 50
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = elliptic_group1_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
        M = jrand.createRotMatrix(m);
		save 'datafiles/f04_opm.mat' o p M;
    else
		load 'datafiles/f04_opm.mat';
    end
    if (D ~= 1000)
        disp('F4 error: only support D = 1000 now');
        exit(4);
    end
	initial_flag = 1;
end

a = 1e+6;
x = x-repmat(o,ps,1);
fit = a*elliptic_rot_func(x(:,p(1:m)), M) + elliptic_func(x(:,p((m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F5: Single Group Shifted and Rotated Rastrigin's Function
% D = 1000, m = 50
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rastrigin_group1_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f05_opm.mat' o p M;
    else
		load 'datafiles/f05_opm.mat';
    end
    if (D ~= 1000)
        disp('F5 error: only support D = 1000 now');
        exit(5);
    end
	initial_flag = 1;
end

a = 1e+6;
x = x-repmat(o,ps,1);
fit = a*rastrigin_rot_func(x(:,p(1:m)), M) + rastrigin_func(x(:,p((m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F6: Single Group Shifted and Rotated Ackley's Function
% D = 1000, m = 50
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = ackley_group1_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f06_opm.mat' o p M;
    else
		load 'datafiles/f06_opm.mat';
    end
    if (D ~= 1000)
        disp('F6 error: only support D = 1000 now');
        exit(6);
    end
	initial_flag = 1;
end

a = 1e+6;
x = x-repmat(o,ps,1);
fit = a*ackley_rot_func(x(:,p(1:m)), M) + ackley_func(x(:,p((m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F7: Single Group Shifted Schwefel's Problem 1.2
% D = 1000, m = 50
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = schwefel_group1_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p

[ps D] = size(x);
m = 50;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		save 'datafiles/f07_op.mat' o p;
    else
		load 'datafiles/f07_op.mat';
    end
    if (D ~= 1000)
        disp('F7 error: only support D = 1000 now');
        exit(7);
    end
	initial_flag = 1;
end

a = 1e+6;
x = x-repmat(o,ps,1);
fit = a*schwefel_func(x(:,p(1:m))) + sphere_func(x(:,p((m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F8: Single Group Shifted Rosenbrock's Function
% D = 1000, m = 50
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rosenbrock_group1_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p

[ps D] = size(x);
m = 50;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub-1);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		save 'datafiles/f08_op.mat' o p;
    else
		load 'datafiles/f08_op.mat';
    end
    if (D ~= 1000)
        disp('F8 error: only support D = 1000 now');
        exit(8);
    end
	initial_flag = 1;
end

a = 1e+6;
x = x-repmat(o,ps,1);
fit = a*rosenbrock_func(x(:,p(1:m))) + sphere_func(x(:,p((m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F9: D/(2m)-group Shifted and Rotated Elliptic Function
% D = 1000, m = 50, D/(2m) = 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = elliptic_group10_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
G = D/m/2;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f09_opm.mat' o p M;
    else
		load 'datafiles/f09_opm.mat';
    end
    if (D ~= 1000)
        disp('F9 error: only support D = 1000 now');
        exit(9);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + elliptic_rot_func(x(:,p(index)), M);
end
fit = fit + elliptic_func(x(:,p((G*m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F10: D/(2m)-group Shifted and Rotated Rastrigin's Function
% D = 1000, m = 50, D/(2m) = 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rastrigin_group10_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
G = D/m/2;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f10_opm.mat' o p M;
    else
		load 'datafiles/f10_opm.mat';
    end
    if (D ~= 1000)
        disp('F10 error: only support D = 1000 now');
        exit(10);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + rastrigin_rot_func(x(:,p(index)), M);
end
fit = fit + rastrigin_func(x(:,p((G*m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F11: D/(2m)-group Shifted and Rotated Ackley's Function
% D = 1000, m = 50, D/(2m) = 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = ackley_group10_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
G = D/m/2;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f11_opm.mat' o p M;
    else
		load 'datafiles/f11_opm.mat';
    end
    if (D ~= 1000)
        disp('F11 error: only support D = 1000 now');
        exit(11);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + ackley_rot_func(x(:,p(index)), M);
end
fit = fit + ackley_func(x(:,p((G*m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F12: D/(2m)-group Shifted Schwefel's Problem 1.2
% D = 1000, m = 50, D/(2m) = 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = schwefel_group10_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p

[ps D] = size(x);
m = 50;
G = D/m/2;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		save 'datafiles/f12_op.mat' o p;
    else
		load 'datafiles/f12_op.mat';
    end
    if (D ~= 1000)
        disp('F12 error: only support D = 1000 now');
        exit(12);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + schwefel_func(x(:,p(index)));
end
fit = fit + sphere_func(x(:,p((G*m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F13: D/(2m)-group Shifted Rosenbrock's Function
% D = 1000, m = 50, D/(2m) = 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rosenbrock_group10_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p

[ps D] = size(x);
m = 50;
G = D/m/2;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub-1);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		save 'datafiles/f13_op.mat' o p;
    else
		load 'datafiles/f13_op.mat';
    end
    if (D ~= 1000)
        disp('F13 error: only support D = 1000 now');
        exit(13);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + rosenbrock_func(x(:,p(index)));
end
fit = fit + sphere_func(x(:,p((G*m+1):end)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F14: D/m-group Shifted and Rotated Elliptic Function
% D = 1000, m = 50, D/m = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = elliptic_group20_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
G = D/m;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f14_opm.mat' o p M;
    else
		load 'datafiles/f14_opm.mat';
    end
    if (D ~= 1000)
        disp('F14 error: only support D = 1000 now');
        exit(14);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + elliptic_rot_func(x(:,p(index)), M);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F15: D/m-group Shifted and Rotated Rastrigin's Function
% D = 1000, m = 50, D/m = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rastrigin_group20_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
G = D/m;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f15_opm.mat' o p M;
    else
		load 'datafiles/f15_opm.mat';
    end
    if (D ~= 1000)
        disp('F15 error: only support D = 1000 now');
        exit(15);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + rastrigin_rot_func(x(:,p(index)), M);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F16: D/m-group Shifted and Rotated Ackley's Function
% D = 1000, m = 50, D/m = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = ackley_group20_shift_rot_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p M

[ps D] = size(x);
m = 50;
G = D/m;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		M = jrand.createRotMatrix(m);
		save 'datafiles/f16_opm.mat' o p M;
    else
		load 'datafiles/f16_opm.mat';
    end
    if (D ~= 1000)
        disp('F16 error: only support D = 1000 now');
        exit(16);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + ackley_rot_func(x(:,p(index)), M);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F17: D/m-group Shifted Schwefel's Problem 1.2
% D = 1000, m = 50, D/m = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = schwefel_group20_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p

[ps D] = size(x);
m = 50;
G = D/m;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		save 'datafiles/f17_op.mat' o p;
    else
		load 'datafiles/f17_op.mat';
    end
    if (D ~= 1000)
        disp('F17 error: only support D = 1000 now');
        exit(17);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + schwefel_func(x(:,p(index)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F18: D/m-group Shifted Rosenbrock's Function
% D = 1000, m = 50, D/m = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rosenbrock_group20_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o p

[ps D] = size(x);
m = 50;
G = D/m;
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub-1);
        o = o';
        p = jrand.createPermVector(D);
        p = p'+1;
		save 'datafiles/f18_op.mat' o p;
    else
		load 'datafiles/f18_op.mat';
    end
    if (D ~= 1000)
        disp('F18 error: only support D = 1000 now');
        exit(18);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = 0;
for k = 1:G
    index = ((k-1)*m+1):(k*m);
    fit = fit + rosenbrock_func(x(:,p(index)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F19: Shifted Schwefel's Problem 1.2
% D = 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = schwefel_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o

[ps D] = size(x);
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub);
        o = o';
		save 'datafiles/f19_o.mat' o;
    else
		load 'datafiles/f19_o.mat';
    end
    if (D ~= 1000)
        disp('F19 error: only support D = 1000 now');
        exit(19);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = schwefel_func(x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F20: Shifted Rosenbrock's Function
% D = 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fit = rosenbrock_shift_func(x)
global initial_flag jrandflag jrand lb ub
persistent o

[ps D] = size(x);
if (initial_flag == 0)
    if (jrandflag == 1)
        o = jrand.createShiftVector(D, lb, ub-1);
        o = o';
		save 'datafiles/f20_o.mat' o;
    else
		load 'datafiles/f20_o.mat';
    end
    if (D ~= 1000)
        disp('F20 error: only support D = 1000 now');
        exit(20);
    end
	initial_flag = 1;
end

x = x-repmat(o,ps,1);
fit = rosenbrock_func(x);

