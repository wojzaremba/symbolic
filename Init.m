function Init(opt)
    clc;
    addpath(genpath('.'));
    global expr_type debug complexity
    % Two options : Zp, and symbolic. Zp is much faster.            
    if (isfield(opt, 'expr_type'))        
        expr_type = opt.expr_type;
    else
        expr_type = 'Zp';
    end
    
    % Two options : big O complexity, vs NrOper.
    if (isfield(opt, 'complexity'))        
        complexity = opt.complexity;
    else
        complexity = 'O'; 
    end    
    
    if (isfield(opt, 'debug'))        
        debug = opt.debug;
    else
        debug = 0;
    end       
    
    % Indicates for which power we are looking for a formula discovery.    
    if (isfield(opt, 'power'))        
        power = opt.power;
    else
        power = 2; 
    end           
    Cache(power, opt.vars);    
end