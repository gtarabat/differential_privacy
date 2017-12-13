clc; clear

addpath(genpath('functions'));

% data_folder='../data/';
% data_file = 'data.mat';

data_folder='../../python/privacy/data/';
data_file = 'data.txt';

load(fullfile(data_folder,data_file));

%%
obj_case = '3d';
constraints = true;
mask_name = 'laplace'; % sine or laplace
alpha = [ 0.2 0.4 0.4 ];
gamma = [ 0.2 0.4 0.4 ];
nvars = 1;
agg   = @sum;

%%

mask = str2func([ 'mask_' mask_name ] );

obj_options.constraints = constraints;
obj_options.Ns    = 10;
obj_options.lb    = 0.0001;
obj_options.ub    = 20;
obj_options.nvars = nvars;

obj_options.mask    = @(theta) mask( data, theta );
obj_options.privacy = @(error) privacy( error, alpha );
obj_options.utility = @(mdata) utility( data, mdata, gamma, agg);


opt_options = optimoptions(@gamultiobj);
opt_options.PopulationSize = 1000;
opt_options.MaxGenerations = 1000;
opt_options.PlotFcn = @(options,state,flag) gaplotpareto(options,state,flag,[1 2 3]);

%%
switch( obj_case )
    
    case '2d'
        if(constraints)
            fun = @(theta) fitness_constraints_2d( theta, obj_options );
        else
            fun = @(theta) fitness_2d( theta, obj_options );
        end
        
    case '3d'
        if(constraints)
            fun = @(theta) fitness_constraints_3d( theta, obj_options );
        else
            fun = @(theta) fitness_3d( theta, obj_options );
        end
        
end
    

[ x, y, exitflag, output ] = gamultiobj_all( fun, obj_options, opt_options );


%%
if(constraints)
    cstr = 'cns';
else
    cstr = 'unc';
end

file_name = [ mask_name '_' num2str(nvars) '_' obj_case '_' cstr   ];
save(fullfile(data_folder,file_name));

rmpath(genpath('functions'));