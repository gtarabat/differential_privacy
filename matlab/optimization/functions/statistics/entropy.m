function E = entropy( x , N )   

if( nargin < 2)
    N = min([max([0.1*length(x),10]),50]);
end
    
[ f, edges ] = histcounts( x, N );

f( f==0 ) = 1; % consider at least one observation. to make the computation stable.

f = f/sum(f);

dx = edges(2)-edges(1);

E = - sum( f .* log(f/dx) );