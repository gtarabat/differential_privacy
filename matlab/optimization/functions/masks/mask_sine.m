function [ y, e ] = mask_sine( s, theta )

K = size(theta);

r = random('Uniform',0,1, [size(s,1), size(s,2), K]);

e = zeros(size(s,1), size(s,2));

for k=1:K
    e = e + theta(k)*sin(2*pi*r).^(2*k+1);
end
y = s + e;

e = abs(e./s);