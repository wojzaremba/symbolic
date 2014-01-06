classdef Computation < handle
    properties
        name
        dim1
        dim2
    end
    
    methods
        
        function ret = complexity(obj)
            global complexity
            ret = eval(sprintf('obj.%s_complexity();', complexity));
        end
        
        
        function str = toString(obj)
            str = matlab_toString(obj);
        end
        
    end
end