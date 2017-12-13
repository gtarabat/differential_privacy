clear; clc

obj_case = '2d';
constraints = true;
mask_name = 'sine'; % sine or laplace
nvars = 3;

if(constraints)
    cstr = 'cns';
else
    cstr = 'unc';
end

clear file_name
data_folder = '../data/';
file_name = [ mask_name '_' num2str(nvars) '_' obj_case '_' cstr   ];
load( fullfile(data_folder,file_name) );

d = size(y,2);

%%
f1 = figure(1); clf
f1.Position = [569         254        1323        1091];
p = plot( y(:,1), y(:,2),'p');
p.MarkerSize = 10;

xlabel('privacy');
ylabel('utility');

legend('$\;$Pareto Front');


set(findall(f1,'-property','FontSize'),'FontSize',35)
set(findall(f1,'-property','FontName'),'FontName','Times')
set(findall(f1,'-property','Interpreter'),'Interpreter','Latex')

axis tight
grid on

saveas(gca, fullfile(data_folder,['par_' file_name '.eps']),'epsc');


%%

f2 = figure(2); clf
f2.Position = [569         254        1323        1091];

[~,ind] = sort(x);
p = semilogx( x(ind,1), y(ind,1),'.');
p.MarkerSize = 20;
p.LineWidth = 3;

hold on

p = semilogx( x(ind,1), y(ind,2),'x');
p.MarkerSize = 10;
p.LineWidth = 3;


xlabel('$\vartheta$');
ylabel('objective function value');

legend('$\;$privacy','$\;$utility');


set(findall(f2,'-property','FontSize'),'FontSize',35)
set(findall(f2,'-property','FontName'),'FontName','Times')
set(findall(f2,'-property','Interpreter'),'Interpreter','Latex')

axis tight
grid on


saveas(gca, fullfile(data_folder,['ovp_' file_name '.eps']),'epsc');


