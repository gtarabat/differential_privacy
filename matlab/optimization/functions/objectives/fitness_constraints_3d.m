function [ y , c, ceq ] = fitness_constraints_3d( theta, options )

p  = zeros(options.Ns,1);
u  = zeros(options.Ns,1);
um = zeros(options.Ns,1);
us = zeros(options.Ns,1);


for i = 1 : options.Ns
    [ms,e] = options.mask( theta );
    p(i)   = options.privacy( e  );
    [ u(i), m, s, ~ ]   = options.utility( ms );
    um(i) = m;
    us(i) = s;
end


mx = max( std(p), std(u) );


y = [ mean(p) ; mean(u) ; -mx ];


c(1) = abs(mean(um)) - 0.1;
c(2) = mean(us) - 0.1;


ceq = [];


y = - y ;


