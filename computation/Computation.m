classdef Computation < handle
    properties
        name
        dim1
        dim2
        domain % 0 for natural, 1 for exp.
    end
    
    methods
        function obj = Computation()
            ret.domain = 0;            
        end                
        
        function ret = complexity(obj)
            global complexity
            ret = eval(sprintf('obj.%s_complexity();', complexity));
        end
        
        
        function str = toString(obj)
            str = matlab_toString(obj);
        end
        
    end
end