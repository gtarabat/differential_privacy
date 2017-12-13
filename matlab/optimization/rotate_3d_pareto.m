clear; clc
addpath(genpath('functions/CaptureFigVid/'))

obj_case = '3d';
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

f1 = figure(1); clf
f1.Position = [1000         251        1318        1087];

% xlin = linspace(min(y(:,1)),max(y(:,1)),100);
% ylin = linspace(min(y(:,2)),max(y(:,2)),100);
% [X,Y] = meshgrid(xlin,ylin);
% f = scatteredInterpolant(y(:,1),y(:,2),y(:,3),'linear','none');
% Z = f(X,Y);
% mesh(X,Y,Z) %interpolated
% axis tight; hold on
p = plot3( y(:,1), y(:,2), y(:,3),'p');


p.MarkerSize = 10;
p.MarkerFaceColor=p.Color;
f1.Color = 'w';
xlabel('privacy');
ylabel('utility');
zlabel('spread');

set(findall(f1,'-property','FontSize'),'FontSize',35)
set(findall(f1,'-property','FontName'),'FontName','Times')
set(findall(f1,'-property','Interpreter'),'Interpreter','Latex')

ax=gca;
ax.LineWidth = 3;

grid on
%%

% daspect([1,1,.3]);
% axis tight;

OptionZ.FrameRate=15;
OptionZ.Duration=10;
OptionZ.Periodic=true;

CaptureFigVid( [-20,10; -110,10; -190,80; -290,10; -380,10], 'pareto_view', OptionZ )


%%

rmpath(genpath('functions/CaptureFigVid/'))