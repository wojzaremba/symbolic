classdef Computation < handle
    properties
        name
        complexity
        params
        dim1
        dim2
    end
    
    methods
        
        function str = toString(obj)
            str = matlab_toString(obj);
        end
        
    end
end