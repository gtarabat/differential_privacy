function y = fitness_3d( theta, options )


p = zeros(options.Ns,1);
u = zeros(options.Ns,1);

for i = 1 : options.Ns
    [ms,e] = options.mask( theta );
    p(i)   = options.privacy( e  );
    u(i)   = options.utility( ms );
end

mx = max( std(p), std(u) );


y = [ mean(p) ; mean(u) ; -mx ];


y = -y;