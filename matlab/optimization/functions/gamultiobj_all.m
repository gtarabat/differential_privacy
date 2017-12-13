function [x,y,exitflag,output] = gamultiobj_all(fit_all, obj_options, options)


xLast = []; % Last place computeall was called
myf   = []; % Use for objective at xLast
myc   = []; % Use for nonlinear inequality constraint
myceq = []; % Use for nonlinear equality constraint






if obj_options.constraints

    fun = @objfun; % the objective function, nested below
    cfun = @constr; % the constraint function, nested below
    [x,y,exitflag,output] = gamultiobj(fun,     obj_options.nvars, [],[],[],[], obj_options.lb, obj_options.ub, cfun, options);

else
    
    [x,y,exitflag,output] = gamultiobj(fit_all, obj_options.nvars, [],[],[],[], obj_options.lb, obj_options.ub, [],   options);

end

    
    function y = objfun(x)
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = fit_all(x);
            xLast = x;
        end
        y = myf;
    end



    function [c,ceq] = constr(x)
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = fit_all(x);
            xLast = x;
        end
        c = myc;
        ceq = myceq;
    end





end