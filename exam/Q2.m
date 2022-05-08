% Dan Nguyen - z5206032
function [X, P] = Q2(u)
    A = [-0.9 0.2 0.2; 0.2 -1 0.2; 0.2 0.2 -1.1];
    B = [1; 0; 1];
    C = zeros(3, 3);
    D = zeros(3, 1);
    dt = 0.001;
    sd_u = 0.4;
    k_last = 20;
    X = [4; 4; 4];

    system = ss(A, B, C, D);
    discrete_system = c2d(system, dt);
    Pu = sd_u^2;
    
    a = discrete_system.A;
    b = discrete_system.B;
    
    for k = 1:k_last
        X = a.* X + b.* u;
        P = a * P * a' + b * Pu * b';
    end
end
