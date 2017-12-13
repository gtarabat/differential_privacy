function y = privacy( e , a )


m = mean(e(:));
s = std(e(:));
h = entropy(e(:));

y = a(1)*m + a(2)*s + a(3)*h;