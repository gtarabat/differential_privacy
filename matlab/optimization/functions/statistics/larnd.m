function y  = larnd( m, n, b )

u = rand(m, n) - 0.5;

y = - b * sign(u).* log(1- 2*abs(u));