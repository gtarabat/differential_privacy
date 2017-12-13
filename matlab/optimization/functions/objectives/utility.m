    function [ y, m, s, h ] = utility( s, ms , a, g )

E = abs( ( g(s)-g(ms) ) ./ g(s) );


m = mean(E(:));
s = std(E(:));
h = entropy(E(:));

y = - a(1)*m - a(2)*s - a(3)*h;