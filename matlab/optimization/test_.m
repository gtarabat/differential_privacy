clc; clear

addpath(genpath('functions'));

data_folder='../../python/privacy/data/';
data_file = 'data.txt';

load(fullfile(data_folder,data_file));

load(fullfile(data_folder,'e.txt'));



%%
obj_case = '2d';
constraints = true;
mask_name = 'laplace'; % sine or laplace
alpha = [0 0 1];
gamma = [0 0 1];
nvars = 1;
agg   = @sum;

%%

ms = data + e;
e = abs(e./data);

privacy(e,alpha)
utility(data,ms,gamma,@sum)

obj_options.utility = @(mdata) utility( data, mdata, gamma, agg);


%%








